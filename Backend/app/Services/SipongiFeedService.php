<?php

namespace App\Services;

use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\Http;
use InvalidArgumentException;
use RuntimeException;

class SipongiFeedService
{
    public function getCached(string $feedKey): ?array
    {
        $this->ensureValidFeed($feedKey);

        return Cache::get($this->cacheKey($feedKey));
    }

    /**
     * @return array{status: string, feed: string, updated: bool, hash: string|null}
     */
    public function sync(string $feedKey): array
    {
        $config = $this->ensureValidFeed($feedKey);
        $cached = Cache::get($this->cacheKey($feedKey));

        $headers = [
            'Accept' => 'application/json',
        ];

        if (is_array($cached)) {
            if (! empty($cached['etag'])) {
                $headers['If-None-Match'] = $cached['etag'];
            }
            if (! empty($cached['last_modified'])) {
                $headers['If-Modified-Since'] = $cached['last_modified'];
            }
        }

        $response = Http::timeout((int) config('sipongi.http.timeout', 20))
            ->retry(
                (int) config('sipongi.http.retry_times', 2),
                (int) config('sipongi.http.retry_sleep_ms', 500),
                throw: false
            )
            ->withHeaders($headers)
            ->get($config['url'], $config['query'] ?? []);

        if ($response->status() === 304 && is_array($cached)) {
            $cached['checked_at'] = now()->toIso8601String();
            Cache::put($this->cacheKey($feedKey), $cached, $config['ttl']);

            return [
                'status' => 'not_modified',
                'feed' => $feedKey,
                'updated' => false,
                'hash' => $cached['hash'] ?? null,
            ];
        }

        if ($response->failed()) {
            throw new RuntimeException("Failed to fetch Sipongi feed [{$feedKey}] with HTTP {$response->status()}.");
        }

        $body = $response->body();
        $hash = hash('sha256', $body);

        if (is_array($cached) && ($cached['hash'] ?? null) === $hash) {
            $cached['checked_at'] = now()->toIso8601String();
            Cache::put($this->cacheKey($feedKey), $cached, $config['ttl']);

            return [
                'status' => 'unchanged',
                'feed' => $feedKey,
                'updated' => false,
                'hash' => $hash,
            ];
        }

        $parsed = json_decode($body, true, 512, JSON_THROW_ON_ERROR);

        $payload = [
            'feed' => $feedKey,
            'category' => $config['category'],
            'source_url' => $config['url'],
            'hash' => $hash,
            'etag' => $response->header('ETag'),
            'last_modified' => $response->header('Last-Modified'),
            'synced_at' => now()->toIso8601String(),
            'checked_at' => now()->toIso8601String(),
            'data' => $parsed,
        ];

        Cache::put($this->cacheKey($feedKey), $payload, $config['ttl']);

        return [
            'status' => 'updated',
            'feed' => $feedKey,
            'updated' => true,
            'hash' => $hash,
        ];
    }

    /**
     * @return array<int, string>
     */
    public function feedKeys(): array
    {
        return array_keys(config('sipongi.feeds', []));
    }

    private function ensureValidFeed(string $feedKey): array
    {
        $config = config("sipongi.feeds.{$feedKey}");

        if (! is_array($config)) {
            throw new InvalidArgumentException("Unknown Sipongi feed [{$feedKey}].");
        }

        return $config;
    }

    private function cacheKey(string $feedKey): string
    {
        return config('sipongi.cache_prefix', 'sipongi_feed:') . $feedKey;
    }
}

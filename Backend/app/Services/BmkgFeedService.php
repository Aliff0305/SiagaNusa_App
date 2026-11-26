<?php

namespace App\Services;

use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\Http;
use InvalidArgumentException;
use RuntimeException;

class BmkgFeedService
{
    /**
     * Get cached feed data, or return null if not yet synced.
     */
    public function getCached(string $feedKey): ?array
    {
        $this->ensureValidFeed($feedKey);

        return Cache::get($this->cacheKey($feedKey));
    }

    /**
     * Fetch feed from BMKG, parse it, and update cache only when content changes.
     *
     * @return array{status: string, feed: string, updated: bool, hash: string|null}
     */
    public function sync(string $feedKey): array
    {
        $config = $this->ensureValidFeed($feedKey);
        $url = $this->buildUrl($config);

        $cached = Cache::get($this->cacheKey($feedKey));
        $headers = [];

        if (is_array($cached)) {
            if (! empty($cached['etag'])) {
                $headers['If-None-Match'] = $cached['etag'];
            }
            if (! empty($cached['last_modified'])) {
                $headers['If-Modified-Since'] = $cached['last_modified'];
            }
        }

        $response = Http::timeout((int) config('bmkg.http.timeout', 15))
            ->retry(
                (int) config('bmkg.http.retry_times', 2),
                (int) config('bmkg.http.retry_sleep_ms', 500),
                throw: false
            )
            ->withHeaders($headers)
            ->get($url);

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
            throw new RuntimeException("Failed to fetch BMKG feed [{$feedKey}] with HTTP {$response->status()}.");
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

        $parsed = $this->parseBody($body, $config['format']);

        $payload = [
            'feed' => $feedKey,
            'category' => $config['category'],
            'format' => $config['format'],
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
     * List all configured feed keys, optionally filtered by category.
     *
     * @return array<int, string>
     */
    public function feedKeys(?string $category = null): array
    {
        $feeds = config('bmkg.feeds', []);

        if ($category === null) {
            return array_keys($feeds);
        }

        return array_keys(array_filter(
            $feeds,
            fn (array $feed): bool => ($feed['category'] ?? null) === $category
        ));
    }

    private function ensureValidFeed(string $feedKey): array
    {
        $config = config("bmkg.feeds.{$feedKey}");

        if (! is_array($config)) {
            throw new InvalidArgumentException("Unknown BMKG feed [{$feedKey}].");
        }

        return $config;
    }

    private function cacheKey(string $feedKey): string
    {
        return config('bmkg.cache_prefix', 'bmkg_feed:') . $feedKey;
    }

    private function buildUrl(array $config): string
    {
        $url = $config['url'];

        if (! empty($config['cache_bust'])) {
            $separator = str_contains($url, '?') ? '&' : '?';
            $url .= $separator . 't=' . (int) round(microtime(true) * 1000);
        }

        return $url;
    }

    private function parseBody(string $body, string $format): mixed
    {
        return match ($format) {
            'json', 'geojson' => json_decode($body, true, 512, JSON_THROW_ON_ERROR),
            'xml' => $this->parseXml($body),
            'txt' => $this->parseLines($body),
            default => $body,
        };
    }

    private function parseXml(string $body): array
    {
        $previous = libxml_use_internal_errors(true);
        $xml = simplexml_load_string($body, 'SimpleXMLElement', LIBXML_NOCDATA);

        if ($xml === false) {
            libxml_clear_errors();
            libxml_use_internal_errors($previous);
            throw new RuntimeException('Invalid XML payload received from BMKG.');
        }

        libxml_use_internal_errors($previous);

        return json_decode(json_encode($xml, JSON_THROW_ON_ERROR), true, 512, JSON_THROW_ON_ERROR);
    }

    /**
     * @return array<int, string>
     */
    private function parseLines(string $body): array
    {
        $lines = preg_split('/\r\n|\r|\n/', trim($body)) ?: [];

        return array_values(array_filter($lines, static fn (string $line): bool => $line !== ''));
    }
}

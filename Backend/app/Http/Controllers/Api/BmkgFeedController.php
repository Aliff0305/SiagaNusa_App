<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Services\BmkgFeedService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class BmkgFeedController extends Controller
{
    public function index(Request $request, BmkgFeedService $service): JsonResponse
    {
        $category = $request->query('category');
        $feeds = config('bmkg.feeds', []);
        $items = [];

        foreach ($feeds as $key => $config) {
            if ($category !== null && ($config['category'] ?? null) !== $category) {
                continue;
            }

            $cached = $service->getCached($key);

            $items[$key] = [
                'category' => $config['category'],
                'format' => $config['format'],
                'description' => $config['description'],
                'sync_interval_minutes' => $config['sync_interval_minutes'],
                'cached' => $cached !== null,
                'synced_at' => $cached['synced_at'] ?? null,
                'checked_at' => $cached['checked_at'] ?? null,
            ];
        }

        return response()->json([
            'feeds' => $items,
        ]);
    }

    public function show(string $feed, BmkgFeedService $service): JsonResponse
    {
        if (! array_key_exists($feed, config('bmkg.feeds', []))) {
            return response()->json([
                'message' => "Unknown BMKG feed [{$feed}].",
            ], 404);
        }

        $cached = $service->getCached($feed);

        if ($cached === null) {
            return response()->json([
                'message' => "BMKG feed [{$feed}] has not been synced yet.",
            ], 503);
        }

        return response()->json($cached);
    }

    public function category(string $category, BmkgFeedService $service): JsonResponse
    {
        $feeds = config('bmkg.feeds', []);
        $result = [];

        foreach ($feeds as $key => $config) {
            if (($config['category'] ?? null) !== $category) {
                continue;
            }

            $cached = $service->getCached($key);
            $result[$key] = [
                'description' => $config['description'],
                'format' => $config['format'],
                'cached' => $cached !== null,
                'synced_at' => $cached['synced_at'] ?? null,
                'data' => $cached['data'] ?? null,
            ];
        }

        if ($result === []) {
            return response()->json([
                'message' => "Unknown BMKG category [{$category}].",
            ], 404);
        }

        return response()->json([
            'category' => $category,
            'feeds' => $result,
        ]);
    }
}

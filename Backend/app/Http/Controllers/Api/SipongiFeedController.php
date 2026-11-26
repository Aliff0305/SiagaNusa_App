<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Services\SipongiFeedService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class SipongiFeedController extends Controller
{
    public function index(Request $request, SipongiFeedService $service): JsonResponse
    {
        $category = $request->query('category');
        $feeds = config('sipongi.feeds', []);
        $items = [];

        foreach ($feeds as $key => $config) {
            if ($category !== null && ($config['category'] ?? null) !== $category) {
                continue;
            }

            $cached = $service->getCached($key);

            $items[$key] = [
                'category' => $config['category'],
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

    public function show(string $feed, SipongiFeedService $service): JsonResponse
    {
        if (! array_key_exists($feed, config('sipongi.feeds', []))) {
            return response()->json([
                'message' => "Unknown Sipongi feed [{$feed}].",
            ], 404);
        }

        $cached = $service->getCached($feed);

        if ($cached === null) {
            return response()->json([
                'message' => "Sipongi feed [{$feed}] has not been synced yet.",
            ], 503);
        }

        return response()->json($cached);
    }
}

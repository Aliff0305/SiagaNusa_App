<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Campaign;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class CampaignController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $query = Campaign::with('user:id,name')->latest();

        if ($request->filled('category')) {
            $query->where('category', $request->query('category'));
        }

        if ($request->filled('status')) {
            $query->where('status', $request->query('status'));
        }

        return response()->json($query->paginate(15));
    }

    public function show(int $id): JsonResponse
    {
        $campaign = Campaign::with('user:id,name')->findOrFail($id);

        return response()->json([
            'data' => $campaign,
        ]);
    }

    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'title' => ['required', 'string', 'max:255'],
            'description' => ['required', 'string'],
            'category' => ['nullable', 'string', 'max:100'],
            'target_amount' => ['required', 'integer', 'min:10000'],
            'deadline' => ['required', 'date', 'after:today'],
            'image' => ['nullable', 'image', 'max:5120'],
        ]);

        $imagePath = $request->hasFile('image')
            ? $request->file('image')->store('campaigns', 'public')
            : null;

        $campaign = Campaign::create([
            'user_id' => $request->user()->id,
            'title' => $validated['title'],
            'description' => $validated['description'],
            'category' => $validated['category'] ?? 'bencana',
            'target_amount' => $validated['target_amount'],
            'deadline' => $validated['deadline'],
            'image_path' => $imagePath,
            'status' => 'active',
        ]);

        return response()->json([
            'message' => 'Kampanye donasi berhasil dibuat.',
            'data' => $campaign,
        ], 201);
    }
}

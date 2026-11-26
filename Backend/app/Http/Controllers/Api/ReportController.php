<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Report;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class ReportController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $query = Report::with('user:id,name,avatar')->latest();

        if ($request->filled('status')) {
            $query->where('status', $request->query('status'));
        }

        if ($request->filled('type')) {
            $query->where('disaster_type', $request->query('type'));
        }

        return response()->json($query->paginate(15));
    }

    public function my(Request $request): JsonResponse
    {
        $reports = Report::where('user_id', $request->user()->id)
            ->latest()
            ->paginate(15);

        return response()->json($reports);
    }

    public function show(int $id): JsonResponse
    {
        $report = Report::with('user:id,name,avatar')->findOrFail($id);

        return response()->json([
            'data' => $report,
        ]);
    }

    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'title' => ['required', 'string', 'max:255'],
            'description' => ['required', 'string'],
            'disaster_type' => ['required', 'string', 'max:100'],
            'latitude' => ['required', 'numeric', 'between:-90,90'],
            'longitude' => ['required', 'numeric', 'between:-180,180'],
            'location_name' => ['required', 'string', 'max:255'],
            'image' => ['nullable', 'image', 'max:5120'],
        ]);

        $imagePath = $request->hasFile('image')
            ? $request->file('image')->store('reports', 'public')
            : null;

        $report = Report::create([
            'user_id' => $request->user()->id,
            'title' => $validated['title'],
            'description' => $validated['description'],
            'disaster_type' => $validated['disaster_type'],
            'latitude' => $validated['latitude'],
            'longitude' => $validated['longitude'],
            'location_name' => $validated['location_name'],
            'image_path' => $imagePath,
            'status' => 'pending',
        ]);

        return response()->json([
            'message' => 'Laporan berhasil dikirim.',
            'data' => $report,
        ], 201);
    }
}

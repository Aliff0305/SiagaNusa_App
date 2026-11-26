<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\AppNotification;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class NotificationController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $notifications = AppNotification::where(function ($q) use ($request) {
            $q->where('user_id', $request->user()->id)
                ->orWhereNull('user_id');
        })
            ->latest()
            ->paginate(20);

        return response()->json($notifications);
    }

    public function show(Request $request, int $id): JsonResponse
    {
        $notification = AppNotification::where(function ($q) use ($request) {
            $q->where('user_id', $request->user()->id)
                ->orWhereNull('user_id');
        })->findOrFail($id);

        return response()->json([
            'data' => $notification,
        ]);
    }

    public function markAsRead(Request $request, int $id): JsonResponse
    {
        $notification = AppNotification::where(function ($q) use ($request) {
            $q->where('user_id', $request->user()->id)
                ->orWhereNull('user_id');
        })->findOrFail($id);

        if ($notification->read_at === null) {
            $notification->update(['read_at' => now()]);
        }

        return response()->json([
            'message' => 'Notifikasi ditandai sudah dibaca.',
            'data' => $notification,
        ]);
    }
}

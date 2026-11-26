<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Campaign;
use App\Models\Donation;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class DonationController extends Controller
{
    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'campaign_id' => ['required', 'integer', 'exists:campaigns,id'],
            'amount' => ['required', 'integer', 'min:1000'],
            'payment_method' => ['required', 'string', 'max:100'],
            'note' => ['nullable', 'string', 'max:500'],
        ]);

        $donation = DB::transaction(function () use ($validated, $request) {
            $campaign = Campaign::lockForUpdate()->findOrFail($validated['campaign_id']);
            $campaign->increment('collected_amount', $validated['amount']);

            return Donation::create([
                'user_id' => $request->user()->id,
                'campaign_id' => $campaign->id,
                'amount' => $validated['amount'],
                'payment_method' => $validated['payment_method'],
                'note' => $validated['note'] ?? null,
                'status' => 'paid',
            ]);
        });

        return response()->json([
            'message' => 'Donasi berhasil dikirim.',
            'data' => $donation->load('campaign:id,title'),
        ], 201);
    }

    public function my(Request $request): JsonResponse
    {
        $donations = Donation::with('campaign:id,title,image_path')
            ->where('user_id', $request->user()->id)
            ->latest()
            ->paginate(15);

        return response()->json($donations);
    }
}

<?php

use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\BmkgFeedController;
use App\Http\Controllers\Api\CampaignController;
use App\Http\Controllers\Api\DonationController;
use App\Http\Controllers\Api\NotificationController;
use App\Http\Controllers\Api\ReportController;
use App\Http\Controllers\Api\SipongiFeedController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

Route::prefix('bmkg')->group(function () {
    Route::get('/', [BmkgFeedController::class, 'index']);
    Route::get('/realtime', fn (\App\Services\BmkgFeedService $s) => app(BmkgFeedController::class)->category('realtime', $s));
    Route::get('/catalog', fn (\App\Services\BmkgFeedService $s) => app(BmkgFeedController::class)->category('catalog', $s));
    Route::get('/sensors', fn (\App\Services\BmkgFeedService $s) => app(BmkgFeedController::class)->category('sensor', $s));
    Route::get('/spatial', fn (\App\Services\BmkgFeedService $s) => app(BmkgFeedController::class)->category('spatial', $s));
    Route::get('/events/mmi', fn (\App\Services\BmkgFeedService $s) => app(BmkgFeedController::class)->show('stationlist_mmi', $s));
    Route::get('/{feed}', [BmkgFeedController::class, 'show']);
});

Route::prefix('sipongi')->group(function () {
    Route::get('/', [SipongiFeedController::class, 'index']);
    Route::get('/{feed}', [SipongiFeedController::class, 'show']);
});

// Autentikasi
Route::prefix('auth')->group(function () {
    Route::post('/register', [AuthController::class, 'register']);
    Route::post('/login', [AuthController::class, 'login']);
    Route::post('/logout', [AuthController::class, 'logout'])->middleware('auth:sanctum');
});

Route::put('/user/profile', [AuthController::class, 'updateProfile'])->middleware('auth:sanctum');

// Laporan Masyarakat
Route::prefix('reports')->group(function () {
    Route::get('/', [ReportController::class, 'index']);
    Route::get('/my', [ReportController::class, 'my'])->middleware('auth:sanctum');
    Route::get('/{id}', [ReportController::class, 'show']);
    Route::post('/', [ReportController::class, 'store'])->middleware('auth:sanctum');
});

// Donasi & Kampanye
Route::prefix('campaigns')->group(function () {
    Route::get('/', [CampaignController::class, 'index']);
    Route::get('/{id}', [CampaignController::class, 'show']);
    Route::post('/', [CampaignController::class, 'store'])->middleware('auth:sanctum');
});

Route::prefix('donations')->middleware('auth:sanctum')->group(function () {
    Route::post('/', [DonationController::class, 'store']);
    Route::get('/my', [DonationController::class, 'my']);
});

// Notifikasi & Peringatan Dini
Route::prefix('notifications')->middleware('auth:sanctum')->group(function () {
    Route::get('/', [NotificationController::class, 'index']);
    Route::get('/{id}', [NotificationController::class, 'show']);
    Route::patch('/{id}/read', [NotificationController::class, 'markAsRead']);
});

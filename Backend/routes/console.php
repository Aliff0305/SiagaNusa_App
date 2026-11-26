<?php

use App\Jobs\SyncBmkgFeedJob;
use App\Jobs\SyncSipongiFeedJob;
use App\Services\BmkgFeedService;
use App\Services\SipongiFeedService;
use Illuminate\Foundation\Inspiring;
use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\Schedule;

Artisan::command('inspire', function () {
    $this->comment(Inspiring::quote());
})->purpose('Display an inspiring quote');

Artisan::command('bmkg:sync {feed? : Specific feed key to sync}', function (BmkgFeedService $service, ?string $feed = null) {
    $feeds = $feed !== null ? [$feed] : $service->feedKeys();

    foreach ($feeds as $feedKey) {
        try {
            $result = $service->sync($feedKey);
            $this->info("[{$result['feed']}] {$result['status']}");
        } catch (\Throwable $e) {
            $this->error("[{$feedKey}] failed: {$e->getMessage()}");
        }
    }
})->purpose('Sync BMKG feeds into local cache');

foreach (config('bmkg.feeds', []) as $feedKey => $feedConfig) {
    $interval = (int) ($feedConfig['sync_interval_minutes'] ?? 5);

    $event = Schedule::job(new SyncBmkgFeedJob($feedKey));

    match (true) {
        $interval <= 1 => $event->everyMinute(),
        $interval === 2 => $event->everyTwoMinutes(),
        $interval <= 5 => $event->everyFiveMinutes(),
        $interval <= 10 => $event->everyTenMinutes(),
        $interval <= 15 => $event->everyFifteenMinutes(),
        $interval <= 60 => $event->hourly(),
        default => $event->daily(),
    };
}

Artisan::command('sipongi:sync {feed? : Specific Sipongi feed key to sync}', function (SipongiFeedService $service, ?string $feed = null) {
    $feeds = $feed !== null ? [$feed] : $service->feedKeys();

    foreach ($feeds as $feedKey) {
        try {
            $result = $service->sync($feedKey);
            $this->info("[{$result['feed']}] {$result['status']}");
        } catch (\Throwable $e) {
            $this->error("[{$feedKey}] failed: {$e->getMessage()}");
        }
    }
})->purpose('Sync Sipongi feeds into local cache');

foreach (config('sipongi.feeds', []) as $feedKey => $feedConfig) {
    $interval = (int) ($feedConfig['sync_interval_minutes'] ?? 5);

    $event = Schedule::job(new SyncSipongiFeedJob($feedKey));

    match (true) {
        $interval <= 1 => $event->everyMinute(),
        $interval === 2 => $event->everyTwoMinutes(),
        $interval <= 5 => $event->everyFiveMinutes(),
        $interval <= 10 => $event->everyTenMinutes(),
        $interval <= 15 => $event->everyFifteenMinutes(),
        $interval <= 60 => $event->hourly(),
        default => $event->daily(),
    };
}

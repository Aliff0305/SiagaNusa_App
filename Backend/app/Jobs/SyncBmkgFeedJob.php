<?php

namespace App\Jobs;

use App\Services\BmkgFeedService;
use Illuminate\Contracts\Queue\ShouldBeUnique;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Queue\Queueable;
use Illuminate\Support\Facades\Log;

class SyncBmkgFeedJob implements ShouldQueue, ShouldBeUnique
{
    use Queueable;

    public int $tries = 3;

    public int $backoff = 10;

    public int $uniqueFor = 60;

    public function __construct(
        public readonly string $feedKey
    ) {}

    public function uniqueId(): string
    {
        return 'bmkg-sync-' . $this->feedKey;
    }

    public function handle(BmkgFeedService $service): void
    {
        $result = $service->sync($this->feedKey);

        if ($result['updated']) {
            Log::info('BMKG feed updated in cache.', $result);
        }
    }
}

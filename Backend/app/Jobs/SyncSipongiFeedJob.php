<?php

namespace App\Jobs;

use App\Services\SipongiFeedService;
use Illuminate\Contracts\Queue\ShouldBeUnique;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Queue\Queueable;
use Illuminate\Support\Facades\Log;

class SyncSipongiFeedJob implements ShouldQueue, ShouldBeUnique
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
        return 'sipongi-sync-' . $this->feedKey;
    }

    public function handle(SipongiFeedService $service): void
    {
        $result = $service->sync($this->feedKey);

        if ($result['updated']) {
            Log::info('Sipongi feed updated in cache.', $result);
        }
    }
}

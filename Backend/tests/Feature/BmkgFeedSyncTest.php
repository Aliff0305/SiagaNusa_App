<?php

namespace Tests\Feature;

use App\Jobs\SyncBmkgFeedJob;
use App\Services\BmkgFeedService;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\Http;
use Tests\TestCase;

class BmkgFeedSyncTest extends TestCase
{
    protected function setUp(): void
    {
        parent::setUp();
        Cache::flush();
    }

    public function test_sync_caches_json_feed_and_skips_unchanged_payload(): void
    {
        Http::fake([
            'cdn.bmkg.go.id/datagempa.json*' => Http::response(['Infogempa' => ['gempa' => ['Magnitude' => '5.1']]], 200, [
                'ETag' => '"v1"',
            ]),
        ]);

        $service = app(BmkgFeedService::class);

        $first = $service->sync('datagempa');
        $this->assertSame('updated', $first['status']);
        $this->assertTrue($first['updated']);

        $second = $service->sync('datagempa');
        $this->assertSame('unchanged', $second['status']);
        $this->assertFalse($second['updated']);

        $this->getJson('/api/bmkg/datagempa')
            ->assertOk()
            ->assertJsonPath('feed', 'datagempa')
            ->assertJsonPath('data.Infogempa.gempa.Magnitude', '5.1');
    }

    public function test_sync_parses_xml_and_txt_feeds(): void
    {
        Http::fake([
            'cdn.bmkg.go.id/last30event.xml' => Http::response('<Infogempa><gempa><Magnitude>4.8</Magnitude></gempa></Infogempa>', 200),
            'cdn.bmkg.go.id/*' => Http::response("STATION_A | III MMI\nSTATION_B | II MMI\n", 200),
        ]);

        $service = app(BmkgFeedService::class);
        $service->sync('last30event');
        $service->sync('stationlist_mmi');

        $this->getJson('/api/bmkg/last30event')
            ->assertOk()
            ->assertJsonPath('data.gempa.Magnitude', '4.8');

        $this->getJson('/api/bmkg/stationlist_mmi')
            ->assertOk()
            ->assertJsonPath('data.0', 'STATION_A | III MMI')
            ->assertJsonPath('data.1', 'STATION_B | II MMI');
    }

    public function test_job_updates_cache_and_index_lists_feeds(): void
    {
        Http::fake([
            'cdn.bmkg.go.id/sensor_seismic.json' => Http::response(['sensors' => [['code' => 'JAK']]], 200),
        ]);

        (new SyncBmkgFeedJob('sensor_seismic'))->handle(app(BmkgFeedService::class));

        $this->getJson('/api/bmkg?category=sensor')
            ->assertOk()
            ->assertJsonPath('feeds.sensor_seismic.cached', true)
            ->assertJsonPath('feeds.sensor_global.cached', false);
    }

    public function test_uncached_and_unknown_feed_responses(): void
    {
        $this->getJson('/api/bmkg/datagempa')->assertStatus(503);
        $this->getJson('/api/bmkg/tidak_ada')->assertStatus(404);
    }
}

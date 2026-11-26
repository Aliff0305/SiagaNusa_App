<?php

return [
    'http' => [
        'timeout' => (int) env('BMKG_HTTP_TIMEOUT', 15),
        'retry_times' => (int) env('BMKG_HTTP_RETRY_TIMES', 2),
        'retry_sleep_ms' => (int) env('BMKG_HTTP_RETRY_SLEEP_MS', 500),
    ],

    'cache_prefix' => 'bmkg_feed:',

    'feeds' => [
        // A. Data Event Gempa (Real-time & Terkini)
        'datagempa' => [
            'url' => 'https://cdn.bmkg.go.id/datagempa.json',
            'category' => 'realtime',
            'format' => 'json',
            'cache_bust' => true,
            'ttl' => 120,
            'sync_interval_minutes' => 1,
            'description' => 'Data gempa bumi utama/terkini',
        ],
        'live30event' => [
            'url' => 'https://cdn.bmkg.go.id/live30event.xml',
            'category' => 'realtime',
            'format' => 'xml',
            'cache_bust' => false,
            'ttl' => 120,
            'sync_interval_minutes' => 1,
            'description' => '30 event gempa live (real-time)',
        ],
        'last30event' => [
            'url' => 'https://cdn.bmkg.go.id/last30event.xml',
            'category' => 'realtime',
            'format' => 'xml',
            'cache_bust' => false,
            'ttl' => 180,
            'sync_interval_minutes' => 2,
            'description' => '30 event gempa terakhir',
        ],
        'last30feltevent' => [
            'url' => 'https://cdn.bmkg.go.id/last30feltevent.xml',
            'category' => 'realtime',
            'format' => 'xml',
            'cache_bust' => false,
            'ttl' => 300,
            'sync_interval_minutes' => 2,
            'description' => '30 event gempa dirasakan terakhir',
        ],
        'last30tsunamievent' => [
            'url' => 'https://cdn.bmkg.go.id/last30tsunamievent.xml',
            'category' => 'realtime',
            'format' => 'xml',
            'cache_bust' => false,
            'ttl' => 180,
            'sync_interval_minutes' => 1,
            'description' => '30 event gempa berpotensi tsunami terakhir',
        ],
        '3mgempaql' => [
            'url' => 'https://cdn.bmkg.go.id/3mgempaQL.json',
            'category' => 'realtime',
            'format' => 'json',
            'cache_bust' => true,
            'ttl' => 300,
            'sync_interval_minutes' => 2,
            'description' => 'Data gempa Quick Look (3mgempaQL)',
        ],

        // B. Katalog & Histori Gempa
        'histori' => [
            'url' => 'https://cdn.bmkg.go.id/histori.json',
            'category' => 'catalog',
            'format' => 'json',
            'cache_bust' => true,
            'ttl' => 900,
            'sync_interval_minutes' => 10,
            'description' => 'Histori kejadian gempa bumi',
        ],
        'katalog_gempa' => [
            'url' => 'https://cdn.bmkg.go.id/katalog_gempa.json',
            'category' => 'catalog',
            'format' => 'json',
            'cache_bust' => true,
            'ttl' => 1800,
            'sync_interval_minutes' => 15,
            'description' => 'Katalog data gempa bumi',
        ],

        // C. Data Stasiun & Sensor Seismik
        'sensor_seismic' => [
            'url' => 'https://cdn.bmkg.go.id/sensor_seismic.json',
            'category' => 'sensor',
            'format' => 'json',
            'cache_bust' => false,
            'ttl' => 3600,
            'sync_interval_minutes' => 60,
            'description' => 'Daftar & status sensor seismik nasional',
        ],
        'sensor_global' => [
            'url' => 'https://cdn.bmkg.go.id/sensor_global.json',
            'category' => 'sensor',
            'format' => 'json',
            'cache_bust' => false,
            'ttl' => 3600,
            'sync_interval_minutes' => 60,
            'description' => 'Daftar & status sensor seismik global',
        ],

        // D. Data Spasial & Intensitas (MMI)
        'merged_fault' => [
            'url' => 'https://inatews.bmkg.go.id/assets_inatews/merged-fault.geojson',
            'category' => 'spatial',
            'format' => 'geojson',
            'cache_bust' => false,
            'ttl' => 86400,
            'sync_interval_minutes' => 1440,
            'description' => 'Peta garis patahan/sesar aktif (GeoJSON)',
        ],
        'stationlist_mmi' => [
            'url' => 'https://cdn.bmkg.go.id/20261104145634_rev%2Fstationlist_MMI.txt',
            'category' => 'event_detail',
            'format' => 'txt',
            'cache_bust' => false,
            'ttl' => 86400,
            'sync_interval_minutes' => 1440,
            'description' => 'Daftar stasiun & skala MMI untuk event spesifik',
        ],
    ],
];

<?php

return [
    'http' => [
        'timeout' => (int) env('SIPONGI_HTTP_TIMEOUT', 20),
        'retry_times' => (int) env('SIPONGI_HTTP_RETRY_TIMES', 2),
        'retry_sleep_ms' => (int) env('SIPONGI_HTTP_RETRY_SLEEP_MS', 500),
    ],

    'cache_prefix' => 'sipongi_feed:',

    'feeds' => [
        'hotspot' => [
            'url' => 'https://opsroom.sipongidata.my.id/api/opsroom/indoHotspot',
            'query' => [
                'wilayah' => 'IN',
                'filterperiode' => 'false',
                'from' => '',
                'to' => '',
                'late' => 24,
                'satelit' => ['NASA-MODIS', 'NASA-NOAA20', 'NASA-NOAA21', 'LPN-MODIS', 'LPN-NPP', 'LPN-NOAA20'],
                'confidence' => ['low', 'medium', 'high'],
                'provinsi' => '',
                'kabkota' => '',
            ],
            'category' => 'hotspot',
            'ttl' => 300,
            'sync_interval_minutes' => 5,
            'description' => 'Titik panas (hotspot) Indonesia 24 jam terakhir (GeoJSON)',
        ],
        'summary_hotspot' => [
            'url' => 'https://opsroom.sipongidata.my.id/api/getSummaryHotspot',
            'query' => [
                'late' => 24,
                'from' => '',
                'to' => '',
                'confidence' => ['low', 'medium', 'high'],
            ],
            'category' => 'hotspot',
            'ttl' => 300,
            'sync_interval_minutes' => 5,
            'description' => 'Ringkasan jumlah hotspot per satelit & confidence level',
        ],
        'sebaran' => [
            'url' => 'https://opsroom.sipongidata.my.id/api/sebaran',
            'query' => [
                'late' => 24,
                'satelit' => 'all-nasa-new',
                'confidence' => ['low', 'medium', 'high'],
                'provinsi' => '',
            ],
            'category' => 'hotspot',
            'ttl' => 300,
            'sync_interval_minutes' => 5,
            'description' => 'Daftar tabular sebaran titik panas 24 jam terakhir',
        ],
        'summary_kebakaran' => [
            'url' => 'https://opsroom.sipongidata.my.id/api/getSummaryKebakaran',
            'query' => [],
            'category' => 'statistics',
            'ttl' => 1800,
            'sync_interval_minutes' => 15,
            'description' => 'Ringkasan statistik luas kebakaran & penanganan tahunan',
        ],
        'pemadaman' => [
            'url' => 'https://opsroom.sipongidata.my.id/api/daops/pemadaman',
            'query' => [],
            'category' => 'operations',
            'ttl' => 900,
            'sync_interval_minutes' => 10,
            'description' => 'Data operasi pemadaman Manggala Agni (GeoJSON)',
        ],
        'aqms' => [
            'url' => 'https://opsroom.sipongidata.my.id/api/aqms',
            'query' => [],
            'category' => 'environment',
            'ttl' => 900,
            'sync_interval_minutes' => 15,
            'description' => 'Data stasiun kualitas udara / IKU (GeoJSON)',
        ],
        'provinsi' => [
            'url' => 'https://opsroom.sipongidata.my.id/api/getProvinsi/all',
            'query' => [],
            'category' => 'reference',
            'ttl' => 86400,
            'sync_interval_minutes' => 1440,
            'description' => 'Daftar referensi provinsi Sipongi',
        ],
        'boundaries_provinsi' => [
            'url' => 'https://opsroom-sipongi.gakkum.kehutanan.go.id/api/boundaries',
            'query' => [
                'level' => 'provinsi',
            ],
            'category' => 'spatial',
            'ttl' => 86400,
            'sync_interval_minutes' => 1440,
            'description' => 'Batas administratif provinsi Indonesia (GeoJSON)',
        ],
    ],
];

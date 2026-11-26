<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Peta Titik Kebakaran Hutan — SiagaNusa</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
</head>
<body class="bg-slate-950 text-slate-100 min-h-screen flex flex-col">
    <header class="border-b border-slate-800 bg-slate-900/70 backdrop-blur">
        <div class="max-w-6xl mx-auto px-6 py-4 flex items-center justify-between">
            <a href="/" class="text-xl font-bold tracking-tight text-emerald-400">SiagaNusa</a>
            <nav class="flex gap-6 text-sm font-medium">
                <a href="/" class="text-slate-300 hover:text-emerald-400 transition">Beranda</a>
                <a href="/map" class="text-white">Peta Kebakaran</a>
                <a href="/docs" class="text-slate-300 hover:text-emerald-400 transition">Docs API</a>
                <a href="/playbook" class="text-slate-300 hover:text-emerald-400 transition">Playbook</a>
            </nav>
        </div>
    </header>

    <main class="flex-1 max-w-6xl mx-auto px-6 py-8 w-full space-y-6">
        <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
            <div>
                <h1 class="text-2xl font-bold text-white">Peta Sebaran Titik Panas (Hotspot)</h1>
                <p class="text-sm text-slate-400">Sumber data: <code class="text-emerald-400">/api/sipongi/hotspot</code> (24 jam terakhir)</p>
            </div>
            <div class="flex flex-wrap items-center gap-3">
                <select id="confidenceFilter" class="rounded-lg bg-slate-900 border border-slate-700 px-3 py-2 text-sm text-white focus:outline-none focus:border-emerald-500">
                    <option value="all">Semua Confidence</option>
                    <option value="high">High</option>
                    <option value="medium">Medium</option>
                    <option value="low">Low</option>
                </select>
                <button id="refreshBtn" type="button" class="px-4 py-2 rounded-lg bg-emerald-500 hover:bg-emerald-400 text-slate-950 font-semibold text-sm transition cursor-pointer">
                    Muat Ulang
                </button>
            </div>
        </div>

        <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
            <div class="p-4 rounded-xl bg-slate-900 border border-slate-800">
                <div class="text-xs text-slate-400">Total Titik Ditampilkan</div>
                <div id="totalCount" class="text-2xl font-bold text-white mt-1">-</div>
            </div>
            <div class="p-4 rounded-xl bg-slate-900 border border-slate-800">
                <div class="text-xs text-slate-400">Confidence High</div>
                <div id="highCount" class="text-2xl font-bold text-rose-400 mt-1">-</div>
            </div>
            <div class="p-4 rounded-xl bg-slate-900 border border-slate-800">
                <div class="text-xs text-slate-400">Confidence Medium</div>
                <div id="mediumCount" class="text-2xl font-bold text-amber-400 mt-1">-</div>
            </div>
            <div class="p-4 rounded-xl bg-slate-900 border border-slate-800">
                <div class="text-xs text-slate-400">Terakhir Sync</div>
                <div id="syncedAt" class="text-sm font-mono text-emerald-400 mt-2">-</div>
            </div>
        </div>

        <div id="statusBanner" class="hidden p-3 rounded-lg bg-amber-500/10 border border-amber-500/30 text-amber-300 text-sm"></div>

        <div class="rounded-xl overflow-hidden border border-slate-800 bg-slate-900">
            <div id="map" class="w-full h-[560px]"></div>
        </div>
    </main>

    <script>
        const map = L.map('map').setView([-2.5, 118.0], 5);

        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            attribution: '&copy; OpenStreetMap contributors',
            maxZoom: 18,
        }).addTo(map);

        const hotspotLayer = L.layerGroup().addTo(map);
        let allFeatures = [];

        const confidenceColors = {
            high: '#f43f5e',
            medium: '#f59e0b',
            low: '#eab308',
        };

        function normalizeConfidence(level) {
            return String(level || 'low').toLowerCase();
        }

        function renderHotspots() {
            hotspotLayer.clearLayers();
            const filter = document.getElementById('confidenceFilter').value;

            let shown = 0;
            let high = 0;
            let medium = 0;

            allFeatures.forEach((feature) => {
                const props = feature.properties || {};
                const coords = feature.geometry?.coordinates;
                if (!Array.isArray(coords) || coords.length < 2) return;

                const conf = normalizeConfidence(props.confidence_level);
                if (conf === 'high') high++;
                if (conf === 'medium') medium++;

                if (filter !== 'all' && conf !== filter) return;

                shown++;
                const [lng, lat] = coords;
                const color = confidenceColors[conf] || '#eab308';

                const marker = L.circleMarker([lat, lng], {
                    radius: conf === 'high' ? 7 : 5,
                    color,
                    fillColor: color,
                    fillOpacity: 0.75,
                    weight: 1.5,
                });

                marker.bindPopup(`
                    <div style="min-width:200px;font-size:12px;line-height:1.5;color:#0f172a;">
                        <strong>${props.provinsi || 'Tidak diketahui'}</strong><br>
                        <span>Kab/Kota: ${props.kabkota || '-'}</span><br>
                        <span>Kec/Desa: ${props.kecamatan || '-'} / ${props.desa || '-'}</span><br>
                        <span>Satelit: ${props.sumber || '-'}</span><br>
                        <span>Confidence: <strong>${props.confidence_level || '-'}</strong></span><br>
                        <span>Waktu: ${props.date_hotspot || props.date_hotspot_ori || '-'}</span>
                    </div>
                `);

                marker.addTo(hotspotLayer);
            });

            document.getElementById('totalCount').textContent = shown;
            document.getElementById('highCount').textContent = high;
            document.getElementById('mediumCount').textContent = medium;
        }

        async function loadHotspots() {
            const banner = document.getElementById('statusBanner');
            banner.classList.add('hidden');

            try {
                const res = await fetch('/api/sipongi/hotspot', { headers: { 'Accept': 'application/json' } });
                const payload = await res.json();

                if (!res.ok) {
                    banner.textContent = payload.message || 'Data hotspot belum tersedia di cache. Jalankan php artisan sipongi:sync hotspot.';
                    banner.classList.remove('hidden');
                    allFeatures = [];
                    renderHotspots();
                    return;
                }

                allFeatures = payload?.data?.features || [];
                document.getElementById('syncedAt').textContent = payload.synced_at
                    ? new Date(payload.synced_at).toLocaleString('id-ID')
                    : '-';

                renderHotspots();
            } catch (err) {
                banner.textContent = 'Gagal memuat data hotspot: ' + err;
                banner.classList.remove('hidden');
            }
        }

        document.getElementById('confidenceFilter').addEventListener('change', renderHotspots);
        document.getElementById('refreshBtn').addEventListener('click', loadHotspots);

        loadHotspots();
    </script>
</body>
</html>

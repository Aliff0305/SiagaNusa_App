<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>API Playbook — SiagaNusa</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-slate-950 text-slate-100 min-h-screen flex flex-col">
    <header class="border-b border-slate-800 bg-slate-900/70 backdrop-blur">
        <div class="max-w-5xl mx-auto px-6 py-4 flex items-center justify-between">
            <a href="/" class="text-xl font-bold tracking-tight text-emerald-400">SiagaNusa</a>
            <nav class="flex gap-6 text-sm font-medium">
                <a href="/" class="text-slate-300 hover:text-emerald-400 transition">Beranda</a>
                <a href="/map" class="text-slate-300 hover:text-emerald-400 transition">Peta Kebakaran</a>
                <a href="/docs" class="text-slate-300 hover:text-emerald-400 transition">Docs API</a>
                <a href="/playbook" class="text-white">Playbook</a>
            </nav>
        </div>
    </header>

    <main class="flex-1 max-w-5xl mx-auto px-6 py-12 w-full space-y-8">
        <div>
            <h1 class="text-3xl font-bold text-white mb-2">API Playbook</h1>
            <p class="text-slate-400">Uji coba langsung endpoint SiagaNusa dari browser Anda.</p>
        </div>

        <div class="p-6 rounded-xl bg-slate-900 border border-slate-800 space-y-4">
            <label for="endpointSelect" class="block text-sm font-medium text-slate-300">Pilih Endpoint</label>
            <div class="flex flex-col sm:flex-row gap-3">
                <select id="endpointSelect" class="flex-1 rounded-lg bg-slate-950 border border-slate-700 px-4 py-2.5 text-sm text-white font-mono focus:outline-none focus:border-emerald-500">
                    <optgroup label="BMKG Kategori">
                        <option value="GET /api/bmkg">GET /api/bmkg</option>
                        <option value="GET /api/bmkg/realtime">GET /api/bmkg/realtime</option>
                        <option value="GET /api/bmkg/catalog">GET /api/bmkg/catalog</option>
                        <option value="GET /api/bmkg/sensors">GET /api/bmkg/sensors</option>
                        <option value="GET /api/bmkg/spatial">GET /api/bmkg/spatial</option>
                        <option value="GET /api/bmkg/events/mmi">GET /api/bmkg/events/mmi</option>
                    </optgroup>
                    <optgroup label="BMKG Feed Spesifik">
                        @foreach($feeds as $key => $feed)
                            <option value="GET /api/bmkg/{{ $key }}">GET /api/bmkg/{{ $key }} ({{ $feed['category'] }})</option>
                        @endforeach
                    </optgroup>
                    <optgroup label="Sipongi (Kebakaran &amp; Hotspot)">
                        <option value="GET /api/sipongi">GET /api/sipongi</option>
                        @foreach($sipongiFeeds as $key => $feed)
                            <option value="GET /api/sipongi/{{ $key }}">GET /api/sipongi/{{ $key }} ({{ $feed['category'] }})</option>
                        @endforeach
                    </optgroup>
                    <optgroup label="Autentikasi">
                        <option value="POST /api/auth/register">POST /api/auth/register</option>
                        <option value="POST /api/auth/login">POST /api/auth/login</option>
                        <option value="POST /api/auth/logout">POST /api/auth/logout</option>
                        <option value="PUT /api/user/profile">PUT /api/user/profile</option>
                    </optgroup>
                    <optgroup label="Laporan, Donasi &amp; Notifikasi">
                        <option value="GET /api/reports">GET /api/reports</option>
                        <option value="GET /api/reports/my">GET /api/reports/my</option>
                        <option value="POST /api/reports">POST /api/reports</option>
                        <option value="GET /api/campaigns">GET /api/campaigns</option>
                        <option value="POST /api/campaigns">POST /api/campaigns</option>
                        <option value="POST /api/donations">POST /api/donations</option>
                        <option value="GET /api/donations/my">GET /api/donations/my</option>
                        <option value="GET /api/notifications">GET /api/notifications</option>
                    </optgroup>
                </select>
                <button id="sendBtn" type="button" class="px-6 py-2.5 rounded-lg bg-emerald-500 hover:bg-emerald-400 text-slate-950 font-semibold text-sm transition cursor-pointer">
                    Kirim Request
                </button>
            </div>

            <div class="grid md:grid-cols-2 gap-4 pt-2">
                <div>
                    <label for="bearerToken" class="block text-xs font-medium text-slate-400 mb-1">Bearer Token (opsional, untuk endpoint Sanctum)</label>
                    <input id="bearerToken" type="text" placeholder="1|xxxxxxxxxxxxxxxxxxxx" class="w-full rounded-lg bg-slate-950 border border-slate-700 px-3 py-2 text-xs text-white font-mono focus:outline-none focus:border-emerald-500">
                </div>
                <div>
                    <label for="jsonBody" class="block text-xs font-medium text-slate-400 mb-1">JSON Body (untuk POST / PUT / PATCH)</label>
                    <textarea id="jsonBody" rows="3" placeholder='{"email": "user@example.com", "password": "password123"}' class="w-full rounded-lg bg-slate-950 border border-slate-700 px-3 py-2 text-xs text-white font-mono focus:outline-none focus:border-emerald-500"></textarea>
                </div>
            </div>
        </div>

        <div class="rounded-xl bg-slate-900 border border-slate-800 overflow-hidden">
            <div class="px-4 py-3 bg-slate-800/60 border-b border-slate-800 flex items-center justify-between text-xs">
                <span class="font-mono text-slate-300" id="requestUrl">Belum ada request</span>
                <div class="flex gap-4">
                    <span id="statusBadge" class="font-mono text-slate-400">Status: -</span>
                    <span id="latencyBadge" class="font-mono text-slate-400">Latency: -</span>
                </div>
            </div>
            <pre id="responseOutput" class="p-4 text-xs font-mono text-emerald-300 overflow-x-auto max-h-[520px] overflow-y-auto whitespace-pre-wrap">Klik "Kirim Request" untuk melihat respons JSON...</pre>
        </div>
    </main>

    <script>
        const select = document.getElementById('endpointSelect');
        const bearerToken = document.getElementById('bearerToken');
        const jsonBody = document.getElementById('jsonBody');
        const sendBtn = document.getElementById('sendBtn');
        const requestUrl = document.getElementById('requestUrl');
        const statusBadge = document.getElementById('statusBadge');
        const latencyBadge = document.getElementById('latencyBadge');
        const responseOutput = document.getElementById('responseOutput');

        sendBtn.addEventListener('click', async () => {
            const [method, url] = select.value.split(' ');
            requestUrl.textContent = `${method} ${url}`;
            statusBadge.textContent = 'Status: Loading...';
            latencyBadge.textContent = 'Latency: -';
            responseOutput.textContent = 'Mengambil data...';

            const headers = { 'Accept': 'application/json' };
            const token = bearerToken.value.trim();
            if (token) {
                headers['Authorization'] = `Bearer ${token}`;
            }

            const options = { method, headers };
            if (['POST', 'PUT', 'PATCH'].includes(method) && jsonBody.value.trim()) {
                headers['Content-Type'] = 'application/json';
                options.body = jsonBody.value.trim();
            }

            const start = performance.now();
            try {
                const res = await fetch(url, options);
                const elapsed = Math.round(performance.now() - start);
                statusBadge.textContent = `Status: ${res.status} ${res.statusText}`;
                latencyBadge.textContent = `Latency: ${elapsed} ms`;

                const text = await res.text();
                try {
                    const json = JSON.parse(text);
                    responseOutput.textContent = JSON.stringify(json, null, 2);
                } catch {
                    responseOutput.textContent = text;
                }
            } catch (err) {
                statusBadge.textContent = 'Status: Network Error';
                responseOutput.textContent = String(err);
            }
        });
    </script>
</body>
</html>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dokumentasi API — SiagaNusa</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-slate-950 text-slate-100 min-h-screen flex flex-col">
    <header class="border-b border-slate-800 bg-slate-900/70 backdrop-blur">
        <div class="max-w-5xl mx-auto px-6 py-4 flex items-center justify-between">
            <a href="/" class="text-xl font-bold tracking-tight text-emerald-400">SiagaNusa</a>
            <nav class="flex gap-6 text-sm font-medium">
                <a href="/" class="text-slate-300 hover:text-emerald-400 transition">Beranda</a>
                <a href="/map" class="text-slate-300 hover:text-emerald-400 transition">Peta Kebakaran</a>
                <a href="/docs" class="text-white">Docs API</a>
                <a href="/playbook" class="text-slate-300 hover:text-emerald-400 transition">Playbook</a>
            </nav>
        </div>
    </header>

    <main class="flex-1 max-w-5xl mx-auto px-6 py-12 w-full space-y-12">
        <div>
            <h1 class="text-3xl font-bold text-white mb-2">Dokumentasi API SiagaNusa</h1>
            <p class="text-slate-400">Seluruh endpoint mengembalikan format <code class="text-emerald-400">application/json</code> dari cache lokal yang disinkronkan di background.</p>
        </div>

        <section class="space-y-4">
            <h2 class="text-xl font-semibold text-white">Endpoint Kategori (Pemetaan)</h2>
            <div class="overflow-x-auto rounded-xl border border-slate-800 bg-slate-900">
                <table class="w-full text-left text-sm">
                    <thead class="bg-slate-800/70 text-slate-300">
                        <tr>
                            <th class="px-4 py-3">Method</th>
                            <th class="px-4 py-3">Endpoint</th>
                            <th class="px-4 py-3">Deskripsi</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-slate-800">
                        <tr>
                            <td class="px-4 py-3"><span class="px-2 py-0.5 rounded bg-emerald-500/20 text-emerald-400 font-mono text-xs">GET</span></td>
                            <td class="px-4 py-3 font-mono text-slate-200">/api/bmkg</td>
                            <td class="px-4 py-3 text-slate-400">Daftar semua feed &amp; status sync (opsional: <code class="text-slate-300">?category=realtime|catalog|sensor|spatial|event_detail</code>)</td>
                        </tr>
                        <tr>
                            <td class="px-4 py-3"><span class="px-2 py-0.5 rounded bg-emerald-500/20 text-emerald-400 font-mono text-xs">GET</span></td>
                            <td class="px-4 py-3 font-mono text-slate-200">/api/bmkg/realtime</td>
                            <td class="px-4 py-3 text-slate-400">Gabungan seluruh feed gempa real-time &amp; terkini</td>
                        </tr>
                        <tr>
                            <td class="px-4 py-3"><span class="px-4 py-0.5 rounded bg-emerald-500/20 text-emerald-400 font-mono text-xs">GET</span></td>
                            <td class="px-4 py-3 font-mono text-slate-200">/api/bmkg/catalog</td>
                            <td class="px-4 py-3 text-slate-400">Data histori &amp; katalog gempa bumi</td>
                        </tr>
                        <tr>
                            <td class="px-4 py-3"><span class="px-2 py-0.5 rounded bg-emerald-500/20 text-emerald-400 font-mono text-xs">GET</span></td>
                            <td class="px-4 py-3 font-mono text-slate-200">/api/bmkg/sensors</td>
                            <td class="px-4 py-3 text-slate-400">Daftar sensor seismik nasional &amp; global</td>
                        </tr>
                        <tr>
                            <td class="px-4 py-3"><span class="px-2 py-0.5 rounded bg-emerald-500/20 text-emerald-400 font-mono text-xs">GET</span></td>
                            <td class="px-4 py-3 font-mono text-slate-200">/api/bmkg/spatial</td>
                            <td class="px-4 py-3 text-slate-400">Data geospasial patahan aktif (GeoJSON)</td>
                        </tr>
                        <tr>
                            <td class="px-4 py-3"><span class="px-2 py-0.5 rounded bg-emerald-500/20 text-emerald-400 font-mono text-xs">GET</span></td>
                            <td class="px-4 py-3 font-mono text-slate-200">/api/bmkg/events/mmi</td>
                            <td class="px-4 py-3 text-slate-400">Daftar stasiun &amp; intensitas MMI untuk event spesifik</td>
                        </tr>
                        <tr>
                            <td class="px-4 py-3"><span class="px-2 py-0.5 rounded bg-emerald-500/20 text-emerald-400 font-mono text-xs">GET</span></td>
                            <td class="px-4 py-3 font-mono text-slate-200">/api/bmkg/{feed}</td>
                            <td class="px-4 py-3 text-slate-400">Mengambil data satu feed spesifik berdasarkan key</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </section>

        <section class="space-y-4">
            <h2 class="text-xl font-semibold text-white">Daftar Feed Tersedia ({feed})</h2>
            <div class="overflow-x-auto rounded-xl border border-slate-800 bg-slate-900">
                <table class="w-full text-left text-sm">
                    <thead class="bg-slate-800/70 text-slate-300">
                        <tr>
                            <th class="px-4 py-3">Key</th>
                            <th class="px-4 py-3">Kategori</th>
                            <th class="px-4 py-3">Format Sumber</th>
                            <th class="px-4 py-3">Interval Sync</th>
                            <th class="px-4 py-3">Deskripsi</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-slate-800">
                        @foreach($feeds as $key => $feed)
                        <tr>
                            <td class="px-4 py-3 font-mono text-emerald-400">{{ $key }}</td>
                            <td class="px-4 py-3 text-slate-300">{{ $feed['category'] }}</td>
                            <td class="px-4 py-3 uppercase text-xs text-slate-400">{{ $feed['format'] }}</td>
                            <td class="px-4 py-3 text-slate-400">{{ $feed['sync_interval_minutes'] }} menit</td>
                            <td class="px-4 py-3 text-slate-400">{{ $feed['description'] }}</td>
                        </tr>
                        @endforeach
                    </tbody>
                </table>
            </div>
        </section>

        <section class="space-y-4">
            <h2 class="text-xl font-semibold text-white">Endpoint Sipongi (Kebakaran &amp; Hotspot)</h2>
            <div class="overflow-x-auto rounded-xl border border-slate-800 bg-slate-900">
                <table class="w-full text-left text-sm">
                    <thead class="bg-slate-800/70 text-slate-300">
                        <tr>
                            <th class="px-4 py-3">Endpoint</th>
                            <th class="px-4 py-3">Kategori</th>
                            <th class="px-4 py-3">Interval Sync</th>
                            <th class="px-4 py-3">Deskripsi</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-slate-800">
                        <tr>
                            <td class="px-4 py-3 font-mono text-emerald-400">/api/sipongi</td>
                            <td class="px-4 py-3 text-slate-300">index</td>
                            <td class="px-4 py-3 text-slate-400">-</td>
                            <td class="px-4 py-3 text-slate-400">Daftar semua feed Sipongi &amp; status sync</td>
                        </tr>
                        @foreach($sipongiFeeds as $key => $feed)
                        <tr>
                            <td class="px-4 py-3 font-mono text-emerald-400">/api/sipongi/{{ $key }}</td>
                            <td class="px-4 py-3 text-slate-300">{{ $feed['category'] }}</td>
                            <td class="px-4 py-3 text-slate-400">{{ $feed['sync_interval_minutes'] }} menit</td>
                            <td class="px-4 py-3 text-slate-400">{{ $feed['description'] }}</td>
                        </tr>
                        @endforeach
                    </tbody>
                </table>
            </div>
        </section>

        <section class="space-y-4">
            <h2 class="text-xl font-semibold text-white">Endpoint Aplikasi (Auth, Laporan, Donasi &amp; Notifikasi)</h2>
            <div class="overflow-x-auto rounded-xl border border-slate-800 bg-slate-900">
                <table class="w-full text-left text-sm">
                    <thead class="bg-slate-800/70 text-slate-300">
                        <tr>
                            <th class="px-4 py-3">Method</th>
                            <th class="px-4 py-3">Endpoint</th>
                            <th class="px-4 py-3">Auth</th>
                            <th class="px-4 py-3">Deskripsi</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-slate-800">
                        <tr><td class="px-4 py-3 font-mono text-xs text-sky-400">POST</td><td class="px-4 py-3 font-mono text-slate-200">/api/auth/register</td><td class="px-4 py-3 text-slate-400">Public</td><td class="px-4 py-3 text-slate-400">Registrasi pengguna baru (<code class="text-slate-300">name, email, password, phone?</code>)</td></tr>
                        <tr><td class="px-4 py-3 font-mono text-xs text-sky-400">POST</td><td class="px-4 py-3 font-mono text-slate-200">/api/auth/login</td><td class="px-4 py-3 text-slate-400">Public</td><td class="px-4 py-3 text-slate-400">Login pengguna (<code class="text-slate-300">email, password</code>)</td></tr>
                        <tr><td class="px-4 py-3 font-mono text-xs text-sky-400">POST</td><td class="px-4 py-3 font-mono text-slate-200">/api/auth/logout</td><td class="px-4 py-3 text-amber-400">Sanctum</td><td class="px-4 py-3 text-slate-400">Logout &amp; hapus token aktif</td></tr>
                        <tr><td class="px-4 py-3 font-mono text-xs text-amber-400">PUT</td><td class="px-4 py-3 font-mono text-slate-200">/api/user/profile</td><td class="px-4 py-3 text-amber-400">Sanctum</td><td class="px-4 py-3 text-slate-400">Update profil (<code class="text-slate-300">name, phone, avatar?</code>)</td></tr>
                        <tr><td class="px-4 py-3 font-mono text-xs text-emerald-400">GET</td><td class="px-4 py-3 font-mono text-slate-200">/api/reports</td><td class="px-4 py-3 text-slate-400">Public</td><td class="px-4 py-3 text-slate-400">Daftar laporan bencana (opsional: <code class="text-slate-300">?status=&amp;type=</code>)</td></tr>
                        <tr><td class="px-4 py-3 font-mono text-xs text-emerald-400">GET</td><td class="px-4 py-3 font-mono text-slate-200">/api/reports/my</td><td class="px-4 py-3 text-amber-400">Sanctum</td><td class="px-4 py-3 text-slate-400">Riwayat laporan milik user</td></tr>
                        <tr><td class="px-4 py-3 font-mono text-xs text-emerald-400">GET</td><td class="px-4 py-3 font-mono text-slate-200">/api/reports/{id}</td><td class="px-4 py-3 text-slate-400">Public</td><td class="px-4 py-3 text-slate-400">Detail satu laporan</td></tr>
                        <tr><td class="px-4 py-3 font-mono text-xs text-sky-400">POST</td><td class="px-4 py-3 font-mono text-slate-200">/api/reports</td><td class="px-4 py-3 text-amber-400">Sanctum</td><td class="px-4 py-3 text-slate-400">Kirim laporan bencana baru</td></tr>
                        <tr><td class="px-4 py-3 font-mono text-xs text-emerald-400">GET</td><td class="px-4 py-3 font-mono text-slate-200">/api/campaigns</td><td class="px-4 py-3 text-slate-400">Public</td><td class="px-4 py-3 text-slate-400">Daftar kampanye donasi</td></tr>
                        <tr><td class="px-4 py-3 font-mono text-xs text-emerald-400">GET</td><td class="px-4 py-3 font-mono text-slate-200">/api/campaigns/{id}</td><td class="px-4 py-3 text-slate-400">Public</td><td class="px-4 py-3 text-slate-400">Detail kampanye donasi</td></tr>
                        <tr><td class="px-4 py-3 font-mono text-xs text-sky-400">POST</td><td class="px-4 py-3 font-mono text-slate-200">/api/campaigns</td><td class="px-4 py-3 text-amber-400">Sanctum</td><td class="px-4 py-3 text-slate-400">Buat kampanye donasi baru</td></tr>
                        <tr><td class="px-4 py-3 font-mono text-xs text-sky-400">POST</td><td class="px-4 py-3 font-mono text-slate-200">/api/donations</td><td class="px-4 py-3 text-amber-400">Sanctum</td><td class="px-4 py-3 text-slate-400">Kirim transaksi donasi</td></tr>
                        <tr><td class="px-4 py-3 font-mono text-xs text-emerald-400">GET</td><td class="px-4 py-3 font-mono text-slate-200">/api/donations/my</td><td class="px-4 py-3 text-amber-400">Sanctum</td><td class="px-4 py-3 text-slate-400">Riwayat donasi milik user</td></tr>
                        <tr><td class="px-4 py-3 font-mono text-xs text-emerald-400">GET</td><td class="px-4 py-3 font-mono text-slate-200">/api/notifications</td><td class="px-4 py-3 text-amber-400">Sanctum</td><td class="px-4 py-3 text-slate-400">Daftar notifikasi user &amp; peringatan dini</td></tr>
                        <tr><td class="px-4 py-3 font-mono text-xs text-emerald-400">GET</td><td class="px-4 py-3 font-mono text-slate-200">/api/notifications/{id}</td><td class="px-4 py-3 text-amber-400">Sanctum</td><td class="px-4 py-3 text-slate-400">Detail notifikasi</td></tr>
                        <tr><td class="px-4 py-3 font-mono text-xs text-purple-400">PATCH</td><td class="px-4 py-3 font-mono text-slate-200">/api/notifications/{id}/read</td><td class="px-4 py-3 text-amber-400">Sanctum</td><td class="px-4 py-3 text-slate-400">Tandai notifikasi sudah dibaca</td></tr>
                    </tbody>
                </table>
            </div>
        </section>

        <section class="space-y-3">
            <h2 class="text-xl font-semibold text-white">Kode Status HTTP</h2>
            <ul class="list-disc list-inside text-sm text-slate-400 space-y-1">
                <li><code class="text-emerald-400">200 OK</code> — Data tersedia di cache dan berhasil dikembalikan.</li>
                <li><code class="text-amber-400">503 Service Unavailable</code> — Feed valid, namun belum pernah disinkronkan ke cache (jalankan <code class="text-slate-300">php artisan bmkg:sync</code>).</li>
                <li><code class="text-rose-400">404 Not Found</code> — Nama feed atau kategori tidak ditemukan.</li>
            </ul>
        </section>
    </main>
</body>
</html>

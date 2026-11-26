<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SiagaNusa — Sistem Informasi Data Kebencanaan</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-slate-950 text-slate-100 min-h-screen flex flex-col">
    <header class="border-b border-slate-800 bg-slate-900/70 backdrop-blur">
        <div class="max-w-5xl mx-auto px-6 py-4 flex items-center justify-between">
            <a href="/" class="text-xl font-bold tracking-tight text-emerald-400">SiagaNusa</a>
            <nav class="flex gap-6 text-sm font-medium">
                <a href="/" class="text-white">Beranda</a>
                <a href="/map" class="text-slate-300 hover:text-emerald-400 transition">Peta Kebakaran</a>
                <a href="/docs" class="text-slate-300 hover:text-emerald-400 transition">Docs API</a>
                <a href="/playbook" class="text-slate-300 hover:text-emerald-400 transition">Playbook</a>
            </nav>
        </div>
    </header>

    <main class="flex-1 max-w-5xl mx-auto px-6 py-16 w-full">
        <div class="max-w-2xl">
            <span class="inline-block px-3 py-1 text-xs font-semibold rounded-full bg-emerald-500/10 text-emerald-400 border border-emerald-500/20 mb-4">
                BMKG &amp; InaTEWS Cache Gateway
            </span>
            <h1 class="text-4xl font-bold tracking-tight text-white mb-4">
                Agregasi Data Gempa &amp; Sensor Seismik Terpusat
            </h1>
            <p class="text-slate-400 text-lg leading-relaxed mb-8">
                SiagaNusa menyediakan layanan cache lokal dan sinkronisasi latar belakang (background sync) untuk data kebencanaan dari BMKG dan InaTEWS. Seluruh data diperbarui secara berkala agar aplikasi tetap cepat tanpa membebani server sumber.
            </p>
            <div class="flex flex-wrap gap-4">
                <a href="/docs" class="px-5 py-2.5 rounded-lg bg-emerald-500 hover:bg-emerald-400 text-slate-950 font-semibold text-sm transition">
                    Baca Dokumentasi API
                </a>
                <a href="/playbook" class="px-5 py-2.5 rounded-lg bg-slate-800 hover:bg-slate-700 text-white font-semibold text-sm border border-slate-700 transition">
                    Buka API Playbook
                </a>
            </div>
        </div>

        <div class="grid md:grid-cols-3 gap-6 mt-16">
            <div class="p-6 rounded-xl bg-slate-900 border border-slate-800">
                <h2 class="font-semibold text-white mb-2">Background Sync</h2>
                <p class="text-sm text-slate-400">Data real-time, katalog, sensor, dan geospasial disinkronkan otomatis sesuai prioritas interval.</p>
            </div>
            <div class="p-6 rounded-xl bg-slate-900 border border-slate-800">
                <h2 class="font-semibold text-white mb-2">Conditional Cache</h2>
                <p class="text-sm text-slate-400">Menggunakan ETag, Last-Modified, dan hash SHA-256 agar hanya memproses data yang berubah.</p>
            </div>
            <div class="p-6 rounded-xl bg-slate-900 border border-slate-800">
                <h2 class="font-semibold text-white mb-2">REST API Terstruktur</h2>
                <p class="text-sm text-slate-400">Seluruh feed JSON, XML, GeoJSON, dan TXT dinormalisasi menjadi JSON siap pakai.</p>
            </div>
        </div>
    </main>

    <footer class="border-t border-slate-800 py-6 text-center text-xs text-slate-500">
        SiagaNusa &copy; {{ date('Y') }}
    </footer>
</body>
</html>

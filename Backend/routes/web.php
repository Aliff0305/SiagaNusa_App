<?php

use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('welcome');
});

Route::get('/map', function () {
    return view('fire_map');
});

Route::get('/docs', function () {
    return view('docs', [
        'feeds' => config('bmkg.feeds', []),
        'sipongiFeeds' => config('sipongi.feeds', []),
    ]);
});

Route::get('/playbook', function () {
    return view('playbook', [
        'feeds' => config('bmkg.feeds', []),
        'sipongiFeeds' => config('sipongi.feeds', []),
    ]);
});

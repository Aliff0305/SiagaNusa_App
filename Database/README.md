# Database SiagaNusa

Dokumentasi skema dan diagram relasi entitas (*Entity Relationship Diagram*) yang digunakan oleh aplikasi **SiagaNusa** (`Backend/database/migrations/`).

---

## 1. Entity Relationship Diagram (ERD)

```mermaid
erDiagram
    users ||--o{ reports : "membuat"
    users ||--o{ campaigns : "menggalang"
    users ||--o{ donations : "berdonasi"
    users ||--o{ app_notifications : "menerima"
    campaigns ||--o{ donations : "menerima"

    users {
        bigint id PK
        string name
        string email UK
        string phone
        string avatar
        string password
        timestamp created_at
        timestamp updated_at
    }

    reports {
        bigint id PK
        bigint user_id FK
        string title
        text description
        string disaster_type
        decimal latitude
        decimal longitude
        string location_name
        string image_path
        string status
        timestamp created_at
        timestamp updated_at
    }

    campaigns {
        bigint id PK
        bigint user_id FK
        string title
        text description
        string category
        bigint target_amount
        bigint collected_amount
        date deadline
        string image_path
        string status
        timestamp created_at
        timestamp updated_at
    }

    donations {
        bigint id PK
        bigint user_id FK
        bigint campaign_id FK
        bigint amount
        string payment_method
        text note
        string status
        timestamp created_at
        timestamp updated_at
    }

    app_notifications {
        bigint id PK
        bigint user_id FK
        string title
        text body
        string type
        timestamp read_at
        timestamp created_at
        timestamp updated_at
    }
```

---

## 2. Daftar Tabel

| Tabel | Deskripsi | Relasi |
| :--- | :--- | :--- |
| `users` | Data pengguna aplikasi (warga/relawan) | `1:N` ke `reports`, `campaigns`, `donations`, `app_notifications` |
| `personal_access_tokens` | Token autentikasi API (Laravel Sanctum) | Polimorfik ke `users` |
| `reports` | Laporan kejadian bencana dari masyarakat | `N:1` ke `users` |
| `campaigns` | Kampanye penggalangan dana bencana | `N:1` ke `users`, `1:N` ke `donations` |
| `donations` | Transaksi donasi pengguna ke kampanye | `N:1` ke `users` dan `campaigns` |
| `app_notifications` | Notifikasi peringatan dini & info aplikasi | `N:1` ke `users` (nullable untuk broadcast) |

> File SQL lengkap tersedia di [`schema.sql`](./schema.sql).

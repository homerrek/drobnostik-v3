<div align="center">

<img src="images/logo.png" alt="Drobnostík" width="72" />

# Drobnostík v3

**Prémiový e-shop s 3D tisknutými Pokéboly · 🇨🇿 Made in Czech Republic**

[![Netlify Status](https://api.netlify.com/api/v1/badges/placeholder/deploy-status)](https://drobnostik.cz)
![JavaScript](https://img.shields.io/badge/JavaScript-ES2020-F7DF1E?logo=javascript&logoColor=black)
![Supabase](https://img.shields.io/badge/Supabase-PostgreSQL-3ECF8E?logo=supabase&logoColor=white)
![Netlify](https://img.shields.io/badge/Hosted%20on-Netlify-00C7B7?logo=netlify&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-c8a96a)
![No Build](https://img.shields.io/badge/Build%20step-none-success)
![Routes](https://img.shields.io/badge/Routes-55-blue)
![Tables](https://img.shields.io/badge/DB%20Tables-19-green)

[🌐 Live demo](https://drobnostik.cz) · [🐛 Nahlásit bug](../../issues) · [💬 Fórum](https://drobnostik.cz/forum)

</div>

---

## O projektu

Drobnostík je full-featured e-commerce **Single Page Application** postavená na čistém vanilla JavaScriptu — bez build kroků, frameworků nebo bundlerů. Backend tvoří Supabase (PostgreSQL + REST API), hosting zajišťuje Netlify.

> **Žádný npm. Žádný webpack. Žádný build krok.** Funguje hned po stažení.

---

## Tech stack

| Vrstva | Technologie |
|--------|-------------|
| Frontend | Vanilla JavaScript ES2020+, HTML5, CSS3 |
| Databáze | Supabase — PostgreSQL + REST API + Storage |
| Hosting | Netlify — CDN, SPA redirecty, hlavičky |
| Závislost | `supabase-js v2` — jediná, načítána z CDN |
| Router | Vlastní SPA router s async IIFE injekcí skriptů |

---

## Struktura projektu

```
drobnostik/
│
├── index.html              # SPA shell — header, footer, <script> tagy
├── netlify.toml            # SPA redirect + Cache-Control: no-store
├── .htaccess               # Apache fallback
│
├── config/
│   └── supabase-config.js  # async getSupabase() — čeká na CDN load
│
├── css/
│   └── style.css           # Kompletní design systém, dark/light, responzivita
│
├── js/                     # Globální skripty — načteny jednou v index.html
│   ├── utils.js            # showToast, formatPrice, escapeHtml, Storage, theme
│   ├── cart.js             # Košík + Wishlist (localStorage)
│   ├── shop.js             # loadShop, renderProductCard, autocomplete
│   ├── product.js          # loadProductDetail, galerie, recenze
│   ├── admin.js            # Admin CRUD, checkAdminAuth
│   ├── checkout.js         # Pokladna, validace, kupóny
│   ├── search.js           # Full-text vyhledávání, debounce
│   ├── widgets.js          # Rating, wishlist widgety
│   ├── features.js         # Achievements, cookie consent
│   └── router.js           # SPA router, goTo(), 55 rout
│
├── pages/                  # HTML fragmenty — načítány routerem
│   ├── *.html              # 35+ zákaznických stránek
│   └── admin/              # 12 admin stránek
│
├── images/                 # Obrázky produktů a webu
│
└── sql/
    ├── schema.sql          # 19 tabulek + RLS + triggery
    └── seed_full.sql       # Testovací data (45 produktů, 100+ řádků/tabulka)
```

---

## Jak router funguje

```
DOMContentLoaded
└── Router.load(path)
      ├── fetch('/pages/xxx.html?v=timestamp')   ← cache-bust
      ├── app.innerHTML = HTML fragment
      ├── <script> tagy → async IIFE             ← umožňuje top-level await
      │     (async function(){ CODE })().catch()
      ├── Promise.all(scriptPromises)             ← čeká na všechny skripty
      └── runPageScripts(path) → window.loadXxx()
```

55 rout — všechny ověřeny, soubory existují, funkce exportovány.

---

## Databáze — 19 tabulek

`sql/schema.sql` obsahuje kompletní schéma včetně RLS, triggerů a Storage bucketu.  
`sql/seed_full.sql` obsahuje testovací data — smaže stará a vloží nová.

<details>
<summary>Zobrazit všechny tabulky</summary>

| Tabulka | Popis |
|---------|-------|
| `products` | Produkty — ceny S/M/L, barvy, color_images, sku, stock |
| `orders` | Objednávky — zákazník, doprava, kupón, platba, stav |
| `order_items` | Položky objednávek |
| `reviews` | Recenze — hodnocení, schválení, verified |
| `faq` | FAQ s kategoriemi |
| `newsletter_subscribers` | Odběratelé emailů |
| `contact_messages` | Kontaktní formulář, B2B, live chat |
| `blog_posts` | Články — slug, kategorie, obrázek, status |
| `blog_comments` | Komentáře k článkům s lajky |
| `forum_threads` | Fórum vlákna — pinned, locked, views |
| `forum_replies` | Odpovědi s lajky |
| `coupons` | Slevové kódy — procent/fixní, limit, expirace |
| `support_tickets` | Tikety — SLA, priorita, stav |
| `support_ratings` | Hodnocení podpory |
| `affiliates` | Affiliate partneři — kód, provize, statistiky |
| `email_campaigns` | Kampaně — sent, opens, clicks |
| `email_templates` | Šablony s proměnnými |
| `settings` | Konfigurace obchodu |
| `inventory_log` | Automatický log změn skladu |

RLS zapnuto na všech tabulkách · auto-update `updated_at` · `GRANT ALL TO anon`

</details>

---

## Funkce

<details>
<summary><b>🛒 E-shop</b></summary>

- Košík a Wishlist v localStorage, badge v navigaci
- Full-text vyhledávání s autocomplete, debounce, URL parametr `?q=`
- Filtrování a řazení produktů
- Detail produktu — výběr barvy (dropdown ze Storage), výběr velikosti, dynamická cena
- Quick View modal
- Pokladna — validace, 3 způsoby dopravy, slevové kupóny
- Sledování zásilky — timeline stavů
- Srovnání produktů (až 3 vedle sebe)
- Dárkové poukazy, B2B velkoobchod

</details>

<details>
<summary><b>👤 Zákazník</b></summary>

- Věrnostní program — body, tiery Bronz / Stříbro / Zlato / Diamant
- Achievementy — 8 typů, gamifikace, referral kód
- Affiliate dashboard — statistiky, provize
- Blog s komentáři a reading progress barem
- Fórum — vlákna, odpovědi, pinned, locked
- Zákaznické tikety (TKT-XXXXXX) s SLA timerem

</details>

<details>
<summary><b>🔧 Admin panel</b></summary>

`/admin/login` · `admin / admin`

| Sekce | Funkce |
|-------|--------|
| Dashboard | Statistiky, poslední objednávky, nízký sklad |
| Produkty | CRUD + dropdown výběr obrázků ze Supabase Storage |
| Objednávky | Filtr stavu, detail, změna statusu |
| Zákazníci | Data z orders + reviews + tickets + newsletter |
| Sklad | Qty úpravy + auto-zápis do inventory_log |
| Tikety | SLA timer, priorita, filtr stavu |
| Email kampaně | Statistiky otevření a kliknutí |
| Import/Export | CSV import + **Image Manager** (upload, galerie) |

</details>

---

## Správa obrázků

Obrázky jsou uloženy v Supabase Storage (bucket `product-images`).

- Editor produktu → dropdown výběr existujících obrázků nebo přímý upload
- Image Manager (`/admin/import`) → drag & drop upload více souborů najednou, galerie, kopírovat URL
- Max 5 MB · JPEG, PNG, WebP, GIF · veřejné URL

---

## Design systém

```
Zlatá (akcent)  #c8a96a      Pozadí     #0a0a0a → #1a1a1a
Úspěch          #4f4         Chyba      #f44
Info            #4af         Varování   #fa0
```

| Breakpoint | Layout |
|------------|--------|
| > 1100px | Desktop — plný layout, 5-sloupcový footer |
| ≤ 1100px | Tablet — 3-sloupcový footer |
| ≤ 768px | Mobil — hamburger menu, 2-sloupcový footer |
| ≤ 480px | Malý mobil — kompaktní kartičky |

Light mode — přepínač ☀️/🌙, uloženo v localStorage.

---

## Bezpečnost

| Oblast | Řešení |
|--------|--------|
| XSS | `escapeHtml()` na všech user-generated stringách |
| Admin | `sessionStorage` token + `checkAdminAuth()` na každé stránce |
| Cache | `Cache-Control: no-store` v meta tazích, netlify.toml i .htaccess |
| Databáze | Row Level Security na všech 19 tabulkách |
| Platby | Platební údaje se **neukládají** — projekt nemá platební bránu |

---

## Licence

Distribuováno pod licencí **MIT**. Viz [`LICENSE`](LICENSE).

---

<div align="center">
  <sub>Vyrobeno s ❤️ v České republice · <a href="https://drobnostik.cz">drobnostik.cz</a></sub>
</div>

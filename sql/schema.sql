-- ═══════════════════════════════════════════════════════════════
-- Drobnostík v3 — KOMPLETNÍ SCHÉMA
-- Spustit v: https://supabase.com/dashboard/project/wwezzahputwjfzzhybny/sql/new
-- ═══════════════════════════════════════════════════════════════

-- Pomocná funkce pro auto-update updated_at
CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER AS $$
BEGIN NEW.updated_at = NOW(); RETURN NEW; END;
$$ LANGUAGE plpgsql;

-- ───────────────────────────────────────────
-- PRODUCTS
-- ───────────────────────────────────────────
CREATE TABLE IF NOT EXISTS products (
  id             BIGSERIAL PRIMARY KEY,
  name           VARCHAR(255) NOT NULL,
  sku            VARCHAR(100),
  category       VARCHAR(100),
  description    TEXT,
  price_small    INTEGER NOT NULL DEFAULT 0,
  price_standard INTEGER NOT NULL DEFAULT 0,
  price_maxi     INTEGER DEFAULT 0,
  material       VARCHAR(100),
  colors         TEXT[] DEFAULT ARRAY['black','white','gray'],
  sizes          TEXT[] DEFAULT ARRAY['Small','Standard','Maxi'],
  stock_quantity INTEGER DEFAULT 0,
  is_new         BOOLEAN DEFAULT FALSE,
  is_featured    BOOLEAN DEFAULT FALSE,
  is_active      BOOLEAN DEFAULT TRUE,
  popularity     INTEGER DEFAULT 0,
  sold_count     INTEGER DEFAULT 0,
  sale_price     INTEGER,
  default_color  VARCHAR(50) DEFAULT 'black',
  image_filename VARCHAR(255),
  color_images   JSONB,
  created_at     TIMESTAMPTZ DEFAULT NOW(),
  updated_at     TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "anon_all" ON products;
CREATE POLICY "anon_all" ON products FOR ALL TO anon USING (true) WITH CHECK (true);
CREATE TRIGGER trg_products_updated BEFORE UPDATE ON products FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- ───────────────────────────────────────────
-- ORDERS
-- ───────────────────────────────────────────
CREATE TABLE IF NOT EXISTS orders (
  id              BIGSERIAL PRIMARY KEY,
  order_number    VARCHAR(50) UNIQUE NOT NULL,
  customer_name   VARCHAR(255) NOT NULL,
  customer_email  VARCHAR(255),
  customer_phone  VARCHAR(20),
  customer_street VARCHAR(255),
  customer_city   VARCHAR(100),
  customer_postal VARCHAR(20),
  shipping_method VARCHAR(50) DEFAULT 'standard',
  shipping_cost   INTEGER DEFAULT 99,
  total_amount    INTEGER NOT NULL DEFAULT 0,
  subtotal_amount INTEGER DEFAULT 0,
  discount_amount INTEGER DEFAULT 0,
  coupon_code     VARCHAR(50),
  payment_method  VARCHAR(50) DEFAULT 'transfer',
  stripe_payment_method_id VARCHAR(100),
  status          VARCHAR(50) DEFAULT 'pending',
  note            TEXT,
  created_at      TIMESTAMPTZ DEFAULT NOW(),
  updated_at      TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "anon_all" ON orders;
CREATE POLICY "anon_all" ON orders FOR ALL TO anon USING (true) WITH CHECK (true);
CREATE TRIGGER trg_orders_updated BEFORE UPDATE ON orders FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- ───────────────────────────────────────────
-- ORDER ITEMS
-- ───────────────────────────────────────────
CREATE TABLE IF NOT EXISTS order_items (
  id           BIGSERIAL PRIMARY KEY,
  order_id     BIGINT REFERENCES orders(id) ON DELETE CASCADE,
  product_id   BIGINT REFERENCES products(id) ON DELETE SET NULL,
  product_name VARCHAR(255),
  color        VARCHAR(50),
  size         VARCHAR(50),
  quantity     INTEGER NOT NULL DEFAULT 1,
  unit_price   INTEGER NOT NULL DEFAULT 0,
  total_price  INTEGER NOT NULL DEFAULT 0,
  created_at   TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "anon_all" ON order_items;
CREATE POLICY "anon_all" ON order_items FOR ALL TO anon USING (true) WITH CHECK (true);

-- ───────────────────────────────────────────
-- REVIEWS
-- ───────────────────────────────────────────
CREATE TABLE IF NOT EXISTS reviews (
  id           BIGSERIAL PRIMARY KEY,
  product_id   BIGINT REFERENCES products(id) ON DELETE CASCADE,
  author_name  VARCHAR(255) NOT NULL,
  author_email VARCHAR(255),
  rating       INTEGER CHECK (rating BETWEEN 1 AND 5),
  text         TEXT,
  is_approved  BOOLEAN DEFAULT TRUE,
  is_verified  BOOLEAN DEFAULT FALSE,
  created_at   TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "anon_all" ON reviews;
CREATE POLICY "anon_all" ON reviews FOR ALL TO anon USING (true) WITH CHECK (true);

-- ───────────────────────────────────────────
-- FAQ
-- ───────────────────────────────────────────
CREATE TABLE IF NOT EXISTS faq (
  id         BIGSERIAL PRIMARY KEY,
  product_id BIGINT REFERENCES products(id) ON DELETE SET NULL,
  question   VARCHAR(500) NOT NULL,
  answer     TEXT NOT NULL,
  category   VARCHAR(100) DEFAULT 'obecné',
  sort_order INTEGER DEFAULT 0,
  is_visible BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE faq ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "anon_all" ON faq;
CREATE POLICY "anon_all" ON faq FOR ALL TO anon USING (true) WITH CHECK (true);

-- ───────────────────────────────────────────
-- NEWSLETTER
-- ───────────────────────────────────────────
CREATE TABLE IF NOT EXISTS newsletter_subscribers (
  id            BIGSERIAL PRIMARY KEY,
  email         VARCHAR(255) UNIQUE NOT NULL,
  subscribed_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE newsletter_subscribers ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "anon_all" ON newsletter_subscribers;
CREATE POLICY "anon_all" ON newsletter_subscribers FOR ALL TO anon USING (true) WITH CHECK (true);

-- ───────────────────────────────────────────
-- CONTACT MESSAGES
-- ───────────────────────────────────────────
CREATE TABLE IF NOT EXISTS contact_messages (
  id         BIGSERIAL PRIMARY KEY,
  name       VARCHAR(255),
  email      VARCHAR(255),
  phone      VARCHAR(20),
  subject    VARCHAR(100),
  message    TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE contact_messages ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "anon_all" ON contact_messages;
CREATE POLICY "anon_all" ON contact_messages FOR ALL TO anon USING (true) WITH CHECK (true);

-- ───────────────────────────────────────────
-- BLOG
-- ───────────────────────────────────────────
CREATE TABLE IF NOT EXISTS blog_posts (
  id           BIGSERIAL PRIMARY KEY,
  title        VARCHAR(255) NOT NULL,
  slug         VARCHAR(255) UNIQUE,
  excerpt      TEXT,
  body         TEXT,
  content      TEXT,
  author       VARCHAR(100) DEFAULT 'Tým Drobnostík',
  category     VARCHAR(100) DEFAULT 'novinky',
  image        VARCHAR(255),
  reading_time INTEGER DEFAULT 3,
  featured     BOOLEAN DEFAULT FALSE,
  status       VARCHAR(20) DEFAULT 'published',
  published_at TIMESTAMPTZ DEFAULT NOW(),
  created_at   TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE blog_posts ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "anon_all" ON blog_posts;
CREATE POLICY "anon_all" ON blog_posts FOR ALL TO anon USING (true) WITH CHECK (true);

CREATE TABLE IF NOT EXISTS blog_comments (
  id           BIGSERIAL PRIMARY KEY,
  post_id      BIGINT REFERENCES blog_posts(id) ON DELETE CASCADE,
  author_name  VARCHAR(100) NOT NULL,
  author_email VARCHAR(255),
  text         TEXT NOT NULL,
  likes        INTEGER DEFAULT 0,
  is_approved  BOOLEAN DEFAULT TRUE,
  created_at   TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE blog_comments ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "anon_all" ON blog_comments;
CREATE POLICY "anon_all" ON blog_comments FOR ALL TO anon USING (true) WITH CHECK (true);

-- ───────────────────────────────────────────
-- FORUM
-- ───────────────────────────────────────────
CREATE TABLE IF NOT EXISTS forum_threads (
  id          BIGSERIAL PRIMARY KEY,
  title       VARCHAR(255) NOT NULL,
  body        TEXT,
  category    VARCHAR(100) DEFAULT 'obecné',
  author_name VARCHAR(100) NOT NULL,
  views       INTEGER DEFAULT 0,
  is_pinned   BOOLEAN DEFAULT FALSE,
  is_locked   BOOLEAN DEFAULT FALSE,
  created_at  TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE forum_threads ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "anon_all" ON forum_threads;
CREATE POLICY "anon_all" ON forum_threads FOR ALL TO anon USING (true) WITH CHECK (true);

CREATE TABLE IF NOT EXISTS forum_replies (
  id          BIGSERIAL PRIMARY KEY,
  thread_id   BIGINT REFERENCES forum_threads(id) ON DELETE CASCADE,
  author_name VARCHAR(100) NOT NULL,
  body        TEXT NOT NULL,
  likes       INTEGER DEFAULT 0,
  created_at  TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE forum_replies ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "anon_all" ON forum_replies;
CREATE POLICY "anon_all" ON forum_replies FOR ALL TO anon USING (true) WITH CHECK (true);

-- ───────────────────────────────────────────
-- COUPONS
-- ───────────────────────────────────────────
CREATE TABLE IF NOT EXISTS coupons (
  id             BIGSERIAL PRIMARY KEY,
  code           VARCHAR(50) UNIQUE NOT NULL,
  discount_type  VARCHAR(20) DEFAULT 'percent',
  discount_value INTEGER NOT NULL,
  min_order      INTEGER DEFAULT 0,
  max_uses       INTEGER DEFAULT 100,
  used_count     INTEGER DEFAULT 0,
  is_active      BOOLEAN DEFAULT TRUE,
  expires_at     TIMESTAMPTZ,
  created_at     TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE coupons ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "anon_all" ON coupons;
CREATE POLICY "anon_all" ON coupons FOR ALL TO anon USING (true) WITH CHECK (true);

-- ───────────────────────────────────────────
-- SUPPORT TICKETS
-- ───────────────────────────────────────────
CREATE TABLE IF NOT EXISTS support_tickets (
  id             BIGSERIAL PRIMARY KEY,
  ticket_number  VARCHAR(20) UNIQUE NOT NULL,
  name           VARCHAR(255) NOT NULL,
  email          VARCHAR(255) NOT NULL,
  order_number   VARCHAR(50),
  category       VARCHAR(50) DEFAULT 'general',
  subject        VARCHAR(255),
  message        TEXT NOT NULL,
  status         VARCHAR(20) DEFAULT 'open',
  priority       VARCHAR(20) DEFAULT 'normal',
  created_at     TIMESTAMPTZ DEFAULT NOW(),
  updated_at     TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE support_tickets ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "anon_all" ON support_tickets;
CREATE POLICY "anon_all" ON support_tickets FOR ALL TO anon USING (true) WITH CHECK (true);
CREATE TRIGGER trg_tickets_updated BEFORE UPDATE ON support_tickets FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- ───────────────────────────────────────────
-- AFFILIATES
-- ───────────────────────────────────────────
CREATE TABLE IF NOT EXISTS affiliates (
  id              BIGSERIAL PRIMARY KEY,
  name            VARCHAR(255) NOT NULL,
  email           VARCHAR(255) UNIQUE NOT NULL,
  referral_code   VARCHAR(20) UNIQUE NOT NULL,
  commission_rate INTEGER DEFAULT 10,
  total_earned    INTEGER DEFAULT 0,
  total_clicks    INTEGER DEFAULT 0,
  total_sales     INTEGER DEFAULT 0,
  status          VARCHAR(20) DEFAULT 'active',
  created_at      TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE affiliates ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "anon_all" ON affiliates;
CREATE POLICY "anon_all" ON affiliates FOR ALL TO anon USING (true) WITH CHECK (true);

-- ───────────────────────────────────────────
-- EMAIL CAMPAIGNS
-- ───────────────────────────────────────────
CREATE TABLE IF NOT EXISTS email_campaigns (
  id          BIGSERIAL PRIMARY KEY,
  name        VARCHAR(255) NOT NULL,
  subject     VARCHAR(255),
  body        TEXT,
  status      VARCHAR(20) DEFAULT 'draft',
  sent        INTEGER DEFAULT 0,
  opens       INTEGER DEFAULT 0,
  clicks      INTEGER DEFAULT 0,
  type        VARCHAR(50) DEFAULT 'newsletter',
  sent_at     TIMESTAMPTZ,
  created_at  TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE email_campaigns ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "anon_all" ON email_campaigns;
CREATE POLICY "anon_all" ON email_campaigns FOR ALL TO anon USING (true) WITH CHECK (true);

-- ───────────────────────────────────────────
-- SETTINGS
-- ───────────────────────────────────────────
CREATE TABLE IF NOT EXISTS settings (
  id         BIGSERIAL PRIMARY KEY,
  key        VARCHAR(100) UNIQUE NOT NULL,
  value      TEXT,
  label      VARCHAR(255),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE settings ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "anon_all" ON settings;
CREATE POLICY "anon_all" ON settings FOR ALL TO anon USING (true) WITH CHECK (true);

-- ───────────────────────────────────────────
-- SUPPORT RATINGS & INVENTORY LOG
-- ───────────────────────────────────────────
CREATE TABLE IF NOT EXISTS support_ratings (
  id         BIGSERIAL PRIMARY KEY,
  score      INTEGER CHECK (score BETWEEN 1 AND 5),
  created_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE support_ratings ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "anon_all" ON support_ratings;
CREATE POLICY "anon_all" ON support_ratings FOR ALL TO anon USING (true) WITH CHECK (true);

CREATE TABLE IF NOT EXISTS inventory_log (
  id         BIGSERIAL PRIMARY KEY,
  product_id BIGINT REFERENCES products(id) ON DELETE CASCADE,
  change     INTEGER NOT NULL,
  reason     VARCHAR(100),
  created_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE inventory_log ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "anon_all" ON inventory_log;
CREATE POLICY "anon_all" ON inventory_log FOR ALL TO anon USING (true) WITH CHECK (true);

-- ───────────────────────────────────────────
-- INDEXY
-- ───────────────────────────────────────────
CREATE INDEX IF NOT EXISTS idx_products_active     ON products(is_active);
CREATE INDEX IF NOT EXISTS idx_products_featured   ON products(is_featured);
CREATE INDEX IF NOT EXISTS idx_products_category   ON products(category);
CREATE INDEX IF NOT EXISTS idx_products_popularity ON products(popularity DESC);
CREATE INDEX IF NOT EXISTS idx_products_created    ON products(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_orders_status       ON orders(status);
CREATE INDEX IF NOT EXISTS idx_orders_created      ON orders(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_reviews_product     ON reviews(product_id);

-- ═══════════════════════════════════════════════════════════════
-- TESTOVACÍ DATA
-- ═══════════════════════════════════════════════════════════════

INSERT INTO products (name, category, description, price_small, price_standard, price_maxi, stock_quantity, is_featured, is_active, is_new, sold_count, default_color, colors)
VALUES
  ('Pokébowl Classic', 'Pokéboly', 'Klasický pokébowl pro sběratele. Vyrobeno z prémiového PLA filamentu. Každý kus je pečlivě tisknut a finalizován.', 199, 299, 399, 50, true, true, false, 120, 'black', ARRAY['black','white','gray']),
  ('Pokébowl Gold Edition', 'Pokéboly', 'Luxusní zlatá edice s metalickým efektem. Limitovaná série pro náročné sběratele.', 299, 499, 699, 20, true, true, true, 45, 'black', ARRAY['black','white','gray']),
  ('Pokébowl Shadow', 'Pokéboly', 'Temná edice — matná černá s lesklými detaily. Elegantní a výrazný design.', 249, 349, 499, 30, true, true, true, 89, 'black', ARRAY['black','gray']),
  ('Pokébowl Pearl', 'Pokéboly', 'Perleťová bílá edice. Čistý a elegantní design pro milovníky světlých tónů.', 219, 319, 449, 40, false, true, false, 34, 'white', ARRAY['white','gray']),
  ('Mini Dragon', 'Miniatures', 'Malá dragoní figurka, ideální jako dekorace nebo originální dárek pro fanoušky fantasy.', 99, 149, 199, 100, false, true, false, 67, 'black', ARRAY['black','white','gray']),
  ('Pokébowl Retro', 'Pokéboly', 'Retro edice inspirovaná klasickými Pokébally z 90. let. Nostalgie v prémiové kvalitě.', 229, 329, 459, 25, true, true, false, 56, 'black', ARRAY['black','white','gray'])
ON CONFLICT DO NOTHING;

INSERT INTO faq (question, answer, category, sort_order) VALUES
  ('Z čeho jsou Pokéboly vyrobeny?', 'Všechny naše produkty jsou tisknuty z kvalitního PLA filamentu, který je biologicky rozložitelný a bezpečný pro každodenní použití.', 'materiál', 1),
  ('Jak dlouho trvá výroba?', 'Standardní výroba trvá 3–5 pracovních dní. Express výroba je dostupná do 24 hodin za příplatek.', 'obecné', 2),
  ('Mohu si vybrat barvu a velikost?', 'Ano! Nabízíme 3 barvy (černá, bílá, šedá) a 3 velikosti (Small, Standard, Maxi).', 'obecné', 3),
  ('Jaké jsou možnosti doručení?', 'Standardní zásilka 99 Kč (3–5 dní), Express 249 Kč (1–2 dny), osobní odběr zdarma.', 'doprava', 4),
  ('Mohu vrátit zboží?', 'Ano, přijímáme vrácení do 14 dní od doručení bez udání důvodu. Zboží musí být nepoužité v originálním balení.', 'obchod', 5),
  ('Jsou Pokéboly vhodné jako dárky?', 'Rozhodně! Nabízíme i dárkové balení za příplatek 49 Kč. Perfektní pro narozeniny, Vánoce nebo jen tak.', 'obecné', 6)
ON CONFLICT DO NOTHING;

INSERT INTO blog_posts (title, slug, excerpt, content, author, category, reading_time, featured, status) VALUES
  ('Jak vzniká Pokéball — od 3D modelu k hotovému produktu', 'jak-vznika-pokeball', 'Nahlédněte do zákulisí naší dílny a zjistěte, jak trvá výroba jednoho kusu.', '<h2>Od nápadu k tiskárně</h2><p>Celý proces začíná v 3D modelovacím softwaru. Každý detail musí být přesně navržen. Poté přichází slicování, kalibrace tiskárny a samotný tisk, který trvá 4–8 hodin podle velikosti.</p><h2>Finalizace a kontrola kvality</h2><p>Po tisku přichází broušení, čištění a důkladná kontrola kvality. Teprve pak balení a odeslání.</p>', 'Tým Drobnostík', 'za-kulisami', 5, true, 'published'),
  ('5 tipů jak vystavit pokéboly doma', 'tipy-jak-vystavit-pokeboly', 'Máte krásné pokéboly, ale nevíte jak je vystavit? Přinášíme 5 osvědčených tipů.', '<h2>1. Akrylové stojany</h2><p>Nejlepší volba pro elegantní prezentaci. Dostupné ve více velikostech.</p><h2>2. Police s LED podsvícením</h2><p>Zlatá barva pokéballů krásně vynikne při správném osvětlení.</p><h2>3. Vitríny</h2><p>Pro větší sbírky doporučujeme uzavřené vitríny — chrání před prachem.</p>', 'Jana K.', 'tipy', 3, false, 'published'),
  ('Shadow Edition — nová limitovaná kolekce', 'shadow-edition-kolekce', 'Limitovaná série Shadow Edition s matnou černou povrchovou úpravou. Pouze 50 kusů.', '<h2>Temná elegance</h2><p>Shadow Edition vznikla na přání komunity, která chtěla výraznější, temnější design. Matný černý povrch v kombinaci s lesklými detaily vytváří jedinečný kontrast.</p><h2>Dostupnost</h2><p>Kolekce je dostupná v obchodě v omezeném množství. Doporučujeme neotálet.</p>', 'Tým Drobnostík', 'novinky', 2, false, 'published')
ON CONFLICT DO NOTHING;

INSERT INTO forum_threads (title, body, category, author_name, views, is_pinned) VALUES
  ('Jak nejlépe vystavit pokebally na polici?', 'Zdravím, mám teď 6 pokeballů a nevím jak je nejlépe vystavit. Zkusil jsem je dát do řady, ale padají. Máte někdo tip?', 'sbírání', 'Marek J.', 142, false),
  ('Jaký filament je nejlepší pro pokébowly?', 'Zajímá mě jaký PLA filament je nejlepší. Vím že Drobnostík používá prémiový, ale chtěl bych si sám vytisknout stojan.', 'tisk', 'Ondřej M.', 87, false),
  ('Vítejte v komunitě Drobnostík! 👋', 'Vítejte! Napište se kdo jste a kolik kusů máte ve sbírce.', 'obecné', 'Tým Drobnostík', 310, true)
ON CONFLICT DO NOTHING;

INSERT INTO coupons (code, discount_type, discount_value, min_order, max_uses, is_active) VALUES
  ('VITEJ10', 'percent', 10, 0, 1000, true),
  ('POKEFAN15', 'percent', 15, 500, 200, true),
  ('SLEVA50', 'fixed', 50, 300, 100, true)
ON CONFLICT DO NOTHING;

INSERT INTO settings (key, value, label) VALUES
  ('shipping_standard',  '99',                    'Standardní doprava (Kč)'),
  ('shipping_express',   '249',                   'Expresní doprava (Kč)'),
  ('shipping_pickup',    '0',                     'Osobní odběr (Kč)'),
  ('free_shipping_from', '1500',                  'Doprava zdarma od (Kč)'),
  ('vat_rate',           '21',                    'DPH (%)'),
  ('shop_email',         'info@drobnostik.cz',    'Email obchodu'),
  ('shop_phone',         '+420 777 123 456',      'Telefon'),
  ('shop_address',       'Dlouhá 15, 110 00 Praha 1', 'Adresa')
ON CONFLICT (key) DO NOTHING;

-- Grant schema access (required by some Supabase projects)
GRANT USAGE ON SCHEMA public TO anon;
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT ALL ON ALL TABLES IN SCHEMA public TO anon;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO anon;

-- ═══════════════════════════════════════════════════════════════
-- EMAIL TEMPLATES (chybělo — používáno v admin/email-templates.html)
-- ═══════════════════════════════════════════════════════════════
CREATE TABLE IF NOT EXISTS email_templates (
  id         BIGSERIAL PRIMARY KEY,
  name       VARCHAR(100) UNIQUE NOT NULL,
  label      VARCHAR(255),
  subject    VARCHAR(255),
  body       TEXT,
  variables  TEXT[],
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE email_templates ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "anon_all" ON email_templates;
CREATE POLICY "anon_all" ON email_templates FOR ALL TO anon USING (true) WITH CHECK (true);

INSERT INTO email_templates (name, label, subject, body, variables) VALUES
  ('welcome',           'Vítací email',            'Vítejte v Drobnostíku! 🎉',
   'Dobrý den {{customer_name}},\n\nvítáme vás v rodině Drobnostík! Jako poděkování za registraci dostáváte 10% slevu na první nákup s kódem VITEJ10.\n\nS pozdravem,\nTým Drobnostík',
   ARRAY['customer_name']),

  ('order_confirmation', 'Potvrzení objednávky',   'Potvrzení objednávky {{order_number}} — Drobnostík',
   'Dobrý den {{customer_name}},\n\nváše objednávka {{order_number}} byla přijata.\nCelková částka: {{total_amount}} Kč\nZpůsob dopravy: {{shipping_method}}\nPředpokládané doručení: {{shipping_date}}\n\nDěkujeme za nákup!\nTým Drobnostík',
   ARRAY['customer_name','order_number','total_amount','shipping_method','shipping_date']),

  ('order_shipped',      'Oznámení o odeslání',    'Vaše objednávka byla odeslána! 📦',
   'Dobrý den {{customer_name}},\n\nvaše objednávka {{order_number}} byla odeslána.\nČíslo zásilky: {{tracking_number}}\nPředpokládané doručení: {{delivery_date}}\n\nSledovat zásilku: {{tracking_link}}\n\nTým Drobnostík',
   ARRAY['customer_name','order_number','tracking_number','delivery_date','tracking_link']),

  ('newsletter',         'Newsletter',             'Novinky z Drobnostíku 📬',
   'Dobrý den,\n\npodívejte se na naše novinky!\n\nDoporučovaný produkt: {{featured_product}}\nAktuální sleva: {{discount}}%\n\nNavštivte obchod: {{shop_link}}\n\nTým Drobnostík',
   ARRAY['featured_product','discount','shop_link']),

  ('review_request',     'Žádost o recenzi',       'Jak jste spokojeni s {{product_name}}? ⭐',
   'Dobrý den {{customer_name}},\n\nkoupili jste {{product_name}}. Byli byste ochotni napsat recenzi?\n\nZanechat recenzi: {{review_link}}\n\nDěkujeme!\nTým Drobnostík',
   ARRAY['customer_name','product_name','review_link'])
ON CONFLICT (name) DO NOTHING;

-- ═══════════════════════════════════════════════════════════════
-- SUPABASE STORAGE BUCKET (spustit v Supabase SQL editoru)
-- ═══════════════════════════════════════════════════════════════
-- Vytvoří bucket 'product-images' pro upload obrázků z admin panelu
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'product-images',
  'product-images',
  true,
  5242880,  -- 5 MB max
  ARRAY['image/jpeg','image/jpg','image/png','image/webp','image/gif']
) ON CONFLICT (id) DO NOTHING;

-- Anon může číst
CREATE POLICY "public_read_product_images" ON storage.objects
  FOR SELECT TO anon USING (bucket_id = 'product-images');

-- Anon může nahrávat (admin panel nemá auth)
CREATE POLICY "public_upload_product_images" ON storage.objects
  FOR INSERT TO anon WITH CHECK (bucket_id = 'product-images');

-- Anon může mazat vlastní soubory
CREATE POLICY "public_delete_product_images" ON storage.objects
  FOR DELETE TO anon USING (bucket_id = 'product-images');

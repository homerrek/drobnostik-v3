-- sql/schema.sql — Drobnostík v3 — Kompletní schéma databáze
-- Spustit v Supabase SQL editoru

-- ═══════════════════════════════════════════
-- PRODUCTS
-- ═══════════════════════════════════════════
CREATE TABLE IF NOT EXISTS products (
  id               BIGSERIAL PRIMARY KEY,
  name             VARCHAR(255) NOT NULL,
  category         VARCHAR(100),
  description      TEXT,
  price_small      INTEGER NOT NULL DEFAULT 0,
  price_standard   INTEGER NOT NULL DEFAULT 0,
  price_maxi       INTEGER DEFAULT 0,
  material         VARCHAR(100),
  colors           TEXT[] DEFAULT ARRAY['white','gray','black'],
  sizes            TEXT[] DEFAULT ARRAY['Small','Standard','Maxi'],
  stock_quantity   INTEGER DEFAULT 0,
  is_new           BOOLEAN DEFAULT FALSE,
  is_featured      BOOLEAN DEFAULT FALSE,
  is_active        BOOLEAN DEFAULT TRUE,
  popularity       INTEGER DEFAULT 0,
  sold_count       INTEGER DEFAULT 0,
  sale_price       INTEGER,
  default_color    VARCHAR(50),
  image_filename   VARCHAR(255),
  color_images     JSONB,
  created_at       TIMESTAMPTZ DEFAULT NOW(),
  updated_at       TIMESTAMPTZ DEFAULT NOW()
);

-- ═══════════════════════════════════════════
-- ORDERS
-- ═══════════════════════════════════════════
CREATE TABLE IF NOT EXISTS orders (
  id               BIGSERIAL PRIMARY KEY,
  order_number     VARCHAR(50) UNIQUE NOT NULL,
  customer_name    VARCHAR(255) NOT NULL,
  customer_email   VARCHAR(255),
  customer_phone   VARCHAR(20),
  customer_street  VARCHAR(255),
  customer_city    VARCHAR(100),
  customer_postal  VARCHAR(20),
  shipping_method  VARCHAR(50) DEFAULT 'standard',
  shipping_cost    INTEGER DEFAULT 99,
  total_amount     INTEGER NOT NULL DEFAULT 0,
  status           VARCHAR(50) DEFAULT 'pending',
  note             TEXT,
  created_at       TIMESTAMPTZ DEFAULT NOW(),
  updated_at       TIMESTAMPTZ DEFAULT NOW()
);

-- ═══════════════════════════════════════════
-- ORDER ITEMS
-- ═══════════════════════════════════════════
CREATE TABLE IF NOT EXISTS order_items (
  id           BIGSERIAL PRIMARY KEY,
  order_id     BIGINT REFERENCES orders(id) ON DELETE CASCADE,
  product_id   BIGINT REFERENCES products(id) ON DELETE SET NULL,
  product_name VARCHAR(255),
  color        VARCHAR(50),
  size         VARCHAR(50),
  quantity     INTEGER NOT NULL DEFAULT 1,
  unit_price   INTEGER NOT NULL DEFAULT 0,
  created_at   TIMESTAMPTZ DEFAULT NOW()
);

-- ═══════════════════════════════════════════
-- REVIEWS
-- ═══════════════════════════════════════════
CREATE TABLE IF NOT EXISTS reviews (
  id           BIGSERIAL PRIMARY KEY,
  product_id   BIGINT REFERENCES products(id) ON DELETE CASCADE,
  author_name  VARCHAR(255) NOT NULL,
  author_email VARCHAR(255),
  rating       INTEGER CHECK (rating BETWEEN 1 AND 5),
  text         TEXT,
  is_approved  BOOLEAN DEFAULT FALSE,
  is_verified  BOOLEAN DEFAULT FALSE,
  created_at   TIMESTAMPTZ DEFAULT NOW()
);

-- ═══════════════════════════════════════════
-- FAQ
-- ═══════════════════════════════════════════
CREATE TABLE IF NOT EXISTS faq (
  id          BIGSERIAL PRIMARY KEY,
  product_id  BIGINT REFERENCES products(id) ON DELETE SET NULL,
  question    VARCHAR(500) NOT NULL,
  answer      TEXT NOT NULL,
  category    VARCHAR(100) DEFAULT 'obecné',
  sort_order  INTEGER DEFAULT 0,
  is_visible  BOOLEAN DEFAULT TRUE,
  created_at  TIMESTAMPTZ DEFAULT NOW()
);

-- ═══════════════════════════════════════════
-- NEWSLETTER
-- ═══════════════════════════════════════════
CREATE TABLE IF NOT EXISTS newsletter_subscribers (
  id             BIGSERIAL PRIMARY KEY,
  email          VARCHAR(255) UNIQUE NOT NULL,
  subscribed_at  TIMESTAMPTZ DEFAULT NOW()
);

-- ═══════════════════════════════════════════
-- CONTACT MESSAGES
-- ═══════════════════════════════════════════
CREATE TABLE IF NOT EXISTS contact_messages (
  id         BIGSERIAL PRIMARY KEY,
  name       VARCHAR(255),
  email      VARCHAR(255),
  phone      VARCHAR(20),
  subject    VARCHAR(100),
  message    TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ═══════════════════════════════════════════
-- HOMEPAGE CONTENT
-- ═══════════════════════════════════════════
CREATE TABLE IF NOT EXISTS homepage_content (
  id           BIGSERIAL PRIMARY KEY,
  section      VARCHAR(50),
  title        VARCHAR(255),
  description  TEXT,
  image_url    VARCHAR(255),
  button_text  VARCHAR(100),
  button_link  VARCHAR(255),
  is_active    BOOLEAN DEFAULT TRUE,
  created_at   TIMESTAMPTZ DEFAULT NOW()
);

-- ═══════════════════════════════════════════
-- INDEXES
-- ═══════════════════════════════════════════
CREATE INDEX IF NOT EXISTS idx_products_category   ON products(category);
CREATE INDEX IF NOT EXISTS idx_products_featured   ON products(is_featured);
CREATE INDEX IF NOT EXISTS idx_products_active     ON products(is_active);
CREATE INDEX IF NOT EXISTS idx_products_popularity ON products(popularity DESC);
CREATE INDEX IF NOT EXISTS idx_products_created    ON products(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_orders_status       ON orders(status);
CREATE INDEX IF NOT EXISTS idx_orders_created      ON orders(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_reviews_product     ON reviews(product_id);
CREATE INDEX IF NOT EXISTS idx_reviews_approved    ON reviews(is_approved);

-- ═══════════════════════════════════════════
-- TRIGGERS — auto-update updated_at
-- ═══════════════════════════════════════════
CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER AS $$
BEGIN NEW.updated_at = NOW(); RETURN NEW; END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_product_updated
  BEFORE UPDATE ON products
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trigger_order_updated
  BEFORE UPDATE ON orders
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- ═══════════════════════════════════════════
-- RLS (Row Level Security)
-- ═══════════════════════════════════════════
ALTER TABLE products            ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders              ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_items         ENABLE ROW LEVEL SECURITY;
ALTER TABLE reviews             ENABLE ROW LEVEL SECURITY;
ALTER TABLE faq                 ENABLE ROW LEVEL SECURITY;
ALTER TABLE newsletter_subscribers ENABLE ROW LEVEL SECURITY;
ALTER TABLE contact_messages    ENABLE ROW LEVEL SECURITY;
ALTER TABLE homepage_content    ENABLE ROW LEVEL SECURITY;

-- Veřejný přístup (anon klíč) — pro produkci zužte!
CREATE POLICY "public_all" ON products            FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "public_all" ON orders              FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "public_all" ON order_items         FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "public_all" ON reviews             FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "public_all" ON faq                 FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "public_all" ON newsletter_subscribers FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "public_all" ON contact_messages    FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "public_all" ON homepage_content    FOR ALL USING (true) WITH CHECK (true);

-- ═══════════════════════════════════════════
-- TESTOVACÍ DATA
-- ═══════════════════════════════════════════
INSERT INTO products (name, category, description, price_small, price_standard, price_maxi, stock_quantity, is_featured, is_active, sold_count, colors)
VALUES
  ('Pokébowl Classic', 'Pokéboly', 'Klasický pokébowl pro sběratele. Vyrobeno z prémiového PLA filamentu.', 199, 299, 399, 50, true, true, 120, ARRAY['black','white','gray']),
  ('Pokébowl Gold Edition', 'Pokéboly', 'Luxusní zlatá edice s metalickým efektem. Limitovaná série.', 299, 499, 699, 20, true, true, 45, ARRAY['black','white','gray']),
  ('Mini Dragon', 'Miniatures', 'Malá dragoní figurka, ideální jako dekorace nebo dárek.', 99, 149, 199, 100, false, true, 67, ARRAY['black','white','gray']),
  ('Pokébowl Shadow', 'Pokéboly', 'Temná edice pro sběratele — matná černá s lesklými detaily.', 249, 349, 499, 30, true, true, 89, ARRAY['black','gray']),
  ('Pokébowl Pearl', 'Pokéboly', 'Perleťová bílá edice. Elegantní a čistý design.', 219, 319, 449, 40, false, true, 34, ARRAY['white','gray'])
ON CONFLICT DO NOTHING;

INSERT INTO faq (question, answer, category, sort_order)
VALUES
  ('Z čeho jsou Pokéboly vyrobeny?', 'Všechny naše produkty jsou tisknuty z kvalitního PLA filamentu, který je biologicky rozložitelný a bezpečný pro každodenní použití.', 'materiál', 1),
  ('Jak dlouho trvá výroba?', 'Standardní výroba trvá 3–5 pracovních dní. Express výroba je dostupná do 24 hodin za příplatek.', 'obecné', 2),
  ('Mohu si vybrat barvu a velikost?', 'Ano! Nabízíme 3 barvy (černá, bílá, šedá) a 3 velikosti (Small, Standard, Maxi).', 'obecné', 3),
  ('Jaké jsou možnosti doručení?', 'Standardní zásilka 99 Kč (3–5 dní), Express 249 Kč (1–2 dny), osobní odběr zdarma.', 'doprava', 4),
  ('Mohu vrátit zboží?', 'Ano, přijímáme vrácení do 14 dní od doručení bez udání důvodu. Zboží musí být nepoužité.', 'obchod', 5),
  ('Jsou Pokéboly vhodné jako dárky?', 'Rozhodně! Nabízíme i dárkové balení za příplatek 49 Kč.', 'obecné', 6)
ON CONFLICT DO NOTHING;

-- ═══════════════════════════════════════════
-- BLOG
-- ═══════════════════════════════════════════
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
CREATE POLICY "public_all" ON blog_posts FOR ALL USING (true) WITH CHECK (true);

CREATE TABLE IF NOT EXISTS blog_comments (
  id          BIGSERIAL PRIMARY KEY,
  post_id     BIGINT REFERENCES blog_posts(id) ON DELETE CASCADE,
  author_name VARCHAR(100) NOT NULL,
  author_email VARCHAR(255),
  text        TEXT NOT NULL,
  is_approved BOOLEAN DEFAULT TRUE,
  created_at  TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE blog_comments ENABLE ROW LEVEL SECURITY;
CREATE POLICY "public_all" ON blog_comments FOR ALL USING (true) WITH CHECK (true);

-- ═══════════════════════════════════════════
-- FORUM
-- ═══════════════════════════════════════════
CREATE TABLE IF NOT EXISTS forum_threads (
  id           BIGSERIAL PRIMARY KEY,
  title        VARCHAR(255) NOT NULL,
  body         TEXT,
  content      TEXT,
  category     VARCHAR(100) DEFAULT 'obecné',
  author_name  VARCHAR(100) NOT NULL,
  views        INTEGER DEFAULT 0,
  is_pinned    BOOLEAN DEFAULT FALSE,
  is_locked    BOOLEAN DEFAULT FALSE,
  created_at   TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE forum_threads ENABLE ROW LEVEL SECURITY;
CREATE POLICY "public_all" ON forum_threads FOR ALL USING (true) WITH CHECK (true);

CREATE TABLE IF NOT EXISTS forum_replies (
  id           BIGSERIAL PRIMARY KEY,
  thread_id    BIGINT REFERENCES forum_threads(id) ON DELETE CASCADE,
  author_name  VARCHAR(100) NOT NULL,
  body         TEXT NOT NULL,
  created_at   TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE forum_replies ENABLE ROW LEVEL SECURITY;
CREATE POLICY "public_all" ON forum_replies FOR ALL USING (true) WITH CHECK (true);

-- ═══════════════════════════════════════════
-- COUPONS
-- ═══════════════════════════════════════════
CREATE TABLE IF NOT EXISTS coupons (
  id              BIGSERIAL PRIMARY KEY,
  code            VARCHAR(50) UNIQUE NOT NULL,
  type            VARCHAR(20) DEFAULT 'percent',   -- 'percent' | 'fixed'
  value           INTEGER NOT NULL,
  min_order       INTEGER DEFAULT 0,
  usage_limit     INTEGER DEFAULT 100,
  usage_count     INTEGER DEFAULT 0,
  is_active       BOOLEAN DEFAULT TRUE,
  expires_at      TIMESTAMPTZ,
  created_at      TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE coupons ENABLE ROW LEVEL SECURITY;
CREATE POLICY "public_all" ON coupons FOR ALL USING (true) WITH CHECK (true);

-- ═══════════════════════════════════════════
-- SUPPORT TICKETS
-- ═══════════════════════════════════════════
CREATE TABLE IF NOT EXISTS support_tickets (
  id              BIGSERIAL PRIMARY KEY,
  ticket_number   VARCHAR(20) UNIQUE NOT NULL,
  name            VARCHAR(255) NOT NULL,
  email           VARCHAR(255) NOT NULL,
  order_number    VARCHAR(50),
  category        VARCHAR(50) DEFAULT 'general',
  subject         VARCHAR(255),
  message         TEXT NOT NULL,
  status          VARCHAR(20) DEFAULT 'open',   -- open | in_progress | resolved | closed
  priority        VARCHAR(20) DEFAULT 'normal',
  created_at      TIMESTAMPTZ DEFAULT NOW(),
  updated_at      TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE support_tickets ENABLE ROW LEVEL SECURITY;
CREATE POLICY "public_all" ON support_tickets FOR ALL USING (true) WITH CHECK (true);
CREATE TRIGGER trigger_ticket_updated BEFORE UPDATE ON support_tickets FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- ═══════════════════════════════════════════
-- AFFILIATES
-- ═══════════════════════════════════════════
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
CREATE POLICY "public_all" ON affiliates FOR ALL USING (true) WITH CHECK (true);

-- ═══════════════════════════════════════════
-- INVENTORY LOG (pro admin/inventory)
-- ═══════════════════════════════════════════
CREATE TABLE IF NOT EXISTS inventory_log (
  id          BIGSERIAL PRIMARY KEY,
  product_id  BIGINT REFERENCES products(id) ON DELETE CASCADE,
  change      INTEGER NOT NULL,
  reason      VARCHAR(100),
  created_at  TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE inventory_log ENABLE ROW LEVEL SECURITY;
CREATE POLICY "public_all" ON inventory_log FOR ALL USING (true) WITH CHECK (true);

-- ═══════════════════════════════════════════
-- SUPPORT RATINGS
-- ═══════════════════════════════════════════
CREATE TABLE IF NOT EXISTS support_ratings (
  id         BIGSERIAL PRIMARY KEY,
  score      INTEGER CHECK (score BETWEEN 1 AND 5),
  created_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE support_ratings ENABLE ROW LEVEL SECURITY;
CREATE POLICY "public_all" ON support_ratings FOR ALL USING (true) WITH CHECK (true);

-- ═══════════════════════════════════════════
-- TESTOVACÍ DATA — Blog
-- ═══════════════════════════════════════════
INSERT INTO blog_posts (title, slug, excerpt, content, author, category, reading_time, featured, status)
VALUES
  ('Jak vzniká Pokéball — od 3D modelu k hotovému produktu',
   'jak-vznika-pokeball',
   'Nahlédněte do zákulisí naší dílny a zjistěte, jak trvá výroba jednoho kusu od digitálního návrhu až po zabalení.',
   'Celý proces začíná v 3D modelovacím softwaru. Každý detail — od tvaru po toleranci spoje — musí být přesně navržen. Poté přichází slicování, kalibrace tiskárny a samotný tisk, který trvá 4–8 hodin podle velikosti. Následuje broušení, čištění a kontrola kvality. Teprve pak balení.',
   'Tým Drobnostík', 'za-kulisami', 5, TRUE, 'published'),
  ('5 tipů jak vystavit pokéboly doma',
   'tipy-jak-vystavit-pokeboly',
   'Máte krásné pokéboly, ale nevíte jak je vystavit? Přinášíme 5 osvědčených tipů z naší komunity.',
   'Od akrylových stojanů, přes police s LED podsvícením, až po tematické vitríny. Každý sběratel má svůj styl.',
   'Jana K.', 'tipy', 3, FALSE, 'published'),
  ('Nová kolekce Shadow Edition je tady',
   'shadow-edition-nova-kolekce',
   'Limitovaná série Shadow Edition s matnou černou povrchovou úpravou. Pouze 50 kusů.',
   'Celá kolekce je dostupná v obchodě. Objednávky přijímáme od 15. března. Doporučujeme neotálet.',
   'Tým Drobnostík', 'novinky', 2, FALSE, 'published')
ON CONFLICT DO NOTHING;

INSERT INTO forum_threads (title, body, category, author_name, views, is_pinned)
VALUES
  ('Jak nejlépe vystavit pokebally na polici?', 'Zdravím, mám teď 6 pokeballů a nevím jak je nejlépe vystavit. Zkusil jsem je dát do řady, ale padají. Máte někdo tip?', 'sbírání', 'Marek J.', 142, FALSE),
  ('Jaký filament používáte pro výtisk?', 'Zajímá mě jaký PLA filament je nejlepší pro pokebally. Vím že Drobnostík používá prémiový, ale chtěl bych si sám vytisknout stand.', 'tisk', 'Ondřej M.', 87, FALSE),
  ('Přivítání nových členů komunity 👋', 'Vítejte v komunitě Drobnostík! Napište se kdo jste a kolik kusů máte ve sbírce. Já začínám s 3.', 'obecné', 'Tým Drobnostík', 310, TRUE)
ON CONFLICT DO NOTHING;

INSERT INTO coupons (code, type, value, min_order, usage_limit, is_active)
VALUES
  ('VITEJ10', 'percent', 10, 0, 1000, TRUE),
  ('POKEFAN15', 'percent', 15, 500, 200, TRUE),
  ('SLEVA50', 'fixed', 50, 300, 100, TRUE)
ON CONFLICT DO NOTHING;

-- ═══════════════════════════════════════════
-- EMAIL CAMPAIGNS
-- ═══════════════════════════════════════════
CREATE TABLE IF NOT EXISTS email_campaigns (
  id           BIGSERIAL PRIMARY KEY,
  name         VARCHAR(255) NOT NULL,
  subject      VARCHAR(255),
  body         TEXT,
  status       VARCHAR(20) DEFAULT 'draft',
  sent_count   INTEGER DEFAULT 0,
  open_count   INTEGER DEFAULT 0,
  click_count  INTEGER DEFAULT 0,
  sent_at      TIMESTAMPTZ,
  created_at   TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE email_campaigns ENABLE ROW LEVEL SECURITY;
CREATE POLICY "public_all" ON email_campaigns FOR ALL USING (true) WITH CHECK (true);

-- ═══════════════════════════════════════════
-- SETTINGS (pro payment-settings, multi-language atd.)
-- ═══════════════════════════════════════════
CREATE TABLE IF NOT EXISTS settings (
  id         BIGSERIAL PRIMARY KEY,
  key        VARCHAR(100) UNIQUE NOT NULL,
  value      TEXT,
  label      VARCHAR(255),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE settings ENABLE ROW LEVEL SECURITY;
CREATE POLICY "public_all" ON settings FOR ALL USING (true) WITH CHECK (true);

INSERT INTO settings (key, value, label) VALUES
  ('shipping_standard',   '99',    'Standardní doprava (Kč)'),
  ('shipping_express',    '249',   'Expresní doprava (Kč)'),
  ('shipping_pickup',     '0',     'Osobní odběr (Kč)'),
  ('free_shipping_from',  '1500',  'Doprava zdarma od (Kč)'),
  ('vat_rate',            '21',    'DPH (%)'),
  ('currency',            'CZK',   'Měna'),
  ('shop_email',          'info@drobnostik.cz', 'Email obchodu'),
  ('shop_phone',          '+420 777 123 456',   'Telefon'),
  ('shop_address',        'Dlouhá 15, 110 00 Praha 1', 'Adresa')
ON CONFLICT (key) DO NOTHING;

-- ═══════════════════════════════════════════
-- ACHIEVEMENTS (pro stránku /achievements)
-- ═══════════════════════════════════════════
CREATE TABLE IF NOT EXISTS user_achievements (
  id            BIGSERIAL PRIMARY KEY,
  user_key      VARCHAR(100) NOT NULL,
  achievement   VARCHAR(100) NOT NULL,
  earned_at     TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_key, achievement)
);
ALTER TABLE user_achievements ENABLE ROW LEVEL SECURITY;
CREATE POLICY "public_all" ON user_achievements FOR ALL USING (true) WITH CHECK (true);

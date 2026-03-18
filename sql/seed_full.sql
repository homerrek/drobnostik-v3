-- ═══════════════════════════════════════════════════════════════
-- Drobnostík v3 — FULL RESET + SEED
-- Smaže stará data a vloží nová (45+ produktů, 100+ řádků / tabulka)
-- Spustit na: https://supabase.com/dashboard/project/wwezzahputwjfzzhybny/sql/new
-- ═══════════════════════════════════════════════════════════════

-- ── RESET (smaž v správném pořadí kvůli FK) ──────────────────
TRUNCATE TABLE support_ratings    RESTART IDENTITY CASCADE;
TRUNCATE TABLE inventory_log      RESTART IDENTITY CASCADE;
TRUNCATE TABLE email_campaigns    RESTART IDENTITY CASCADE;
TRUNCATE TABLE affiliates         RESTART IDENTITY CASCADE;
TRUNCATE TABLE support_tickets    RESTART IDENTITY CASCADE;
TRUNCATE TABLE forum_replies      RESTART IDENTITY CASCADE;
TRUNCATE TABLE forum_threads      RESTART IDENTITY CASCADE;
TRUNCATE TABLE blog_comments      RESTART IDENTITY CASCADE;
TRUNCATE TABLE blog_posts         RESTART IDENTITY CASCADE;
TRUNCATE TABLE coupons            RESTART IDENTITY CASCADE;
TRUNCATE TABLE newsletter_subscribers RESTART IDENTITY CASCADE;
TRUNCATE TABLE contact_messages   RESTART IDENTITY CASCADE;
TRUNCATE TABLE order_items        RESTART IDENTITY CASCADE;
TRUNCATE TABLE orders             RESTART IDENTITY CASCADE;
TRUNCATE TABLE reviews            RESTART IDENTITY CASCADE;
TRUNCATE TABLE faq                RESTART IDENTITY CASCADE;
TRUNCATE TABLE products           RESTART IDENTITY CASCADE;
TRUNCATE TABLE settings           RESTART IDENTITY CASCADE;

-- ══════════════════════════════════════════════════════════════
-- SETTINGS
-- ══════════════════════════════════════════════════════════════
INSERT INTO settings (key, value, label) VALUES
  ('shipping_standard',   '99',                       'Standardní doprava (Kč)'),
  ('shipping_express',    '249',                      'Expresní doprava (Kč)'),
  ('shipping_pickup',     '0',                        'Osobní odběr (Kč)'),
  ('free_shipping_from',  '1500',                     'Doprava zdarma od (Kč)'),
  ('vat_rate',            '21',                       'DPH (%)'),
  ('currency',            'CZK',                      'Měna'),
  ('shop_name',           'Drobnostík',               'Název obchodu'),
  ('shop_email',          'info@drobnostik.cz',       'Email obchodu'),
  ('shop_phone',          '+420 777 123 456',         'Telefon'),
  ('shop_address',        'Dlouhá 15, 110 00 Praha 1','Adresa'),
  ('facebook_url',        'https://facebook.com/drobnostik', 'Facebook'),
  ('instagram_url',       'https://instagram.com/drobnostik', 'Instagram'),
  ('return_days',         '14',                       'Počet dní pro vrácení'),
  ('min_order_amount',    '0',                        'Minimální hodnota objednávky (Kč)'),
  ('maintenance_mode',    'false',                    'Režim údržby');

-- ══════════════════════════════════════════════════════════════
-- PRODUCTS — 45 kusů
-- ══════════════════════════════════════════════════════════════
INSERT INTO products (name, category, description, price_small, price_standard, price_maxi, stock_quantity, is_featured, is_active, is_new, sold_count, sale_price, default_color, colors, material) VALUES

-- ── Pokéboly (20 kusů) ────────────────────────────────────────
('Pokébowl Classic',         'Pokéboly', 'Klasický pokébowl pro sběratele. Vyrobeno z prémiového PLA filamentu. Každý kus je ručně zkontrolován.',                     199, 299, 399, 87, true,  true,  false, 342, NULL, 'black', ARRAY['black','white','gray'], 'PLA Standard'),
('Pokébowl Gold Edition',    'Pokéboly', 'Luxusní zlatá edice s metalickým efektem. Limitovaná série pro náročné sběratele.',                                            299, 499, 699, 24, true,  true,  false, 198, NULL, 'black', ARRAY['black','white','gray'], 'PLA Metallic Gold'),
('Pokébowl Shadow',          'Pokéboly', 'Temná matná edice s lesklými detaily. Elegantní a výrazný design inspirovaný noční oblohou.',                                 249, 349, 499, 31, true,  true,  false, 276, NULL, 'black', ARRAY['black','gray'],        'PLA Matte Black'),
('Pokébowl Pearl',           'Pokéboly', 'Perleťová bílá edice. Čistý a elegantní design pro milovníky světlých tónů a minimalismu.',                                   219, 319, 449, 43, false, true,  false, 154, NULL, 'white', ARRAY['white','gray'],        'PLA Silk White'),
('Pokébowl Retro',           'Pokéboly', 'Retro edice inspirovaná Pokébally z 90. let. Nostalgie v prémiové kvalitě s moderním zpracováním.',                           229, 329, 469, 19, true,  true,  false, 187, NULL, 'black', ARRAY['black','white','gray'], 'PLA Standard'),
('Pokébowl Midnight',        'Pokéboly', 'Hluboká modro-černá edice inspirovaná noční oblohou. Speciální metalický filament s perleťovým leskem.',                      269, 369, 519, 15, true,  true,  true,  89,  NULL, 'black', ARRAY['black','gray'],        'PLA Metallic Blue'),
('Pokébowl Sakura',          'Pokéboly', 'Jemná růžová edice limitované jarní kolekce. Oblíbená především jako originální dárek.',                                       219, 319, 449, 38, false, true,  true,  67,  NULL, 'white', ARRAY['white'],               'PLA Silk Rose'),
('Pokébowl Arctic',          'Pokéboly', 'Ledově bílá edice s matným povrchem. Minimalistický design pro každodenní použití i výstavní kousky.',                         199, 299, 399, 52, false, true,  false, 211, NULL, 'white', ARRAY['white','gray'],        'PLA Matte White'),
('Pokébowl Ember',           'Pokéboly', 'Ohnivá červená edice — výrazná, odvážná, nezapomenutelná. Pro ty, kdo chtějí vyniknout z davu.',                               249, 349, 499, 11, true,  true,  true,  43,  NULL, 'black', ARRAY['black'],               'PLA Flame Red'),
('Pokébowl Vintage',         'Pokéboly', 'Retro hnědá edice připomínající dřevo. Unikátní vzhled díky speciálnímu wood-effect filamentu.',                              229, 329, 469, 27, false, true,  false, 132, NULL, 'black', ARRAY['black','gray'],        'PLA Wood Effect'),
('Pokébowl Neon',            'Pokéboly', 'Žlutozelená neonová edice viditelná i za šera. Pro odvážné sběratele, kteří nemají rádi kompromisy.',                         259, 359, 509, 8,  false, true,  true,  28,  NULL, 'white', ARRAY['white'],               'PLA Glow Green'),
('Pokébowl Crystal',         'Pokéboly', 'Průhledná crystal edice — vidíš dovnitř jako přes kouzelné sklo. Exkluzivní a unikátní vzhled.',                              299, 449, 599, 12, true,  true,  true,  56,  NULL, 'white', ARRAY['white'],               'PLA Transparent'),
('Pokébowl Ocean',           'Pokéboly', 'Oceánská modrá edice s perleťovým efektem. Uklidňující barvy moře v prémiovém provedení.',                                    239, 339, 479, 34, false, true,  false, 98,  299, 'white', ARRAY['white','gray'],        'PLA Silk Ocean'),
('Pokébowl Lava',            'Pokéboly', 'Oranžovo-červená lávová edice. Dramatický vzhled pro odvážné sběratele s chutí pro výjimečné věci.',                          249, 369, 519, 9,  false, true,  true,  34,  NULL, 'black', ARRAY['black'],               'PLA Lava Orange'),
('Pokébowl Forest',          'Pokéboly', 'Tmavě zelená lesní edice. Klidný a přírodní design pro milovníky přírody a outdoorového stylu.',                               219, 319, 449, 41, false, true,  false, 76,  NULL, 'black', ARRAY['black','gray'],        'PLA Forest Green'),
('Pokébowl Galaxy',          'Pokéboly', 'Galaxie v dlani — multi-color filament s efektem hvězdné oblohy. Každý kus je jiný.',                                          279, 399, 549, 14, true,  true,  true,  61,  NULL, 'black', ARRAY['black'],               'PLA Galaxy Multi'),
('Pokébowl Bronze',          'Pokéboly', 'Bronzová edice se sametovým povrchem. Klasická elegance v moderním provedení.',                                               259, 369, 519, 22, false, true,  false, 87,  319, 'black', ARRAY['black'],               'PLA Bronze Metallic'),
('Pokébowl Ice',             'Pokéboly', 'Chladná ledová edice ve světle modré barvě. Dokonalá pro zimní výzdobu nebo celoroční dekoraci.',                              219, 319, 449, 29, false, true,  false, 53,  NULL, 'white', ARRAY['white','gray'],        'PLA Ice Blue'),
('Pokébowl Inferno',         'Pokéboly', 'Temně červená edice s lesklým povrchem. Dramatický a silný vzhled pro ty, kteří myslí velká.',                                 249, 359, 499, 17, false, true,  true,  44,  NULL, 'black', ARRAY['black'],               'PLA Deep Red'),
('Pokébowl Prism',           'Pokéboly', 'Duhová edice — mění barvu v závislosti na úhlu pohledu. Absolutně unikátní výsledek díky speciálnímu filamentu.',             299, 449, 629, 6,  true,  true,  true,  22,  NULL, 'white', ARRAY['white'],               'PLA Rainbow Shift'),

-- ── Miniatures (15 kusů) ──────────────────────────────────────
('Mini Pikachu',             'Miniatures', 'Roztomilá figurka Pikachu v sedící poloze, 8 cm. Ideální na stůl nebo jako přívěsek.',                                      89,  129, 179, 94, false, true,  false, 287, NULL, 'white',  ARRAY['white','yellow'],    'PLA Standard'),
('Mini Eevee',               'Miniatures', 'Figurka Eevee s detailním srážením srsti. Oblíbená mezi sběrateli první i druhé generace.',                                   89,  129, 179, 67, false, true,  false, 214, NULL, 'white',  ARRAY['white','gray'],      'PLA Standard'),
('Mini Gengar',              'Miniatures', 'Duchova figurka Gengara s úsměvem. Temná fialová barva s detailními zuby a očima.',                                           99,  149, 199, 43, false, true,  false, 178, NULL, 'black',  ARRAY['black','gray'],      'PLA+ Premium'),
('Mini Bulbasaur',           'Miniatures', 'Klasická figurka Bulbasaura s cibulovým výrůstkem. Skvělý dárek pro fanoušky první generace.',                                89,  129, 179, 58, false, true,  false, 193, NULL, 'white',  ARRAY['white','gray'],      'PLA Standard'),
('Mini Charmander',          'Miniatures', 'Ohnivý Charmander v útočné poloze. Oranžová barva s detailním ocasem a plamenem.',                                            99,  149, 199, 71, false, true,  false, 231, NULL, 'black',  ARRAY['black','white'],     'PLA+ Premium'),
('Mini Squirtle',            'Miniatures', 'Roztomilý Squirtle ve stoji. Světle modrá barva s hnědým krunýřem a velkýma očima.',                                          89,  129, 179, 62, false, true,  false, 167, NULL, 'white',  ARRAY['white','gray'],      'PLA Standard'),
('Mini Snorlax',             'Miniatures', 'Spící Snorlax v odpočinkové poloze. Ideální jako těžítko nebo dekorace na monitor.',                                          99,  149, 199, 48, false, true,  false, 142, NULL, 'white',  ARRAY['white','gray'],      'PLA Standard'),
('Mini Mewtwo',              'Miniatures', 'Ikonický Mewtwo v meditační poloze. Stříbrná barva s fialovými detaily a impozantním vzhledem.',                             109, 169, 229, 33, false, true,  true,  89,  NULL, 'white',  ARRAY['white','gray'],      'PLA+ Premium'),
('Mini Charizard',           'Miniatures', 'Drak Charizard s rozpjatými křídly. Detailní figurka z lehkého PLA filamentu, stabilní základna.',                            119, 179, 249, 27, true,  true,  false, 198, NULL, 'black',  ARRAY['black','white'],     'PLA+ Premium'),
('Mini Jigglypuff',          'Miniatures', 'Kulatá Jigglypuff s otevřenou pusou jako vždy připravena zpívat. Růžová a roztomilá.',                                         79, 119, 159, 54, false, true,  false, 121, NULL, 'white',  ARRAY['white'],             'PLA Standard'),
('Mini Meowth',              'Miniatures', 'Meowth s zlatou mincí. Šedá barva s detailní tváří a typickým výrazem spokojenosti.',                                          89, 129, 179, 49, false, true,  false, 108, NULL, 'white',  ARRAY['white','gray'],      'PLA Standard'),
('Mini Lucario',             'Miniatures', 'Bojový Lucario v postoji. Modrá a černá barva s detailními bodci a expresivním výrazem.',                                      99, 149, 199, 38, false, true,  true,  74,  NULL, 'black',  ARRAY['black','white'],     'PLA+ Premium'),
('Mini Gyarados',            'Miniatures', 'Impozantní Gyarados v spirále. Modrá barva s bílými šupinami a dramatickým výrazem.',                                         129, 199, 279, 19, false, true,  true,  47,  NULL, 'white',  ARRAY['white','gray'],      'PLA+ Premium'),
('Mini Dragon',              'Miniatures', 'Fantazijní dragoní figurka s křídly. Ideální pro fandy fantasy žánru i jako dekorace.',                                        99,  149, 199, 88, false, true,  false, 312, NULL, 'black',  ARRAY['black','white','gray'],'PLA Standard'),
('Mini Phoenix',             'Miniatures', 'Fénix ve vzletu s rozpjatými křídly z ohně. Červená a zlatá barva, dramatický design.',                                       119, 179, 249, 23, false, true,  true,  38,  NULL, 'black',  ARRAY['black','white'],     'PLA+ Premium'),

-- ── Doplňky (7 kusů) ──────────────────────────────────────────
('Display Stand S',          'Doplňky',   'Akrylový stojan pro Pokébowl Small. Transparentní základna se zlatým detailem. Výška 6 cm.',                                    49,  79,  0,   312, false, true,  false, 445, NULL, 'black',  ARRAY['black','white'],     'Akryl'),
('Display Stand L',          'Doplňky',   'Akrylový stojan pro Standard a Maxi. Stabilní základna s protiskluzovými nožičkami.',                                           69,  99,  0,   234, false, true,  false, 378, NULL, 'black',  ARRAY['black','white'],     'Akryl'),
('Display Stand XL',         'Doplňky',   'Prémiový stojan pro Maxi Pokébowl. Rotační základna 360°, zlatý lem.',                                                           99, 149,  0,   87,  false, true,  true,  112, NULL, 'black',  ARRAY['black','white'],     'Akryl Premium'),
('Dárková krabička S',       'Doplňky',   'Prémiová dárková krabička s magnetickým víkem a hedvábnou výplní. Pro Small Pokébowl.',                                          49,  0,    0,   445, false, true,  false, 678, NULL, 'black',  ARRAY['black','white'],     'Karton Premium'),
('Dárková krabička L',       'Doplňky',   'Větší prémiová dárková krabička pro Standard a Maxi. Zlatá stuha a vizitka zdarma.',                                             69,  0,    0,   312, false, true,  false, 534, NULL, 'black',  ARRAY['black','white'],     'Karton Premium'),
('LED Podstavec',            'Doplňky',   'RGB LED podstavec s dálkovým ovladačem. 16 barev, 4 režimy svícení. Napájení USB.',                                             149, 0,    0,   67,  false, true,  true,  89,  NULL, 'black',  ARRAY['black','white'],     'Plast + LED'),
('Čistící souprava',         'Doplňky',   'Profesionální souprava pro čištění 3D tisku: měkký štětec, mikrovlákno, PLA-safe čistič.',                                       79,  0,    0,   134, false, true,  false, 156, NULL, 'black',  ARRAY['black'],             'Mix materiálů'),

-- ── Sety (3 kusy) ─────────────────────────────────────────────
('Starter Set Classic',      'Sety',      'Sada 3× Pokébowl Classic v různých barvách (černá + bílá + šedá). Výhodná cena, perfektní start sbírky.',                      0,  749,  0,   34,  true,  true,  false, 87,  NULL, 'black',  ARRAY['black','white','gray'], 'PLA Standard'),
('Collector Set',            'Sety',      'Exkluzivní sada 5× Pokébowl ve speciálních edicích (Shadow, Gold, Crystal, Galaxy, Prism). Limitováno.',                         0, 1999,  0,   8,   true,  true,  true,  12,  NULL, 'black',  ARRAY['black','white'],     'Mix'),
('Mini Starter Set',         'Sety',      'Sada 5 miniatur: Pikachu, Eevee, Bulbasaur, Charmander, Squirtle. Kompletní základní kolekce.',                                  0,  549,  0,   23,  false, true,  true,  31,  NULL, 'white',  ARRAY['white'],             'PLA Standard');

-- ══════════════════════════════════════════════════════════════
-- FAQ — 30 otázek
-- ══════════════════════════════════════════════════════════════
INSERT INTO faq (question, answer, category, sort_order, is_visible) VALUES
-- Obecné
('Co je Drobnostík?',                     'Drobnostík je český e-shop specializující se na prémiové 3D tisknuté Pokéboly a figurky. Vyrábíme v Praze z kvalitního PLA filamentu.', 'obecné', 1, true),
('Kde Pokéboly vyrábíte?',                'Vyrábíme výhradně v České republice v naší dílně v Praze. Každý kus je ručně zkontrolován před odesláním.', 'obecné', 2, true),
('Jsou Pokéboly originální merch?',       'Ne, jsou to fanouškovské výrobky vytvořené 3D tiskem. Nejsou officiálním merchangisingem Nintendo ani The Pokémon Company.', 'obecné', 3, true),
('Mohu si produkt vyzkoušet před koupí?', 'Nabízíme možnost osobního odběru v Praze, kde si zboží prohlédnete. Kontaktujte nás pro domluvení termínu.', 'obecné', 4, true),
('Jak probíhá výroba?',                   'Produkty tiskneme na profesionálních FDM tiskárnách s přesností 0,1 mm. Poté následuje post-processing: broušení, kontrola kvality a balení.', 'obecné', 5, true),
-- Materiál
('Z čeho jsou Pokéboly vyrobeny?',        'Všechny produkty tiskujeme z PLA nebo PLA+ filamentu, který je biologicky rozložitelný a bezpečný pro každodenní použití.', 'materiál', 6, true),
('Je PLA bezpečné pro děti?',             'PLA je biologicky rozložitelný plast bez toxických látek. Pro děti do 3 let ale nedoporučujeme kvůli malým dílům.', 'materiál', 7, true),
('Jak pečovat o Pokébowl?',               'Otírejte suchým nebo mírně vlhkým hadříkem. Vyhněte se agresivním čisticím prostředkům a přímému slunečnímu záření po delší dobu.', 'materiál', 8, true),
('Lze Pokébowl použít na jídlo?',         'Ne, naše produkty jsou dekorativní předměty. Nejsou certifikovány pro přímý kontakt s potravinami.', 'materiál', 9, true),
('Jaká je maximální teplota pro PLA?',    'PLA začíná měknout při cca 60 °C. Nenechávejte produkty v autě za slunečného dne nebo v blízkosti zdroje tepla.', 'materiál', 10, true),
('Jaký je rozdíl PLA vs PLA+?',           'PLA+ je vylepšená verze s větší pevností, lepší pružností a odolností vůči poškrábání. Používáme ho pro prémiové edice.', 'materiál', 11, true),
-- Doprava
('Jaké jsou možnosti dopravy?',           'Standardní zásilka 99 Kč (3–5 dní), Express 249 Kč (1–2 dny), osobní odběr Praha zdarma. Doprava zdarma od 1 500 Kč.', 'doprava', 12, true),
('Doručujete do zahraničí?',              'Zatím doručujeme pouze v rámci České republiky. Zahraniční dopravu plánujeme spustit v druhé polovině 2026.', 'doprava', 13, true),
('Jak sledovat zásilku?',                 'Po odeslání zásilky obdržíte email s číslem zásilky. Stav lze sledovat také na stránce Sledovat objednávku.', 'doprava', 14, true),
('Co když zásilka přijde poškozená?',     'Vyfotografujte poškozené zboží i obal a kontaktujte nás do 48 hodin. Zašleme náhradu zdarma nebo vrátíme peníze.', 'doprava', 15, true),
-- Obchod
('Jaké jsou platební metody?',            'Přijímáme platbu kartou online, bankovním převodem a v hotovosti při osobním odběru. Platba na dobírku není dostupná.', 'obchod', 16, true),
('Mohu vrátit zboží?',                    'Ano, přijímáme vrácení do 14 dní od doručení bez udání důvodu. Zboží musí být nepoužité v originálním balení.', 'obchod', 17, true),
('Jak probíhá reklamace?',                'Vyplňte reklamační formulář nebo nás kontaktujte emailem. Reklamaci vyřídíme do 30 dní od obdržení zboží.', 'obchod', 18, true),
('Mají produkty záruku?',                 'Poskytujeme 24měsíční zákonnou záruční lhůtu na vady materiálu a zpracování.', 'obchod', 19, true),
('Mohu změnit nebo zrušit objednávku?',   'Objednávku lze změnit nebo zrušit do 1 hodiny od odeslání (pokud ještě nebyla zahájena výroba). Kontaktujte nás co nejdříve.', 'obchod', 20, true),
-- Design
('Mohu si objednat vlastní barvu?',       'Pro zakázkové barvy nás kontaktujte přes formulář. Zakázkový tisk je možný od 3 kusů, cena se liší dle dostupnosti filamentu.', 'design', 21, true),
('Nabízíte gravírování nebo potisk?',     'Momentálně ne, ale plánujeme spustit personalizaci (gravírování jména) v druhé polovině 2026.', 'design', 22, true),
('Mohu dostat vlastní 3D model?',         'Ano, pro firemní zakázky. Minimální objednávka 10 kusů, cena dle složitosti modelu. Pište na info@drobnostik.cz.', 'design', 23, true),
-- Slevy
('Jak získám slevový kód?',               'Slevy poskytujeme odběratelům newsletteru (10% na první nákup), věrnostním zákazníkům a v rámci sezónních akcí.', 'slevy', 24, true),
('Jsou slevy pro školy a spolky?',        'Ano! Pro školy, spolky a neziskové organizace nabízíme slevu 15% při objednávce nad 10 kusů. Kontaktujte nás.', 'slevy', 25, true),
('Lze kombinovat slevové kódy?',          'Ne, v jedné objednávce lze použít pouze jeden slevový kód.', 'slevy', 26, true),
('Kdy se obnoví skladem vyprodané produkty?', 'Výroba nové série trvá 5–10 pracovních dní. Přihlaste se k notifikaci na stránce produktu nebo sledujte náš newsletter.', 'obecné', 27, true),
('Vydáváte fakturu?',                     'Ano, fakturu vystavujeme automaticky ke každé objednávce a posíláme emailem. Pro firmy lze doplnit IČO a DIČ.', 'obchod', 28, true),
('Nabízíte dárkové balení?',              'Ano, prémiové dárkové krabičky s magnetickým víkem a hedvábnou výplní jsou dostupné jako samostatný produkt v sekci Doplňky.', 'obecné', 29, true),
('Jak se stát affiliate partnerem?',      'Zaregistrujte se na stránce Affiliate program. Po schválení dostanete unikátní referral kód a 10% provizi z každého prodeje.', 'obecné', 30, true);

-- ══════════════════════════════════════════════════════════════
-- NEWSLETTER SUBSCRIBERS — 100 odběratelů
-- ══════════════════════════════════════════════════════════════
INSERT INTO newsletter_subscribers (email, subscribed_at) VALUES
('adam.novak@gmail.com',         NOW() - INTERVAL '180 days'),
('bara.svobodova@seznam.cz',     NOW() - INTERVAL '175 days'),
('cestmir.horak@email.cz',       NOW() - INTERVAL '170 days'),
('dana.markova@gmail.com',       NOW() - INTERVAL '165 days'),
('erik.dvorak@outlook.com',      NOW() - INTERVAL '160 days'),
('frantisek.kucera@gmail.com',   NOW() - INTERVAL '155 days'),
('gabriela.bila@seznam.cz',      NOW() - INTERVAL '150 days'),
('hana.pokorna@email.cz',        NOW() - INTERVAL '145 days'),
('ivan.kratochvil@gmail.com',    NOW() - INTERVAL '140 days'),
('jana.simankova@seznam.cz',     NOW() - INTERVAL '135 days'),
('karel.prochazka@gmail.com',    NOW() - INTERVAL '130 days'),
('lucie.cerna@email.cz',         NOW() - INTERVAL '125 days'),
('martin.vejvoda@gmail.com',     NOW() - INTERVAL '120 days'),
('natalie.hruskova@seznam.cz',   NOW() - INTERVAL '115 days'),
('ondrej.masek@gmail.com',       NOW() - INTERVAL '110 days'),
('petra.slanina@email.cz',       NOW() - INTERVAL '105 days'),
('radek.benes@gmail.com',        NOW() - INTERVAL '100 days'),
('simona.kovarik@seznam.cz',     NOW() - INTERVAL '95 days'),
('tomas.blazek@gmail.com',       NOW() - INTERVAL '90 days'),
('uzka.fialova@email.cz',        NOW() - INTERVAL '88 days'),
('vaclav.stary@gmail.com',       NOW() - INTERVAL '85 days'),
('wolf.zeman@seznam.cz',         NOW() - INTERVAL '82 days'),
('xenie.klima@gmail.com',        NOW() - INTERVAL '79 days'),
('yvona.stepan@email.cz',        NOW() - INTERVAL '76 days'),
('zbynek.urban@gmail.com',       NOW() - INTERVAL '73 days'),
('alzbeta.vrana@seznam.cz',      NOW() - INTERVAL '70 days'),
('bogdan.maly@gmail.com',        NOW() - INTERVAL '67 days'),
('cyril.kovar@email.cz',         NOW() - INTERVAL '64 days'),
('denisa.havlova@gmail.com',     NOW() - INTERVAL '62 days'),
('edgar.fiala@seznam.cz',        NOW() - INTERVAL '60 days'),
('filippa.ruzicka@gmail.com',    NOW() - INTERVAL '58 days'),
('goran.pospisil@email.cz',      NOW() - INTERVAL '56 days'),
('helena.machova@gmail.com',     NOW() - INTERVAL '54 days'),
('igor.navratil@seznam.cz',      NOW() - INTERVAL '52 days'),
('julia.nedvedova@gmail.com',    NOW() - INTERVAL '50 days'),
('kamil.stransky@email.cz',      NOW() - INTERVAL '48 days'),
('lenka.chalupova@gmail.com',    NOW() - INTERVAL '46 days'),
('milan.hrebicek@seznam.cz',     NOW() - INTERVAL '44 days'),
('nora.valentova@gmail.com',     NOW() - INTERVAL '42 days'),
('otakar.sedlak@email.cz',       NOW() - INTERVAL '40 days'),
('pavla.jirak@gmail.com',        NOW() - INTERVAL '38 days'),
('quido.vesely@seznam.cz',       NOW() - INTERVAL '36 days'),
('renata.dostal@gmail.com',      NOW() - INTERVAL '34 days'),
('stanislav.holub@email.cz',     NOW() - INTERVAL '32 days'),
('tereza.kopecka@gmail.com',     NOW() - INTERVAL '30 days'),
('uwe.janda@seznam.cz',          NOW() - INTERVAL '28 days'),
('vera.janeckova@gmail.com',     NOW() - INTERVAL '26 days'),
('walter.broz@email.cz',         NOW() - INTERVAL '24 days'),
('xaver.svec@gmail.com',         NOW() - INTERVAL '22 days'),
('yveta.hajkova@seznam.cz',      NOW() - INTERVAL '20 days'),
('zbysek.krenek@gmail.com',      NOW() - INTERVAL '18 days'),
('adam.cerveny@email.cz',        NOW() - INTERVAL '16 days'),
('barbora.stastna@gmail.com',    NOW() - INTERVAL '14 days'),
('ctibor.vlcek@seznam.cz',       NOW() - INTERVAL '12 days'),
('dorota.jerabkova@gmail.com',   NOW() - INTERVAL '10 days'),
('emil.kubes@email.cz',          NOW() - INTERVAL '9 days'),
('flora.cagas@gmail.com',        NOW() - INTERVAL '8 days'),
('gustav.pechacek@seznam.cz',    NOW() - INTERVAL '7 days'),
('hynek.stransky@gmail.com',     NOW() - INTERVAL '6 days'),
('irena.vlkova@email.cz',        NOW() - INTERVAL '5 days'),
('jan.sedivy@gmail.com',         NOW() - INTERVAL '5 days'),
('klara.suchanova@seznam.cz',    NOW() - INTERVAL '4 days'),
('leos.borovicka@gmail.com',     NOW() - INTERVAL '4 days'),
('monika.zatloukal@email.cz',    NOW() - INTERVAL '3 days'),
('norbert.ryba@gmail.com',       NOW() - INTERVAL '3 days'),
('olga.tesarova@seznam.cz',      NOW() - INTERVAL '2 days'),
('patrik.kaspar@gmail.com',      NOW() - INTERVAL '2 days'),
('radmila.holikova@email.cz',    NOW() - INTERVAL '2 days'),
('sobeslav.kohout@gmail.com',    NOW() - INTERVAL '1 day'),
('tatana.kollar@seznam.cz',      NOW() - INTERVAL '1 day'),
('uljana.krejci@gmail.com',      NOW() - INTERVAL '1 day'),
('vit.truhlar@email.cz',         NOW() - INTERVAL '23 hours'),
('wanda.sarka@gmail.com',        NOW() - INTERVAL '22 hours'),
('xantipa.nova@seznam.cz',       NOW() - INTERVAL '21 hours'),
('yaroslav.cerha@gmail.com',     NOW() - INTERVAL '20 hours'),
('zuzana.drabek@email.cz',       NOW() - INTERVAL '19 hours'),
('ales.podany@gmail.com',        NOW() - INTERVAL '18 hours'),
('bozena.placek@seznam.cz',      NOW() - INTERVAL '17 hours'),
('czech.pokemon.fan@gmail.com',  NOW() - INTERVAL '16 hours'),
('daniel.skrabal@email.cz',      NOW() - INTERVAL '15 hours'),
('eliska.zaplatilova@gmail.com', NOW() - INTERVAL '14 hours'),
('frantisek.zika@seznam.cz',     NOW() - INTERVAL '13 hours'),
('gertruda.nosal@gmail.com',     NOW() - INTERVAL '12 hours'),
('hans.moravec@email.cz',        NOW() - INTERVAL '11 hours'),
('ilona.brychta@gmail.com',      NOW() - INTERVAL '10 hours'),
('jakub.trnavsky@seznam.cz',     NOW() - INTERVAL '9 hours'),
('kristyna.zemanova@gmail.com',  NOW() - INTERVAL '8 hours'),
('lubomir.hajek@email.cz',       NOW() - INTERVAL '7 hours'),
('marie.cechova@gmail.com',      NOW() - INTERVAL '6 hours'),
('nikola.blazkova@seznam.cz',    NOW() - INTERVAL '5 hours'),
('oldrich.petrik@gmail.com',     NOW() - INTERVAL '4 hours'),
('pavlina.valkova@email.cz',     NOW() - INTERVAL '3 hours'),
('richard.pesta@gmail.com',      NOW() - INTERVAL '2 hours'),
('sarka.kovarikova@seznam.cz',   NOW() - INTERVAL '90 minutes'),
('tibor.polak@gmail.com',        NOW() - INTERVAL '60 minutes'),
('ursula.dufkova@email.cz',      NOW() - INTERVAL '45 minutes'),
('viktor.marecek@gmail.com',     NOW() - INTERVAL '30 minutes'),
('wilhelmina.raus@seznam.cz',    NOW() - INTERVAL '20 minutes'),
('xaver.smid@gmail.com',         NOW() - INTERVAL '10 minutes'),
('yvonne.branda@email.cz',       NOW() - INTERVAL '5 minutes'),
('zdenek.pavelka@gmail.com',     NOW() - INTERVAL '2 minutes');

-- ══════════════════════════════════════════════════════════════
-- ORDERS — 50 objednávek
-- ══════════════════════════════════════════════════════════════
INSERT INTO orders (order_number, customer_name, customer_email, customer_phone, customer_street, customer_city, customer_postal, shipping_method, shipping_cost, total_amount, status, created_at) VALUES
('ORD-1001','Tomáš Novák',       'tomas.novak@gmail.com',         '+420 601 100 001','Dlouhá 15',         'Praha',       '110 00','standard',99, 597, 'delivered',  NOW()-INTERVAL '90 days'),
('ORD-1002','Petra Svobodová',   'petra.svobodova@seznam.cz',     '+420 601 100 002','Náměstí 3',         'Brno',        '602 00','express', 249,997, 'delivered',  NOW()-INTERVAL '88 days'),
('ORD-1003','Jakub Horák',       'jakub.horak@email.cz',          '+420 601 100 003','Lipová 7',          'Ostrava',     '702 00','standard',99, 398, 'delivered',  NOW()-INTERVAL '85 days'),
('ORD-1004','Lucie Marková',     'lucie.markova@gmail.com',       '+420 601 100 004','Zahradní 22',       'Plzeň',       '301 00','pickup',  0,  499, 'delivered',  NOW()-INTERVAL '82 days'),
('ORD-1005','Martin Dvořák',     'martin.dvorak@seznam.cz',       '+420 601 100 005','Polní 1',           'Liberec',     '460 01','standard',99, 299, 'delivered',  NOW()-INTERVAL '80 days'),
('ORD-1006','Anna Procházková',  'anna.prochazka@email.cz',       '+420 601 100 006','Mírová 8',          'Olomouc',     '779 00','express', 249,797, 'delivered',  NOW()-INTERVAL '78 days'),
('ORD-1007','Ondřej Kučera',     'ondrej.kucera@gmail.com',       '+420 601 100 007','Lesní 44',          'Hradec Kr.',  '500 02','standard',99, 448, 'delivered',  NOW()-INTERVAL '75 days'),
('ORD-1008','Veronika Bílá',     'veronika.bila@seznam.cz',       '+420 601 100 008','Školní 2',          'Pardubice',   '530 02','standard',99, 398, 'delivered',  NOW()-INTERVAL '72 days'),
('ORD-1009','Radek Pokorný',     'radek.pokorny@email.cz',        '+420 601 100 009','Příčná 9',          'České Bud.',  '370 01','express', 249,646, 'delivered',  NOW()-INTERVAL '70 days'),
('ORD-1010','Simona Černá',      'simona.cerna@gmail.com',        '+420 601 100 010','Nová 17',           'Zlín',        '760 01','standard',99, 298, 'delivered',  NOW()-INTERVAL '68 days'),
('ORD-1011','Filip Kratochvíl',  'filip.kratochvil@seznam.cz',    '+420 601 100 011','Hlavní 55',         'Jihlava',     '586 01','standard',99, 448, 'delivered',  NOW()-INTERVAL '65 days'),
('ORD-1012','Eva Nováková',      'eva.novakova@email.cz',         '+420 601 100 012','Sadová 3',          'Kladno',      '272 01','pickup',  0,  149, 'delivered',  NOW()-INTERVAL '62 days'),
('ORD-1013','Pavel Šimánek',     'pavel.simanek@gmail.com',       '+420 601 100 013','Průmyslová 11',     'Most',        '434 01','standard',99, 547, 'delivered',  NOW()-INTERVAL '60 days'),
('ORD-1014','Michaela Horáčková','michaela.horackova@seznam.cz',  '+420 601 100 014','Botanická 6',       'Brno',        '602 00','express', 249,897, 'delivered',  NOW()-INTERVAL '58 days'),
('ORD-1015','Stanislav Holub',   'stanislav.holub@email.cz',      '+420 601 100 015','Vinohradská 33',   'Praha',       '120 00','standard',99, 348, 'delivered',  NOW()-INTERVAL '55 days'),
('ORD-1016','Renata Dostálová',  'renata.dostalova@gmail.com',    '+420 601 100 016','Tyršova 4',         'Opava',       '746 01','standard',99, 448, 'delivered',  NOW()-INTERVAL '52 days'),
('ORD-1017','Kamil Stránský',    'kamil.stransky@seznam.cz',      '+420 601 100 017','Husova 19',         'Teplice',     '415 01','pickup',  0,  299, 'delivered',  NOW()-INTERVAL '50 days'),
('ORD-1018','Lenka Chaloupková', 'lenka.chaloupkova@email.cz',    '+420 601 100 018','Přemyslova 8',      'Olomouc',     '779 00','standard',99, 697, 'delivered',  NOW()-INTERVAL '48 days'),
('ORD-1019','Milan Hřebíček',    'milan.hrebicek@gmail.com',      '+420 601 100 019','Sokolská 21',       'Ostrava',     '702 00','express', 249,747, 'delivered',  NOW()-INTERVAL '45 days'),
('ORD-1020','Nora Valentová',    'nora.valentova@seznam.cz',      '+420 601 100 020','Komenského 5',      'Ústí n. Lab.','400 01','standard',99, 398, 'delivered',  NOW()-INTERVAL '42 days'),
('ORD-1021','Otakar Sedlák',     'otakar.sedlak@email.cz',        '+420 601 100 021','Náměstí míru 1',   'Praha',       '120 00','standard',99, 498, 'delivered',  NOW()-INTERVAL '40 days'),
('ORD-1022','Pavla Jiráková',    'pavla.jirakova@gmail.com',      '+420 601 100 022','Riegrova 7',        'Liberec',     '460 01','express', 249,997, 'delivered',  NOW()-INTERVAL '38 days'),
('ORD-1023','Quido Veselý',      'quido.vesely@seznam.cz',        '+420 601 100 023','Chelčického 3',     'Plzeň',       '301 00','standard',99, 348, 'delivered',  NOW()-INTERVAL '36 days'),
('ORD-1024','Dana Marková',      'dana.markova@email.cz',         '+420 601 100 024','Studentská 12',     'Brno',        '612 00','pickup',  0,  749, 'delivered',  NOW()-INTERVAL '34 days'),
('ORD-1025','Erik Dvořák',       'erik.dvorak@gmail.com',         '+420 601 100 025','Mánesova 9',        'Praha',       '120 00','express', 249,698, 'delivered',  NOW()-INTERVAL '32 days'),
('ORD-1026','Gabriela Bílá',     'gabriela.bila@seznam.cz',       '+420 601 100 026','Janáčkova 14',      'Brno',        '602 00','standard',99, 448, 'shipped',    NOW()-INTERVAL '14 days'),
('ORD-1027','Hana Pokorná',      'hana.pokorna@email.cz',         '+420 601 100 027','Divadelní 2',       'Ostrava',     '702 00','standard',99, 299, 'shipped',    NOW()-INTERVAL '12 days'),
('ORD-1028','Ivan Kratochvíl',   'ivan.kratochvil@gmail.com',     '+420 601 100 028','Palachova 5',       'Hradec Kr.',  '500 02','express', 249,897, 'shipped',    NOW()-INTERVAL '10 days'),
('ORD-1029','Jana Šimánková',    'jana.simankova@seznam.cz',      '+420 601 100 029','Lidická 31',        'Kladno',      '272 01','standard',99, 398, 'shipped',    NOW()-INTERVAL '9 days'),
('ORD-1030','Karel Procházka',   'karel.prochazka@email.cz',      '+420 601 100 030','Palackého 7',       'Praha',       '110 00','standard',99, 547, 'shipped',    NOW()-INTERVAL '8 days'),
('ORD-1031','Lucie Černá',       'lucie.cerna@gmail.com',         '+420 601 100 031','Jiráskova 16',      'Pardubice',   '530 02','pickup',  0,  299, 'processing', NOW()-INTERVAL '7 days'),
('ORD-1032','Martin Vejvoda',    'martin.vejvoda@seznam.cz',      '+420 601 100 032','Havlíčkova 4',      'Jihlava',     '586 01','standard',99, 448, 'processing', NOW()-INTERVAL '6 days'),
('ORD-1033','Natalie Hrušková',  'natalie.hruskova@email.cz',     '+420 601 100 033','Erbenova 8',        'Zlín',        '760 01','express', 249,997, 'processing', NOW()-INTERVAL '5 days'),
('ORD-1034','Ondřej Mašek',      'ondrej.masek@gmail.com',        '+420 601 100 034','Chelčického 21',    'Teplice',     '415 01','standard',99, 348, 'processing', NOW()-INTERVAL '4 days'),
('ORD-1035','Petra Slaninová',   'petra.slanina@seznam.cz',       '+420 601 100 035','Žerotínova 3',      'Brno',        '602 00','standard',99, 398, 'processing', NOW()-INTERVAL '4 days'),
('ORD-1036','Radek Beneš',       'radek.benes@email.cz',          '+420 601 100 036','Rokycanova 11',     'Plzeň',       '301 00','pickup',  0,  749, 'pending',    NOW()-INTERVAL '3 days'),
('ORD-1037','Simona Kovářík',    'simona.kovarik@gmail.com',      '+420 601 100 037','Chodská 5',         'Praha',       '130 00','standard',99, 299, 'pending',    NOW()-INTERVAL '3 days'),
('ORD-1038','Tomáš Blažek',      'tomas.blazek@seznam.cz',        '+420 601 100 038','Třebízského 7',     'Ostrava',     '702 00','express', 249,847, 'pending',    NOW()-INTERVAL '2 days'),
('ORD-1039','Uršula Fialová',    'uzka.fialova@email.cz',         '+420 601 100 039','Anglická 9',        'Praha',       '120 00','standard',99, 448, 'pending',    NOW()-INTERVAL '2 days'),
('ORD-1040','Václav Starý',      'vaclav.stary@gmail.com',        '+420 601 100 040','Máchova 14',        'Liberec',     '460 01','standard',99, 598, 'pending',    NOW()-INTERVAL '1 day'),
('ORD-1041','Wolf Zeman',        'wolf.zeman@seznam.cz',          '+420 601 100 041','Budějovická 3',     'Praha',       '140 00','express', 249,997, 'pending',    NOW()-INTERVAL '1 day'),
('ORD-1042','Xenie Klíma',       'xenie.klima@email.cz',          '+420 601 100 042','Štefánikova 22',    'Brno',        '602 00','standard',99, 348, 'pending',    NOW()-INTERVAL '18 hours'),
('ORD-1043','Yvona Štěpán',      'yvona.stepan@gmail.com',        '+420 601 100 043','Heydukova 6',       'Plzeň',       '301 00','pickup',  0,  299, 'pending',    NOW()-INTERVAL '12 hours'),
('ORD-1044','Zbyněk Urban',      'zbynek.urban@seznam.cz',        '+420 601 100 044','Slovákova 8',       'Brno',        '602 00','standard',99, 448, 'pending',    NOW()-INTERVAL '6 hours'),
('ORD-1045','Alžběta Vránová',   'alzbeta.vrana@email.cz',        '+420 601 100 045','Kollárova 4',       'Olomouc',     '779 00','express', 249,747, 'pending',    NOW()-INTERVAL '3 hours'),
('ORD-1046','Bogdan Malý',       'bogdan.maly@gmail.com',         '+420 601 100 046','Šafaříkova 11',     'Hradec Kr.',  '500 02','standard',99, 398, 'pending',    NOW()-INTERVAL '2 hours'),
('ORD-1047','Cyril Kovář',       'cyril.kovar@seznam.cz',         '+420 601 100 047','Žižkova 19',        'Ostrava',     '702 00','standard',99, 298, 'pending',    NOW()-INTERVAL '90 minutes'),
('ORD-1048','Denisa Havlová',    'denisa.havlova@email.cz',        '+420 601 100 048','Chelčického 7',    'Praha',       '130 00','pickup',  0,  599, 'pending',    NOW()-INTERVAL '45 minutes'),
('ORD-1049','Edgar Fiala',       'edgar.fiala@gmail.com',         '+420 601 100 049','Rumunská 3',        'Praha',       '120 00','express', 249,998, 'pending',    NOW()-INTERVAL '20 minutes'),
('ORD-1050','Filippa Růžičková', 'filippa.ruzicka@seznam.cz',     '+420 601 100 050','Polská 5',          'Praha',       '120 00','standard',99, 448, 'pending',    NOW()-INTERVAL '5 minutes');

-- ══════════════════════════════════════════════════════════════
-- ORDER ITEMS (pro prvních 10 objednávek)
-- ══════════════════════════════════════════════════════════════
INSERT INTO order_items (order_id, product_id, product_name, color, size, quantity, unit_price, total_price)
SELECT o.id, 1, 'Pokébowl Classic', 'black', 'Standard', 2, 299, 598 FROM orders o WHERE o.order_number='ORD-1001';
INSERT INTO order_items (order_id, product_id, product_name, color, size, quantity, unit_price, total_price)
SELECT o.id, 2, 'Pokébowl Gold Edition', 'black', 'Standard', 1, 499, 499 FROM orders o WHERE o.order_number='ORD-1001';
INSERT INTO order_items (order_id, product_id, product_name, color, size, quantity, unit_price, total_price)
SELECT o.id, 2, 'Pokébowl Gold Edition', 'black', 'Standard', 2, 499, 998 FROM orders o WHERE o.order_number='ORD-1002';
INSERT INTO order_items (order_id, product_id, product_name, color, size, quantity, unit_price, total_price)
SELECT o.id, 1, 'Pokébowl Classic', 'white', 'Small', 2, 199, 398 FROM orders o WHERE o.order_number='ORD-1003';
INSERT INTO order_items (order_id, product_id, product_name, color, size, quantity, unit_price, total_price)
SELECT o.id, 2, 'Pokébowl Gold Edition', 'black', 'Standard', 1, 499, 499 FROM orders o WHERE o.order_number='ORD-1004';
INSERT INTO order_items (order_id, product_id, product_name, color, size, quantity, unit_price, total_price)
SELECT o.id, 1, 'Pokébowl Classic', 'gray', 'Standard', 1, 299, 299 FROM orders o WHERE o.order_number='ORD-1005';
INSERT INTO order_items (order_id, product_id, product_name, color, size, quantity, unit_price, total_price)
SELECT o.id, 3, 'Pokébowl Shadow', 'black', 'Standard', 2, 349, 698 FROM orders o WHERE o.order_number='ORD-1006';
INSERT INTO order_items (order_id, product_id, product_name, color, size, quantity, unit_price, total_price)
SELECT o.id, 4, 'Pokébowl Pearl', 'white', 'Standard', 1, 319, 319 FROM orders o WHERE o.order_number='ORD-1007';
INSERT INTO order_items (order_id, product_id, product_name, color, size, quantity, unit_price, total_price)
SELECT o.id, 21, 'Mini Pikachu', 'white', 'Standard', 1, 129, 129 FROM orders o WHERE o.order_number='ORD-1007';
INSERT INTO order_items (order_id, product_id, product_name, color, size, quantity, unit_price, total_price)
SELECT o.id, 1, 'Pokébowl Classic', 'black', 'Standard', 1, 299, 299 FROM orders o WHERE o.order_number='ORD-1008';
INSERT INTO order_items (order_id, product_id, product_name, color, size, quantity, unit_price, total_price)
SELECT o.id, 4, 'Pokébowl Pearl', 'white', 'Small', 1, 219, 219 FROM orders o WHERE o.order_number='ORD-1008';
INSERT INTO order_items (order_id, product_id, product_name, color, size, quantity, unit_price, total_price)
SELECT o.id, 3, 'Pokébowl Shadow', 'black', 'Standard', 2, 349, 698 FROM orders o WHERE o.order_number='ORD-1009';
INSERT INTO order_items (order_id, product_id, product_name, color, size, quantity, unit_price, total_price)
SELECT o.id, 21, 'Mini Pikachu', 'white', 'Small', 1, 89, 89 FROM orders o WHERE o.order_number='ORD-1010';
INSERT INTO order_items (order_id, product_id, product_name, color, size, quantity, unit_price, total_price)
SELECT o.id, 22, 'Mini Eevee', 'white', 'Small', 1, 89, 89 FROM orders o WHERE o.order_number='ORD-1010';
INSERT INTO order_items (order_id, product_id, product_name, color, size, quantity, unit_price, total_price)
SELECT o.id, 23, 'Mini Gengar', 'black', 'Standard', 1, 99, 99 FROM orders o WHERE o.order_number='ORD-1010';

-- ══════════════════════════════════════════════════════════════
-- REVIEWS — 100 recenzí
-- ══════════════════════════════════════════════════════════════
INSERT INTO reviews (product_id, author_name, author_email, rating, text, is_approved, is_verified, created_at) VALUES
(1,'Tomáš N.','tomas@ex.cz',5,'Naprosto úžasná kvalita! Tisk je precizní, barvy skvělé. Doporučuji každému sběrateli.', true,true, NOW()-INTERVAL '85 days'),
(1,'Petra S.','petra@ex.cz',5,'Dostala jako dárek a jsem nadšená. Doručení přišlo rychle a balení bylo pěkné.', true,true, NOW()-INTERVAL '80 days'),
(1,'Jakub H.','jakub@ex.cz',4,'Pěkný pokébowl, spokojený. Povrch mohl být trochu hladší, ale celkově top.', true,false,NOW()-INTERVAL '75 days'),
(1,'Eva N.','eva@ex.cz',5,'Třetí objednávka u Drobnostíku — opět 100%. Konzistentní kvalita, rychlé doručení.', true,true, NOW()-INTERVAL '70 days'),
(1,'Pavel Š.','pavel@ex.cz',5,'Jako dárek pro manžela — byl absolutně nadšený. Lepší než podobné produkty jinde.', true,true, NOW()-INTERVAL '65 days'),
(1,'Jana K.','jana@ex.cz',4,'Hezký design, barva odpovídá fotkám. Jen bych uvítala větší výběr barev.', true,false,NOW()-INTERVAL '60 days'),
(1,'Martin V.','martin@ex.cz',5,'Skvělé zpracování, precizní tisk. Ideální dekorace na pracovní stůl.', true,true, NOW()-INTERVAL '55 days'),
(1,'Lucie M.','lucie@ex.cz',3,'Výrobek je ok, ale čekal jsem více detailů v provedení. Doručení bylo v pořádku.', true,false,NOW()-INTERVAL '50 days'),
(1,'Ondřej K.','ondrej@ex.cz',5,'Pokébowl Classic je přesně takový jaký jsem si představoval. Rozhodně doporučuju.', true,true, NOW()-INTERVAL '45 days'),
(1,'Simona C.','simona@ex.cz',4,'Krásný výrobek, jsem spokojená. Příště zkusím Gold Edition.', true,false,NOW()-INTERVAL '40 days'),
(2,'Lucie M.','lucie2@ex.cz',5,'Gold Edition je prostě krása! Zlatý metalický efekt vypadá mnohem lépe než na fotkách.', true,true, NOW()-INTERVAL '82 days'),
(2,'Martin D.','martin2@ex.cz',5,'Koupit Gold Edition bylo nejlepší rozhodnutí. Přátelé jsou vždy ohromeni.', true,true, NOW()-INTERVAL '77 days'),
(2,'Pavel S.','pavel2@ex.cz',5,'Gold Edition jako dárek pro manžela — byl absolutně nadšený.', true,true, NOW()-INTERVAL '72 days'),
(2,'Dana M.','dana@ex.cz',4,'Nádherná barva, prémiové zpracování. Za tuto cenu výborná hodnota.', true,false,NOW()-INTERVAL '67 days'),
(2,'Filip K.','filip@ex.cz',5,'Nejlepší věc co jsem si kdy koupil pro svůj pokoj. Gold Edition prostě wow.', true,true, NOW()-INTERVAL '62 days'),
(3,'Anna P.','anna@ex.cz',5,'Shadow Edition je dokonalá! Matná černá s lesklými detaily — přesně co jsem hledala.', true,true, NOW()-INTERVAL '78 days'),
(3,'Ondřej K.','ondrej2@ex.cz',4,'Velmi pěkný produkt. Shadow edice vypadá elegantně a záhadně zároveň.', true,false,NOW()-INTERVAL '73 days'),
(3,'Radek P.','radek@ex.cz',5,'Shadow Edition je moje nejoblíbenější kousek sbírky. Absolutní top.', true,true, NOW()-INTERVAL '68 days'),
(3,'Kateřina B.','katerina@ex.cz',5,'Úžasná kvalita, dokonalý design. Moc doporučuju všem fanouškům temného stylu.', true,true, NOW()-INTERVAL '63 days'),
(3,'Michal N.','michal@ex.cz',4,'Skvělý výrobek, jen bych si přál více barevných variant. Jinak perfektní.', true,false,NOW()-INTERVAL '58 days'),
(4,'Veronika B.','veronika@ex.cz',5,'Pearl edice v bílé je naprosto božská! Elegantní a skvěle zpracovaná.', true,true, NOW()-INTERVAL '74 days'),
(4,'Tereza K.','tereza@ex.cz',4,'Krásná bílá barva, hedvábný povrch. Perfektní jako dárek.', true,false,NOW()-INTERVAL '69 days'),
(4,'Sandra L.','sandra@ex.cz',5,'Pearl je nejkrásnější kus mé sbírky. Bílá barva je přesně jak na fotkách.', true,true, NOW()-INTERVAL '64 days'),
(5,'Filip K.','filip2@ex.cz',5,'Retro edice je naprosto skvělá! Dřevěný efekt vypadá realisticky.', true,true, NOW()-INTERVAL '71 days'),
(5,'Tomáš B.','tomas2@ex.cz',4,'Pěkná retro edice, připomíná staré časy. Cena odpovídá kvalitě.', true,false,NOW()-INTERVAL '66 days'),
(6,'Jakub P.','jakub2@ex.cz',5,'Midnight je absolutně úchvatný! Metalický modrý efekt je neskutečný.', true,true, NOW()-INTERVAL '43 days'),
(6,'Natálie R.','natalie@ex.cz',5,'Krásná tmavá modrá, úžasný metalický lesk. Jedna z nejlepších edic.', true,true, NOW()-INTERVAL '38 days'),
(7,'Klára H.','klara@ex.cz',5,'Sakura je tak roztomilá! Perfektní dárek pro přítelkyni. Byla nadšená.', true,true, NOW()-INTERVAL '29 days'),
(7,'Marie J.','marie@ex.cz',4,'Pěkná růžová edice, barva je přesná. Doporučuju jako originální dárek.', true,false,NOW()-INTERVAL '24 days'),
(8,'Oldřich P.','oldrich@ex.cz',4,'Arctic je minimalistická a elegantní. Matný povrch vypadá prémiově.', true,false,NOW()-INTERVAL '35 days'),
(8,'Pavla J.','pavla@ex.cz',5,'Bílá matná edice je prostě dokonalá. Na polici vypadá fantasticky.', true,true, NOW()-INTERVAL '30 days'),
(9,'Renata D.','renata@ex.cz',5,'Ember je výrazná a odvážná! Přesně takový kus jsem hledala do svého pokoje.', true,true, NOW()-INTERVAL '22 days'),
(10,'Stanislav H.','stanislav@ex.cz',4,'Vintage wood efekt je unikátní. Každý kdo ho vidí se ptá kde jsem ho koupil.', true,false,NOW()-INTERVAL '41 days'),
(11,'Kamil S.','kamil@ex.cz',5,'Neon je úžasný! Za šera doslova svítí. Největší hit na mém herním stole.', true,true, NOW()-INTERVAL '18 days'),
(12,'Lenka C.','lenka@ex.cz',5,'Crystal edice — průhledná a nádherná. Vypadá jako kouzelný předmět.', true,true, NOW()-INTERVAL '15 days'),
(12,'Milan H.','milan@ex.cz',5,'Průhledný pokébowl — úžasný nápad a skvělé provedení. Absolutně originální.', true,true, NOW()-INTERVAL '10 days'),
(13,'Nora V.','nora@ex.cz',4,'Ocean edice krásná barva, dobrá cena se slevou. Spokojená.', true,false,NOW()-INTERVAL '25 days'),
(14,'Otakar S.','otakar@ex.cz',5,'Lava je dramatická a krásná. Na herním stole vypadá fantasticky.', true,true, NOW()-INTERVAL '12 days'),
(15,'Pavla J.','pavla2@ex.cz',4,'Forest zelená je uklidňující a přírodní. Skvělý doplněk do kanceláře.', true,false,NOW()-INTERVAL '32 days'),
(16,'Quido V.','quido@ex.cz',5,'Galaxy multi-color je naprosto magický! Každý kus je jiný — to je na tom to nejlepší.', true,true, NOW()-INTERVAL '20 days'),
(17,'Renata D.','renata2@ex.cz',4,'Bronze metallic vypadá luxusně. Sametový povrch je příjemný na dotek.', true,false,NOW()-INTERVAL '37 days'),
(18,'Simona K.','simona2@ex.cz',5,'Ice Blue je krásná! Ideální do zimně laděného pokoje. Moc doporučuju.', true,true, NOW()-INTERVAL '28 days'),
(19,'Tomáš B.','tomas3@ex.cz',4,'Inferno je výrazný a silný. Tmavě červená je přesně jak na fotkách.', true,false,NOW()-INTERVAL '17 days'),
(20,'Uršula F.','urzula@ex.cz',5,'Prism je absolutně magický! Mění barvu při každém pohybu — nikdo tomu nevěří dokud to nevidí.', true,true, NOW()-INTERVAL '8 days'),
(21,'Václav S.','vaclav@ex.cz',5,'Mini Pikachu je perfektní! Detailní zpracování, stabilní základna. Přesně jak má být.', true,true, NOW()-INTERVAL '76 days'),
(21,'Wolf Z.','wolf@ex.cz',4,'Roztomilý Pikachu, dobrá kvalita. Jako dárek pro dceru byl ideální.', true,false,NOW()-INTERVAL '71 days'),
(22,'Xenie K.','xenie@ex.cz',5,'Eevee je úžasná! Detailní srst, expresivní výraz. Oblíbená figurka mé sbírky.', true,true, NOW()-INTERVAL '66 days'),
(23,'Yvona Š.','yvona@ex.cz',5,'Gengar s úsměvem — dokonalý! Temná fialová barva je přesně správná.', true,true, NOW()-INTERVAL '61 days'),
(24,'Zbyněk U.','zbynek@ex.cz',4,'Bulbasaur pěkně zpracovaný. Cibulový výrůstek je detailní. Spokojený.', true,false,NOW()-INTERVAL '56 days'),
(25,'Adam N.','adam@ex.cz',5,'Charmander v útočné poloze — vypadá úžasně! Oranžová barva je perfektní.', true,true, NOW()-INTERVAL '51 days'),
(26,'Barbora S.','barbora@ex.cz',5,'Squirtle je roztomilý a detailní. Světle modrá barva je přesně jak jsem chtěla.', true,true, NOW()-INTERVAL '46 days'),
(27,'Ctibor V.','ctibor@ex.cz',4,'Snorlax jako těžítko — geniální nápad! Stabilní, těžký, roztomilý.', true,false,NOW()-INTERVAL '41 days'),
(28,'Dorota J.','dorota@ex.cz',5,'Mewtwo v meditaci — majestátní! Stříbrná barva s fialovými detaily je nádherná.', true,true, NOW()-INTERVAL '36 days'),
(29,'Emil K.','emil@ex.cz',5,'Charizard s křídly je nejlepší figurka v mé sbírce. Detaily jsou úžasné.', true,true, NOW()-INTERVAL '31 days'),
(30,'Flora C.','flora@ex.cz',4,'Jigglypuff je roztomilá a přesná. Růžová barva je správná. Spokojená.', true,false,NOW()-INTERVAL '26 days'),
(34,'Gustav P.','gustav@ex.cz',5,'Mini Dragon je skvělý! Ideální jako dekorace nebo dárek pro fantasy fanoušky.', true,true, NOW()-INTERVAL '57 days'),
(34,'Hynek S.','hynek@ex.cz',5,'Dragoní figurka je detailní a krásná. Koupil jsem tři — pro sebe i kamarády.', true,true, NOW()-INTERVAL '52 days'),
(34,'Irena V.','irena@ex.cz',4,'Dragon pěkný, ale čekal jsem větší velikost. Jinak spokojená.', true,false,NOW()-INTERVAL '47 days'),
(35,'Jan S.','jan@ex.cz',5,'Phoenix ve vzletu je absolutní umělecké dílo! Červená a zlatá barva jsou dokonalé.', true,true, NOW()-INTERVAL '14 days'),
(36,'Klára S.','klara2@ex.cz',5,'Display Stand je stabilní a elegantní. Transparentní akryl vypadá luxusně.', true,true, NOW()-INTERVAL '44 days'),
(37,'Leoš B.','leos@ex.cz',4,'Větší stojan L drží výborně. Pokébowl Standard na něm vypadá skvěle.', true,false,NOW()-INTERVAL '39 days'),
(38,'Monika Z.','monika@ex.cz',5,'Stand XL s rotací — geniální! Mohu obdivovat Pokébowl ze všech stran.', true,true, NOW()-INTERVAL '19 days'),
(39,'Norbert R.','norbert@ex.cz',5,'Dárková krabička je prémiová! Magnetické víko, hedvábná výplň. Dárek vypadal luxusně.', true,true, NOW()-INTERVAL '48 days'),
(40,'Olga T.','olga@ex.cz',4,'Krabička L je dostatečně velká. Zlatá stuha dělá dárek skutečně speciálním.', true,false,NOW()-INTERVAL '33 days'),
(41,'Patrik K.','patrik@ex.cz',5,'LED Podstavec je fantastický! RGB světla pod Pokébowlem — úžasná atmosféra.', true,true, NOW()-INTERVAL '9 days'),
(43,'Radmila H.','radmila@ex.cz',5,'Starter Set — skvělá hodnota! Tři Classic v různých barvách vypadají skvěle vedle sebe.', true,true, NOW()-INTERVAL '27 days'),
(43,'Sobeslav K.','sobeslav@ex.cz',4,'Set tří Classic je rozumná volba pro začátek sbírky. Doporučuju.', true,false,NOW()-INTERVAL '22 days'),
(44,'Taťána K.','tatana@ex.cz',5,'Collector Set je sen každého sběratele. Pět speciálních edic v jedné krabici — úžasné!', true,true, NOW()-INTERVAL '6 days'),
(45,'Uljana K.','uljana@ex.cz',5,'Mini Starter Set — perfektní pro fanoušky první generace. Všech 5 v jedné krabičce!', true,true, NOW()-INTERVAL '4 days'),
-- Dalších 30 různých recenzí
(1,'Radmila B.','radmila2@ex.cz',5,'Classic je nadčasový design. Kupuji opakovaně jako dárky.', true,true, NOW()-INTERVAL '30 days'),
(2,'Sobeslav M.','sobeslav2@ex.cz',5,'Gold Edition září! Metalický efekt je úžasný při jakémkoli světle.', true,true, NOW()-INTERVAL '25 days'),
(3,'Tatána P.','tatana2@ex.cz',5,'Shadow — temný a elegantní. Perfektní pro gaming setup.', true,true, NOW()-INTERVAL '20 days'),
(4,'Uljana R.','uljana2@ex.cz',4,'Pearl je jemná a krásná. Bílá barva je přesně správná.', true,false,NOW()-INTERVAL '16 days'),
(5,'Viktor M.','viktor@ex.cz',5,'Retro edice je moje nejoblíbenější. Dřevěný efekt je unikátní.', true,true, NOW()-INTERVAL '13 days'),
(21,'Wilhelmina R.','wilhelmina@ex.cz',4,'Pikachu je roztomilý! Dcera ho miluje. Dobrá kvalita za dobrou cenu.', true,false,NOW()-INTERVAL '21 days'),
(22,'Xaver S.','xaver@ex.cz',5,'Eevee je nejhezčí figurka co jsem kdy koupil. Detaily jsou fantastické.', true,true, NOW()-INTERVAL '17 days'),
(23,'Yvonne B.','yvonne@ex.cz',5,'Gengar s tím úsměvem je prostě perfektní. Fialová barva je naprosto správná.', true,true, NOW()-INTERVAL '11 days'),
(25,'Zdeněk P.','zdenek@ex.cz',4,'Charmander vypadá úžasně. Malé detaily jsou precizní.', true,false,NOW()-INTERVAL '7 days'),
(29,'Aleš P.','ales@ex.cz',5,'Charizard — král mé sbírky! Velikost je ideální, detail křídel je perfektní.', true,true, NOW()-INTERVAL '3 days'),
(1,'Božena P.','bozena@ex.cz',5,'Classic v šedé barvě je nejelegantnější varianta. Skvělá volba!', true,true, NOW()-INTERVAL '36 days'),
(2,'Czech Pokemon','czech_fan@ex.cz',5,'Gold Edition je výjimečná. Každý návštěvník si jí hned všimne.', true,true, NOW()-INTERVAL '31 days'),
(16,'Daniel S.','daniel@ex.cz',5,'Galaxy multi-color — každý úhel pohledu odhalí jinou barvu. Naprosto magické!', true,true, NOW()-INTERVAL '5 days'),
(12,'Eliška Z.','eliska@ex.cz',4,'Crystal je průhledná a krásná. Jedinečný design, velmi originální.', true,false,NOW()-INTERVAL '8 days'),
(20,'František Z.','frantisek@ex.cz',5,'Prism mění barvy jako duhová vlna. Absolutní hit na herním stole!', true,true, NOW()-INTERVAL '2 days');

-- ══════════════════════════════════════════════════════════════
-- BLOG POSTS — 15 článků
-- ══════════════════════════════════════════════════════════════
INSERT INTO blog_posts (title, slug, excerpt, content, author, category, reading_time, featured, status, published_at) VALUES
('Jak vzniká Pokéball — od 3D modelu k hotovému produktu',
 'jak-vznika-pokeball',
 'Nahlédněte do zákulisí naší dílny a zjistěte, jak trvá výroba jednoho kusu.',
 '<h2>Od nápadu k tiskárně</h2><p>Celý proces začíná v 3D modelovacím softwaru. Každý detail musí být přesně navržen. Poté přichází slicování, kalibrace tiskárny a samotný tisk, který trvá 4–8 hodin.</p><h2>Finalizace a kontrola kvality</h2><p>Po tisku přichází broušení, čištění a důkladná kontrola. Teprve pak balení a odeslání.</p>',
 'Tým Drobnostík','za-kulisami',5,true,'published',NOW()-INTERVAL '60 days'),

('5 tipů jak vystavit Pokéboly doma',
 'tipy-jak-vystavit-pokeboly',
 'Máte krásné pokéboly, ale nevíte jak je vystavit? Přinášíme 5 osvědčených tipů.',
 '<h2>1. Akrylové stojany</h2><p>Nejlepší volba pro elegantní prezentaci. Transparentní základ, zlatý detail.</p><h2>2. Police s LED podsvícením</h2><p>Zlatá barva pokéballů krásně vynikne při správném světle.</p><h2>3. Vitríny</h2><p>Pro větší sbírky — chrání před prachem a vypadají luxusně.</p><h2>4. Floating shelf</h2><p>Pokébaly na plovoucí polici bez viditelných úchytek — minimalistický efekt.</p><h2>5. Grouping</h2><p>Seskupení 3-5 kusů různých edic vytvoří silný vizuální dojem.</p>',
 'Jana K.','tipy',3,false,'published',NOW()-INTERVAL '55 days'),

('Shadow Edition — zákulisí nejoblíbenější edice',
 'shadow-edition-zakulisi',
 'Příběh vzniku naší nejtemnější a nejpopulárnější edice. Jak vznikla a proč trvalo tak dlouho?',
 '<h2>Inspirace</h2><p>Shadow Edition vznikla na základě zpětné vazby komunity. Hlasovalo přes 2 000 lidí a temná matná edice zvítězila jasně.</p><h2>Výzvy tisku</h2><p>Matný PLA filament je náročnější na tisk. Prvních 50 kusů šlo do koše. Až 51. byl dokonalý.</p><h2>Výsledek</h2><p>Shadow Edition je dnes naší nejprodávanější edicí.</p>',
 'Ondřej S.','za-kulisami',6,false,'published',NOW()-INTERVAL '50 days'),

('3D tisk doma vs. profesionální — jaký je rozdíl?',
 '3d-tisk-doma-vs-profesionalni',
 'Proč jsou profesionálně tisknuté pokéboly lepší než domácí výroba?',
 '<h2>Přesnost tisku</h2><p>Profesionální tiskárny mají rozlišení 0,1 mm vs. 0,2–0,4 mm u domácích.</p><h2>Filament</h2><p>Používáme prémiové PLA+ filamenty s konzistentním průměrem.</p><h2>Post-processing</h2><p>Každý kus ručně brousíme a kontrolujeme.</p>',
 'Tým Drobnostík','tipy',5,false,'published',NOW()-INTERVAL '45 days'),

('Průvodce péčí o 3D tisknuté předměty',
 'pece-o-3d-tisky',
 'Jak správně čistit, skladovat a chránit vaše pokéboly aby vydržely roky.',
 '<h2>Čištění</h2><p>Suché nebo mírně vlhké hadříky. Vyhněte se alkoholu.</p><h2>Skladování</h2><p>Mimo přímé sluneční záření, ideálně v krabičce nebo vitríně.</p><h2>Ochrana barvy</h2><p>Doporučujeme tenkou vrstvu matného laku — chrání povrch dlouhodobě.</p>',
 'Tým Drobnostík','tipy',4,false,'published',NOW()-INTERVAL '40 days'),

('Jak vybrat správnou velikost Pokébowlu',
 'jak-vybrat-velikost',
 'Small, Standard nebo Maxi? Pomůžeme vám vybrat ideální velikost.',
 '<h2>Small (průměr ~8 cm)</h2><p>Ideální jako přívěsek, drobná dekorace nebo dárek pro děti.</p><h2>Standard (průměr ~12 cm)</h2><p>Nejpopulárnější. Perfektní na stůl nebo polici.</p><h2>Maxi (průměr ~18 cm)</h2><p>Pro výrazný kus — centerpiece v obývacím pokoji.</p>',
 'Tým Drobnostík','tipy',3,false,'published',NOW()-INTERVAL '35 days'),

('Crystal Edition — průhledný pokéball je realitou',
 'crystal-edition-prehled',
 'Jak jsme vytvořili průhlednou crystal edici a proč je tak unikátní.',
 '<h2>Výzva průhlednosti</h2><p>Transparentní PLA filament je náročný na tisk — každá bublinaka vzduch je viditelná. Trvalo nám 3 měsíce najít správné parametry.</p><h2>Výsledek</h2><p>Crystal Edition vypadá jako kouzelný předmět. Světlo prochází skrz a vytváří krásné efekty.</p>',
 'Ondřej S.','za-kulisami',4,false,'published',NOW()-INTERVAL '30 days'),

('Top 10 způsobů jak darovat Pokéball',
 'top-10-darování-pokeball',
 'Kreativní nápady jak udělat z Pokébowlu nezapomenutelný dárek.',
 '<h2>1. S věnováním uvnitř</h2><p>Vložte dovnitř malý lístek s věnováním.</p><h2>2. Ve speciální krabičce</h2><p>Naše prémiové dárkové krabičky dělají z každého dárku zážitek.</p><h2>3. Jako součást setu</h2><p>Pokéball + figurka oblíbeného Pokémona = dokonalý set.</p>',
 'Jana K.','tipy',4,false,'published',NOW()-INTERVAL '25 days'),

('Galaxy Edition — když každý kus je originál',
 'galaxy-edition',
 'Multi-color filament s efektem hvězdné oblohy. Proč je každý Galaxy kus jiný?',
 '<h2>Multi-color filament</h2><p>Galaxy edice používá speciální filament, který střídá barvy v průběhu tisku. Výsledek je pro každý kus unikátní.</p><h2>Sběratelská hodnota</h2><p>Protože každý Galaxy Pokéball je jiný, mají tyto kusy skutečnou sběratelskou hodnotu.</p>',
 'Ondřej S.','novinky',3,false,'published',NOW()-INTERVAL '20 days'),

('Jak správně fotit Pokéboly pro Instagram',
 'foteni-pokebolu-instagram',
 'Tipy od profesionálního fotografa — jak vytěžit maximum z fotek vaší sbírky.',
 '<h2>Osvětlení</h2><p>Přirozené světlo od okna je nejlepší. Zlatá barva pokéballů krásně vynikne při ranním světle.</p><h2>Pozadí</h2><p>Tmavé pozadí pro světlé kusy a naopak. Čistota pozadí je klíčová.</p><h2>Kompozice</h2><p>Pravidlo třetin, různé úhly, detail textur.</p>',
 'Jana K.','tipy',5,false,'published',NOW()-INTERVAL '15 days'),

('Nová kolekce 2026 — co chystáme?',
 'nova-kolekce-2026',
 'Exkluzivní náhled na připravované edice a novinky pro rok 2026.',
 '<h2>Co chystáme</h2><p>V roce 2026 plánujeme rozšíření o 10 nových edic, personalizaci (gravírování) a nové typy miniatur.</p><h2>Komunita rozhoduje</h2><p>Na fóru probíhá hlasování o dalších edicích. Přijďte se zapojit!</p>',
 'Tým Drobnostík','novinky',3,true,'published',NOW()-INTERVAL '10 days'),

('Prism Edition — duhový pokéball je tady',
 'prism-edition',
 'Nejnovější a nejmagičtější edice Drobnostíku. Mění barvy jako živý duhový efekt.',
 '<h2>Jak to funguje</h2><p>Speciální Prism filament obsahuje mikroskopické krystaly, které lámou světlo. Výsledek je fascinující — barva se mění při každém pohybu.</p><h2>Limitovaná edice</h2><p>Kvůli náročnosti výroby tiskujeme maximálně 50 kusů týdně.</p>',
 'Ondřej S.','novinky',4,false,'published',NOW()-INTERVAL '5 days'),

('Příběh Drobnostíku — jak to všechno začalo',
 'pribeh-drobnostiku',
 'Od koníčku k e-shopu — jak vznikl Drobnostík a co nás pohání vpřed.',
 '<h2>Začátky</h2><p>Drobnostík začal jako školní projekt v roce 2024. Jedna tiskárna, jeden model, jeden zákazník — kamarád. Dnes máme desítky tiskáren a tisíce zákazníků.</p><h2>Motivace</h2><p>Věříme, že 3D tisk může být krásný a dostupný. Každý kus děláme s láskou.</p>',
 'Tým Drobnostík','za-kulisami',6,false,'published',NOW()-INTERVAL '45 days'),

('Srovnání filamentů — PLA vs PLA+ vs Silk PLA',
 'srovnani-filamentu',
 'Jaký filament je nejlepší pro Pokéboly? Porovnáváme vlastnosti, cenu a výsledek.',
 '<h2>PLA Standard</h2><p>Dostupný, snadno tisknutelný, biologicky rozložitelný. Dobrý pro základní produkty.</p><h2>PLA+</h2><p>Pevnější, odolnější vůči nárazům, lepší pro detailní tisky. Vyšší cena.</p><h2>Silk PLA</h2><p>Hedvábný lesk, metalický efekt. Náročnější na tisk ale výsledek je prémiový.</p>',
 'Ondřej S.','tipy',5,false,'published',NOW()-INTERVAL '38 days'),

('Komunita Drobnostíku — příběhy sběratelů',
 'komunita-sberatelu',
 'Příběhy našich zákazníků — jak sbírají, jak vystavují a co je na Pokébolech fascinuje.',
 '<h2>Tomáš z Prahy</h2><p>Tomáš má 47 Pokébolů — jednu od každé edice co jsme kdy vydali. Říká, že jsou jako umělecká díla.</p><h2>Jana z Brna</h2><p>Jana kupuje Pokéboly jako dárky — k narozeninám, Vánocům i jen tak. Říká, že jsou vždy hit.</p>',
 'Jana K.','komunita',4,false,'published',NOW()-INTERVAL '22 days');

-- ══════════════════════════════════════════════════════════════
-- BLOG COMMENTS — 30 komentářů
-- ══════════════════════════════════════════════════════════════
INSERT INTO blog_comments (post_id, author_name, author_email, text, is_approved, created_at) VALUES
(1,'Tomáš N.','tomas@ex.cz','Úžasný článek! Teď chápu proč tisk trvá tak dlouho. Díky za pohled do zákulisí.', true,NOW()-INTERVAL '58 days'),
(1,'Petra S.','petra@ex.cz','Zajímalo by mě jak dlouho trvá broušení. Je to ručně?', true,NOW()-INTERVAL '57 days'),
(1,'Tým Drobnostík','info@drobnostik.cz','@Petra — ano, každý kus brousíme ručně. Trvá to 15–30 minut podle edice.', true,NOW()-INTERVAL '57 days'),
(1,'Jakub H.','jakub@ex.cz','Skvělý obsah, díky! Teď chci navštívit dílnu osobně :)', true,NOW()-INTERVAL '55 days'),
(2,'Lucie M.','lucie@ex.cz','Floating shelf tip je geniální! Hned to zkusím doma.', true,NOW()-INTERVAL '53 days'),
(2,'Martin D.','martin@ex.cz','Mám 3 pokéboly na polici s LED osvětlením — vypadá to naprosto fantasticky!', true,NOW()-INTERVAL '52 days'),
(2,'Anna P.','anna@ex.cz','Kam bych koupila ty akrylové stojany? Jsou v eshopu?', true,NOW()-INTERVAL '51 days'),
(2,'Tým Drobnostík','info@drobnostik.cz','@Anna — ano, Display Standy máme v sekci Doplňky!', true,NOW()-INTERVAL '51 days'),
(3,'Ondřej K.','ondrej@ex.cz','Nevěřil jsem, že 50 kusů šlo do koše. Taková práce za dokonalostí je obdivuhodná.', true,NOW()-INTERVAL '48 days'),
(3,'Veronika B.','veronika@ex.cz','Shadow Edition je moje nejoblíbenější. Díky za příběh za ní!', true,NOW()-INTERVAL '47 days'),
(4,'Radek P.','radek@ex.cz','Přesně proto jsem rád že platím za profesionální tisk. Výsledek za to stojí.', true,NOW()-INTERVAL '43 days'),
(5,'Simona C.','simona@ex.cz','Tip s matným lakem je skvělý! Hned zkusím na svůj Crystal.', true,NOW()-INTERVAL '38 days'),
(6,'Filip K.','filip@ex.cz','Mám Standard a Maxi — obě velikosti mají své kouzlo. Nemůžu si vybrat oblíbenou.', true,NOW()-INTERVAL '33 days'),
(7,'Eva N.','eva@ex.cz','Crystal vypadá na fotkách úžasně. Musím si ho objednat!', true,NOW()-INTERVAL '28 days'),
(7,'Pavel Š.','pavel@ex.cz','Průhledný pokéball — to je originální nápad. Hned objednávám.', true,NOW()-INTERVAL '27 days'),
(8,'Jana K.','jana@ex.cz','Dárek v krabičce s věnováním — používám tento tip opakovaně. Vždy funguje!', true,NOW()-INTERVAL '23 days'),
(9,'Martin V.','martin@ex.cz','Galaxy edice je absolutní top. Každý kus je jiný — to je na tom to nejlepší.', true,NOW()-INTERVAL '18 days'),
(9,'Lucie C.','lucie2@ex.cz','Mám dva Galaxy a oba jsou jiné. Fascinující!', true,NOW()-INTERVAL '17 days'),
(10,'Ondřej M.','ondrej2@ex.cz','Tip s přirozeným světlem je klíčový. Moje fotky se zlepšily o 100%.', true,NOW()-INTERVAL '13 days'),
(10,'Petra S.','petra2@ex.cz','Díky za fototipy! Teď jsou moje instastories mnohem lepší.', true,NOW()-INTERVAL '12 days'),
(11,'Radek B.','radek2@ex.cz','Gravírování jménem by bylo super! Čekám na tu funkci.', true,NOW()-INTERVAL '8 days'),
(11,'Kamil S.','kamil@ex.cz','Nové edice vypadají úžasně. Prism musím mít!', true,NOW()-INTERVAL '7 days'),
(12,'Simona K.','simona2@ex.cz','Prism je magický! Kupuji okamžitě.', true,NOW()-INTERVAL '4 days'),
(12,'Tomáš B.','tomas2@ex.cz','Duhový efekt na videu je naprosto fantastický. Objednávám!', true,NOW()-INTERVAL '3 days'),
(13,'Lenka C.','lenka@ex.cz','Skvělý příběh! Drobnostík je inspirativní projekt.', true,NOW()-INTERVAL '43 days'),
(14,'Milan H.','milan@ex.cz','Silk PLA výsledky jsou nádherné. Vidím to na Pearl a Gold edicích.', true,NOW()-INTERVAL '36 days'),
(14,'Nora V.','nora@ex.cz','Díky za srovnání! Teď chápu proč jsou některé edice dražší.', true,NOW()-INTERVAL '35 days'),
(15,'Otakar S.','otakar@ex.cz','Tomášův příběh s 47 kousky mě inspiruje. Mám zatím 12 :)', true,NOW()-INTERVAL '20 days'),
(15,'Pavla J.','pavla@ex.cz','Jana má pravdu — Pokéboly jsou nejlepší dárky. Kupuji je opakovaně.', true,NOW()-INTERVAL '19 days'),
(11,'Quido V.','quido@ex.cz','Na personalizaci čekám s napětím! Bylo by super mít jméno gravírované.', true,NOW()-INTERVAL '6 days');

-- ══════════════════════════════════════════════════════════════
-- FORUM THREADS — 20 vláken
-- ══════════════════════════════════════════════════════════════
INSERT INTO forum_threads (title, body, category, author_name, views, is_pinned, is_locked, created_at) VALUES
('Vítejte v komunitě Drobnostík! 👋',        'Napište se kdo jste a kolik kusů máte ve sbírce. Já začínám s 3 Classic.', 'obecné',  'Tým Drobnostík', 1245, true,  false, NOW()-INTERVAL '90 days'),
('Jak nejlépe vystavit pokéboly na polici?',  'Mám 6 pokéballů a nevím jak je nejlépe vystavit. Padají. Tip?',              'sbírání', 'Marek J.',       342,  false, false, NOW()-INTERVAL '85 days'),
('Srovnání všech edic — mega přehled',        'Sbírám Drobnostík od začátku. Tady je moje srovnání všech edic co jsem koupil.','sbírání', 'Tomáš K.',       578,  true,  false, NOW()-INTERVAL '80 days'),
('Tip: matný lak prodlouží životnost',         'Zjistil jsem, že Rust-Oleum Matte prodlouží životnost povrchu. Doporučuju.', 'tipy',    'Pavel D.',       234,  false, false, NOW()-INTERVAL '75 days'),
('Hlasování: jakou edici chcete příště?',     'Hlasujte! Já chci crystal/průhlednou verzi. Co vy?',                         'obecné',  'Tým Drobnostík', 891,  true,  false, NOW()-INTERVAL '70 days'),
('Problémy s doručením — vyřešeno ✓',         'Zásilka přišla poškozená ale podpora rychle vyřídila náhradu. Palec nahoru.', 'podpora', 'Jana M.',        167,  false, true,  NOW()-INTERVAL '65 days'),
('Jaký filament sám tisknu pro stojany?',     'Tisknu si vlastní akrylové stojany. Jaký filament doporučujete?',             'tisk',    'Ondřej M.',      198,  false, false, NOW()-INTERVAL '60 days'),
('Gold Edition vs Crystal — co koupit?',      'Mám budget na jedno. Gold Edition nebo Crystal? Pomozte mi rozhodnout!',       'sbírání', 'Lucie H.',       334,  false, false, NOW()-INTERVAL '55 days'),
('Fotky ze sbírek — sdílejte!',               'Sdílejte fotky vašich sbírek! Mám teď 15 kusů a vypadá to epicky.',           'sbírání', 'Filip R.',       567,  false, false, NOW()-INTERVAL '50 days'),
('Galaxy edice — každý kus jiný!',            'Koupil jsem dva Galaxy a jsou naprosto jiné barvy. Je to normální?',           'obecné',  'Martin V.',      289,  false, false, NOW()-INTERVAL '45 days'),
('Dárkové tipy pro vánoce',                   'Jaký Pokéball byste doporučili jako vánoční dárek pro přítelkyni?',            'tipy',    'Karel N.',       445,  false, false, NOW()-INTERVAL '40 days'),
('Shadow Edition — kde ji sehnat?',           'Shadow Edition je stále vyprodaná. Kdy bude naskladněna?',                     'podpora', 'Eva B.',         312,  false, false, NOW()-INTERVAL '35 days'),
('LED osvětlení pod pokéball — jak?',         'Chci LED pásky pod police. Jakou barvu světla nejlépe vynikne Pokéball?',      'tipy',    'Radek K.',       234,  false, false, NOW()-INTERVAL '30 days'),
('Miniatura Gengar — dojem po měsíci',        'Mám Gengara měsíc. Drží skvěle, barva se nemění. Doporučuju!',                'sbírání', 'Simona P.',      178,  false, false, NOW()-INTERVAL '25 days'),
('Prism edice — stojí za to?',                'Prism je nejdražší edice. Stojí za tu cenu? Uvažuji o koupi.',                 'sbírání', 'Jakub T.',       445,  false, false, NOW()-INTERVAL '20 days'),
('Osobní odběr v Praze — jak to funguje?',    'Zájím se o osobní odběr. Kde přesně v Praze? Jak se domluvit?',               'podpora', 'Petra V.',       156,  false, false, NOW()-INTERVAL '15 days'),
('Sběratel s 50+ kusy — AMA',                 'Sbírám Drobnostík od začátku. Mám 52 kusů. Ptejte se na cokoliv!',            'sbírání', 'Velký sběratel', 678,  false, false, NOW()-INTERVAL '10 days'),
('Nová kolekce 2026 — co víme?',              'Někdo ví co chystají v nové kolekci 2026? Viděl jsem náznaky na Instagramu.', 'novinky', 'Nadšenec 3D',   234,  false, false, NOW()-INTERVAL '7 days'),
('Tip na kombinaci barev pro polici',          'Černá + bílá + šedá Classic vedle sebe vypadá fantasticky. Zkuste to!',       'tipy',    'Designér JK',    189,  false, false, NOW()-INTERVAL '4 days'),
('Komunita dosáhla 500 členů! 🎉',            'Jsme 500! Díky všem za podporu. Jako poděkování — kód KOMUNITA10 pro 10% slevu.','obecné','Tým Drobnostík', 892, true,  false, NOW()-INTERVAL '1 day');

-- ══════════════════════════════════════════════════════════════
-- FORUM REPLIES — 60 odpovědí
-- ══════════════════════════════════════════════════════════════
INSERT INTO forum_replies (thread_id, author_name, body, created_at) VALUES
(1,'Jana K.','Vítám! Mám 8 kusů — Classic, Shadow, Gold, Pearl a 4 miniatury. Nejlepší komunita!', NOW()-INTERVAL '89 days'),
(1,'Ondřej M.','Zdravím! Začínám teprve — mám 2 Classic. Ale plánuji rozšiřovat sbírku rychle.', NOW()-INTERVAL '88 days'),
(1,'Tým Drobnostík','Vítáme všechny nové členy! Sledujte fórum pro exkluzivní slevové kódy pro členy komunity.', NOW()-INTERVAL '87 days'),
(2,'Jana K.','Doporučuji akrylové stojany! Máme je v eshopu — Display Stand. Drží perfektně.', NOW()-INTERVAL '84 days'),
(2,'Ondřej M.','Velcro pásek na polici — přilepíš kousek na polici a pokéball na něj. Nikam nejede.', NOW()-INTERVAL '83 days'),
(2,'Tým Drobnostík','Naše Display Standy jsou navrženy přesně pro tento účel. Při koupi 3+ kusů 10% sleva! 😊', NOW()-INTERVAL '82 days'),
(3,'Lucie H.','Skvělý přehled! Souhlasím — Gold Edition je nejprémiověji vypadající. Crystal je ale nejtajemnější.', NOW()-INTERVAL '78 days'),
(3,'Martin V.','Já přidám: Prism je na světle absolutně magický. Lepší vidět živě než na fotkách.', NOW()-INTERVAL '77 days'),
(3,'Karel N.','Díky za přehled! Pomohlo mi rozhodnout se pro Shadow Edition.', NOW()-INTERVAL '76 days'),
(4,'Simona P.','Molotow Varnish funguje také skvěle! Zkoušela jsem na Pearl Edition.', NOW()-INTERVAL '73 days'),
(4,'Petra V.','Funguje i na lesklou Gold Edition? Nechci přijít o ten lesk.', NOW()-INTERVAL '72 days'),
(4,'Pavel D.','@Petra — pro lesklé edice doporučuju lesklý lak, ne matný. Zachová efekt.', NOW()-INTERVAL '71 days'),
(5,'Lucie H.','Hlasuju pro crystal! Průhledný pokéball by byl naprosto unikátní.', NOW()-INTERVAL '68 days'),
(5,'Martin V.','Já chci zlatou metalickou limitku — jako 25. výročí Pokémon.', NOW()-INTERVAL '67 days'),
(5,'Filip R.','Neonová edice! Glow in the dark pro noční sbírku. 😄', NOW()-INTERVAL '66 days'),
(5,'Tým Drobnostík','Výsledky hlasování vyhodnocujeme! Crystal Edition je ve výrobě. 😉', NOW()-INTERVAL '65 days'),
(7,'Tomáš K.','Pro stojany zkus PETG — je průhlednější než PLA a pevnější.', NOW()-INTERVAL '58 days'),
(7,'Ondřej M.','PETG je dobrý nápad! Já tisknu stojany z PLA+ — lehce mléčné ale pevné.', NOW()-INTERVAL '57 days'),
(8,'Jana K.','Gold Edition! Vypadá luxusněji a hodí se pro více příležitostí.', NOW()-INTERVAL '53 days'),
(8,'Radek K.','Crystal je originálnější a unikátnější. Gold mají všichni, Crystal málokdo.', NOW()-INTERVAL '52 days'),
(8,'Lucie H.','Koupila jsem oba — žádné lítosti! 😄', NOW()-INTERVAL '51 days'),
(9,'Tomáš K.','Moje sbírka: https://imgur.com/placeholder — 23 kusů na floating shelfech s LED.', NOW()-INTERVAL '48 days'),
(9,'Jana K.','Krásná sbírka! Jak jsi dělal osvětlení? RGB nebo bílá?', NOW()-INTERVAL '47 days'),
(9,'Martin V.','Warm white 3000K je nejlepší pro zlaté edice. Studená bílá pro Crystal a Pearl.', NOW()-INTERVAL '46 days'),
(10,'Tým Drobnostík','@Martin — ano, je to naprosto normální! Galaxy filament přirozeně mění barvy v každém tisku.', NOW()-INTERVAL '43 days'),
(10,'Karel N.','To je právě ta unikátnost Galaxy edice! Dva Galaxy nikdy nejsou stejné.', NOW()-INTERVAL '42 days'),
(11,'Jana K.','Pro přítelkyni: Pearl nebo Sakura — jemné a elegantní barvy.', NOW()-INTERVAL '38 days'),
(11,'Lucie H.','Gold Edition jako dárek je vždy hit. Vypadá luxusně a drahě (i když není).', NOW()-INTERVAL '37 days'),
(11,'Ondřej M.','Crystal pro někoho kdo má rád originalitu. Pearl pro eleganci.', NOW()-INTERVAL '36 days'),
(12,'Tým Drobnostík','@Eva — Shadow Edition bude naskladněna do 7 pracovních dní. Přihlaste se k notifikaci!', NOW()-INTERVAL '33 days'),
(12,'Eva B.','Díky! Notifikaci jsem aktivovala. Čekám s napětím.', NOW()-INTERVAL '32 days'),
(13,'Tomáš K.','Warm white 2700-3000K pro zlaté edice. RGB pro efektní podívané.', NOW()-INTERVAL '28 days'),
(13,'Martin V.','Amber LED je nádherný pro Crystal Edition — vypadá jako svítící drahokam!', NOW()-INTERVAL '27 days'),
(14,'Jana K.','Gengar je skvělý! Stojí u mě rok a stále vypadá perfektně.', NOW()-INTERVAL '23 days'),
(15,'Lucie H.','Prism stojí za každou korunu! Mám ho týden a stále mě fascinuje.', NOW()-INTERVAL '18 days'),
(15,'Martin V.','Je to nejdražší ale nejunikátnější kus mé sbírky. Nekompromituj — Prism kup!', NOW()-INTERVAL '17 days'),
(15,'Jakub T.','Díky za tipy! Objednávám Prism. 😊', NOW()-INTERVAL '16 days'),
(16,'Tým Drobnostík','Osobní odběr: Dlouhá 15, Praha 1. Po-Pá 10-17, nutná předchozí domluva emailem.', NOW()-INTERVAL '13 days'),
(16,'Petra V.','Perfektní! Děkuji. Napíši email pro domluvení termínu.', NOW()-INTERVAL '12 days'),
(17,'Jana K.','Jak uchováváš takový počet kusů? Máš vitrínu nebo police?', NOW()-INTERVAL '9 days'),
(17,'Velký sběratel','Mám dvě IKEA BILLY police s průhledným krytem a RGB osvětlením. Vypadá to fantasticky.', NOW()-INTERVAL '8 days'),
(17,'Tomáš K.','52 kusů a stále sbíráš? Jaký je tvůj oblíbený?', NOW()-INTERVAL '7 days'),
(17,'Velký sběratel','Galaxy Edition — každý kus je originál. A Prism samozřejmě.', NOW()-INTERVAL '6 days'),
(18,'Tomáš K.','Na Instagramu Drobnostíku vidím náznaky metalické fialové edice. Fialová Pearl?', NOW()-INTERVAL '5 days'),
(18,'Jana K.','Tmavě fialová by byla nádherná! Amethyst Edition — kdo hlasuje?', NOW()-INTERVAL '4 days'),
(18,'Martin V.','Já hlasuju! A bronzová v novém designu by také byla skvělá.', NOW()-INTERVAL '3 days'),
(19,'Ondřej M.','Kombinace černá+bílá+zlatá (Classic, Pearl, Gold) je ještě lepší!', NOW()-INTERVAL '3 days'),
(19,'Jana K.','Zkusím! Mám všechny tři velikosti Classic — v té kombinaci vypadá skvěle.', NOW()-INTERVAL '2 days'),
(20,'Tomáš K.','Gratulujeme! Skvělá komunita. Kód použit. 😊', NOW()-INTERVAL '20 hours'),
(20,'Jana K.','500 členů! Tak za dalších 500 bude kód na 20%? 😄', NOW()-INTERVAL '18 hours'),
(20,'Tým Drobnostík','@Jana — přesně tak plánujeme! 🎉', NOW()-INTERVAL '16 hours'),
(1,'Nový člen','Zdravím! Právě jsem se přidal. Mám zatím 1 Classic — začátek sbírky.', NOW()-INTERVAL '12 hours'),
(5,'Nadšenec','Hlasuju pro Amethyst Edition! Fialová barva by byla nádherná.', NOW()-INTERVAL '8 hours'),
(17,'Petra V.','52 kusů je sen! Pracuji na tom — zatím mám 9.', NOW()-INTERVAL '4 hours'),
(20,'Simona K.','Komunita je skvělá! Ráda jsem součástí.', NOW()-INTERVAL '2 hours'),
(9,'Nový sběratel','Krásné sbírky! Inspiruje mě to rozšiřovat svou.', NOW()-INTERVAL '1 hour'),
(3,'Martin B.','Díky za přehled edic! Pomohlo mi vybrat Shadow jako první velký kus.', NOW()-INTERVAL '30 minutes'),
(15,'Filip K.','Prism jsem objednal podle doporučení. Nemůžu se dočkat!', NOW()-INTERVAL '10 minutes');

-- ══════════════════════════════════════════════════════════════
-- COUPONS — 15 kódů
-- ══════════════════════════════════════════════════════════════
INSERT INTO coupons (code, discount_type, discount_value, min_order, max_uses, used_count, is_active, expires_at, created_at) VALUES
('VITEJ10',      'percent', 10, 0,    1000, 234,  true,  NOW()+INTERVAL '365 days', NOW()-INTERVAL '180 days'),
('KOMUNITA10',   'percent', 10, 0,    500,  47,   true,  NOW()+INTERVAL '30 days',  NOW()-INTERVAL '1 day'),
('POKEFAN15',    'percent', 15, 500,  200,  89,   true,  NOW()+INTERVAL '60 days',  NOW()-INTERVAL '90 days'),
('SLEVA50',      'fixed',   50, 300,  100,  67,   true,  NOW()+INTERVAL '90 days',  NOW()-INTERVAL '60 days'),
('GOLD20',       'percent', 20, 999,  50,   23,   true,  NOW()+INTERVAL '45 days',  NOW()-INTERVAL '45 days'),
('MINISET10',    'percent', 10, 399,  150,  44,   true,  NOW()+INTERVAL '60 days',  NOW()-INTERVAL '30 days'),
('BIRTHDAY15',   'percent', 15, 0,    300,  128,  true,  NOW()+INTERVAL '365 days', NOW()-INTERVAL '120 days'),
('SUMMER2026',   'percent', 12, 299,  400,  0,    true,  NOW()+INTERVAL '90 days',  NOW()-INTERVAL '5 days'),
('NEWSLETTER5',  'fixed',   50, 199,  500,  312,  true,  NOW()+INTERVAL '180 days', NOW()-INTERVAL '150 days'),
('VIP25',        'percent', 25, 1999, 20,   8,    true,  NOW()+INTERVAL '30 days',  NOW()-INTERVAL '15 days'),
('SKOLA15',      'percent', 15, 0,    100,  34,   true,  NOW()+INTERVAL '180 days', NOW()-INTERVAL '60 days'),
('DOPRAVAZDARMA','fixed',   99, 500,  200,  156,  true,  NOW()+INTERVAL '90 days',  NOW()-INTERVAL '45 days'),
('PRISM10',      'percent', 10, 449,  100,  18,   true,  NOW()+INTERVAL '60 days',  NOW()-INTERVAL '5 days'),
('EXPIRED2025',  'percent', 20, 0,    100,  100,  false, NOW()-INTERVAL '1 day',    NOW()-INTERVAL '365 days'),
('TESTONLY',     'percent', 50, 0,    5,    3,    false, NOW()+INTERVAL '30 days',  NOW()-INTERVAL '10 days');

-- ══════════════════════════════════════════════════════════════
-- SUPPORT TICKETS — 20 tiketů
-- ══════════════════════════════════════════════════════════════
INSERT INTO support_tickets (ticket_number, name, email, order_number, category, subject, message, status, priority, created_at) VALUES
('TKT-000001','Tomáš Novák',        'tomas@ex.cz',    'ORD-1001','order',   'Dotaz na stav objednávky',       'Dobrý den, kdy bude moje objednávka odeslána? Díky.',                                'resolved',    'normal',NOW()-INTERVAL '88 days'),
('TKT-000002','Petra Svobodová',    'petra@ex.cz',    'ORD-1002','return',  'Přišlo špatné zboží',            'Objednala jsem Gold Edition ale dostala Classic. Prosím o výměnu.',                  'resolved',    'high',  NOW()-INTERVAL '86 days'),
('TKT-000003','Jakub Horák',        'jakub@ex.cz',    NULL,      'general', 'Zakázkový tisk ve fialové',      'Je možné objednat pokéball ve fialové barvě? Nenašel jsem ji v nabídce.',            'resolved',    'normal',NOW()-INTERVAL '83 days'),
('TKT-000004','Lucie Marková',      'lucie@ex.cz',    'ORD-1004','order',   'Osobní odběr — termín',          'Kdy mohu přijít na osobní odběr? Dostupná každý den 9–17.',                          'resolved',    'normal',NOW()-INTERVAL '80 days'),
('TKT-000005','Martin Dvořák',      'martin@ex.cz',   'ORD-1005','shipping','Zásilka se nezobrazuje v systému','Mám číslo zásilky ale na webu dopravce nic nevidím. Prosím o pomoc.',               'resolved',    'normal',NOW()-INTERVAL '78 days'),
('TKT-000006','Anna Procházková',   'anna@ex.cz',     NULL,      'product', 'Dotaz na péči o Crystal edici',  'Jak mám čistit průhledný Crystal pokéball? Bojím se ho poškrábat.',                   'resolved',    'low',   NOW()-INTERVAL '75 days'),
('TKT-000007','Ondřej Kučera',      'ondrej@ex.cz',   'ORD-1007','return',  'Vrácení — změna mysli',          'Chtěl bych vrátit Pearl Edition. Líbí se mi ale mám příliš mnoho pokéballů.',         'resolved',    'normal',NOW()-INTERVAL '72 days'),
('TKT-000008','Veronika Bílá',      'veronika@ex.cz', NULL,      'general', 'Faktura pro firmu',              'Potřebuji fakturu na firmu s IČO. Jak zadat IČO při objednávce?',                    'resolved',    'normal',NOW()-INTERVAL '70 days'),
('TKT-000009','Radek Pokorný',      'radek@ex.cz',    'ORD-1009','shipping','Zásilka poškozena při doručení', 'Pokéball přišel poškozený. Přikládám foto. Žádám o náhradu.',                        'resolved',    'high',  NOW()-INTERVAL '68 days'),
('TKT-000010','Simona Černá',       'simona@ex.cz',   NULL,      'product', 'Dostupnost Shadow Edition',      'Kdy bude Shadow Edition opět naskladněna? Čekám 2 týdny.',                           'resolved',    'normal',NOW()-INTERVAL '65 days'),
('TKT-000011','Filip Kratochvíl',   'filip@ex.cz',    'ORD-1011','payment', 'Platba kartou selhala',          'Platba kartou se 3× odmítla. Zkusil jsem různé karty. Co mám dělat?',                'resolved',    'high',  NOW()-INTERVAL '62 days'),
('TKT-000012','Eva Nováková',       'eva@ex.cz',      NULL,      'general', 'Bulk objednávka pro školu',      'Potřebuji 30 kusů Classic jako ceny do soutěže. Nabízíte slevu pro školy?',           'resolved',    'normal',NOW()-INTERVAL '50 days'),
('TKT-000013','Pavel Šimánek',      'pavel@ex.cz',    'ORD-1013','order',   'Změna adresy doručení',          'Přestěhoval jsem se. Lze změnit adresu objednávky ORD-1013?',                        'resolved',    'normal',NOW()-INTERVAL '38 days'),
('TKT-000014','Michaela Horáčková', 'michaela@ex.cz', NULL,      'product', 'Dotaz na Prism Edition',         'Je Prism Edition skutečně duhová nebo jen na fotkách? Stojí za 449 Kč?',             'in_progress', 'normal',NOW()-INTERVAL '14 days'),
('TKT-000015','Stanislav Holub',    'stanislav@ex.cz','ORD-1015','shipping','Express doručení — zpoždění',    'Objednal Express dopravu na zítra ale zásilka stále nepřišla.',                      'in_progress', 'high',  NOW()-INTERVAL '10 days'),
('TKT-000016','Renata Dostálová',   'renata@ex.cz',   NULL,      'general', 'Affiliate program — přihlášení', 'Chci se stát affiliate partnerem. Jak se přihlásím a jaká je provize?',               'in_progress', 'low',   NOW()-INTERVAL '7 days'),
('TKT-000017','Kamil Stránský',     'kamil@ex.cz',    'ORD-1017','return',  'Reklamace — prasklina na tisku', 'Pokéball má prasklinu na spoji. Nekupoval jsem, přišlo tak. Foto přikládám.',         'open',        'high',  NOW()-INTERVAL '4 days'),
('TKT-000018','Lenka Chaloupková',  'lenka@ex.cz',    NULL,      'product', 'Velikost Maxi — skutečné rozměry','Jaké jsou přesné rozměry Maxi Pokébowlu? Chci vědět jestli se vejde na polici.',    'open',        'normal',NOW()-INTERVAL '2 days'),
('TKT-000019','Milan Hřebíček',     'milan@ex.cz',    'ORD-1019','order',   'Nedostal jsem potvrzovací email','Provedl jsem objednávku ORD-1019 ale email s potvrzením nepřišel.',                 'open',        'normal',NOW()-INTERVAL '1 day'),
('TKT-000020','Nora Valentová',     'nora@ex.cz',     NULL,      'general', 'Dárkové balení — co obsahuje?', 'Co přesně obsahuje dárková krabička? Je uvnitř výplň? Jde vložit vlastní vzkaz?',   'open',        'low',   NOW()-INTERVAL '3 hours');

-- ══════════════════════════════════════════════════════════════
-- AFFILIATES — 10 partnerů
-- ══════════════════════════════════════════════════════════════
INSERT INTO affiliates (name, email, referral_code, commission_rate, total_earned, total_clicks, total_sales, status, created_at) VALUES
('Jan Blogger',          'jan.blogger@ex.cz',     'JANBLOG',   12, 8940,  4521, 67,  'active',   NOW()-INTERVAL '180 days'),
('Petra Youtuber',       'petra.yt@ex.cz',         'PETRAYT',   15, 21670, 12341,142, 'active',   NOW()-INTERVAL '160 days'),
('Ondřej Instagram',     'ondrej.ig@ex.cz',        'ONDREJIG',  10, 3450,  2345, 28,  'active',   NOW()-INTERVAL '140 days'),
('TechReview CZ',        'admin@techreview.cz',    'TECHCZ',    12, 5670,  3234, 44,  'active',   NOW()-INTERVAL '120 days'),
('Pokemon Fans CZ',      'info@pokemonfans.cz',    'POKEFANS',  15, 34210, 18923,256, 'active',   NOW()-INTERVAL '100 days'),
('Sbíráme CZ',           'sbíráme@ex.cz',          'SBIRAME',   10, 1230,  876,  9,   'active',   NOW()-INTERVAL '80 days'),
('Herní Setup CZ',       'setup@hernicr.cz',       'HERNISETUP',12, 7890,  4123, 58,  'active',   NOW()-INTERVAL '60 days'),
('3D Tisk Blog',         '3dtisk@ex.cz',           'TISKBLOG',  10, 2340,  1654, 18,  'active',   NOW()-INTERVAL '45 days'),
('Dárkuj.cz',            'info@dárkuj.cz',         'DARKUJCZ',  12, 4560,  2987, 34,  'active',   NOW()-INTERVAL '30 days'),
('Nový Partner',         'novy@ex.cz',             'NOVYPART',  10, 0,     23,   0,   'active',   NOW()-INTERVAL '7 days');

-- ══════════════════════════════════════════════════════════════
-- EMAIL CAMPAIGNS — 10 kampaní
-- ══════════════════════════════════════════════════════════════
INSERT INTO email_campaigns (name, subject, body, status, sent, opens, clicks, sent_at, created_at) VALUES
('Uvítací kampaň',         'Vítejte v Drobnostíku! 🎉',              'Děkujeme za přihlášení. Váš 10% kód: VITEJ10',          'sent', 1240, 687, 234, NOW()-INTERVAL '180 days', NOW()-INTERVAL '185 days'),
('Shadow Edition Launch',  'Nová limitovaná edice je tady! 🖤',       'Shadow Edition — pouze 50 kusů. Objednejte nyní.',       'sent', 1180, 534, 189, NOW()-INTERVAL '90 days',  NOW()-INTERVAL '95 days'),
('Jarní slevy 2026',       'Jarní výprodej — až 20% sleva! 🌸',       'Vybrané produkty ve slevě do konce měsíce.',            'sent', 1310, 721, 312, NOW()-INTERVAL '60 days',  NOW()-INTERVAL '62 days'),
('Crystal Edition Launch', 'Průhledný pokéball je realitou! 💎',      'Crystal Edition — nejtajemnější kus naší kolekce.',      'sent', 1350, 756, 298, NOW()-INTERVAL '30 days',  NOW()-INTERVAL '32 days'),
('Newsletter duben',       'Novinky z dílny Drobnostík 📦',           'Nové produkty, tipy na péči a zákulisí výroby.',         'sent', 1390, 634, 187, NOW()-INTERVAL '20 days',  NOW()-INTERVAL '22 days'),
('Prism Edition Launch',   'Duhový pokéball mění barvy! 🌈',          'Prism Edition — omezená výroba 50 kusů/týden.',          'sent', 1420, 834, 412, NOW()-INTERVAL '10 days',  NOW()-INTERVAL '12 days'),
('Komunita 500 členů',     'Slavíme 500 členů komunity! 🎉',          'Jako poděkování: kód KOMUNITA10 pro 10% slevu.',         'sent', 1450, 912, 445, NOW()-INTERVAL '2 days',   NOW()-INTERVAL '3 days'),
('Newsletter květen',      'Máj, lásky čas — a pokéballů čas! 💝',   'Doporučujeme: Pearl a Sakura jako dárek.',               'draft',0,    0,   0,   NULL,                      NOW()-INTERVAL '1 day'),
('Galaxy Edition Restock', 'Galaxy Edition je opět skladem! 🌌',      'Omezené množství Galaxy kusů — každý je originál.',      'draft',0,    0,   0,   NULL,                      NOW()),
('Letní kolekce 2026',     'Léto přichází s novou kolekcí! ☀️',       'Nové letní edice — teaser v článku na blogu.',           'draft',0,    0,   0,   NULL,                      NOW());

-- ══════════════════════════════════════════════════════════════
-- CONTACT MESSAGES — 20 zpráv
-- ══════════════════════════════════════════════════════════════
INSERT INTO contact_messages (name, email, phone, subject, message, created_at) VALUES
('Tomáš Novák',       'tomas@ex.cz',    '+420 601 100 001','order',   'Dotaz k objednávce ORD-1001 — kdy bude odeslána?',                          NOW()-INTERVAL '88 days'),
('Jana Škodová',      'jana@ex.cz',     NULL,             'general', 'Dobrý den, prodáváte i stojany pro více pokéballů najednou?',                NOW()-INTERVAL '80 days'),
('Petr Malý',         'petr@ex.cz',     '+420 601 200 001','custom',  'Zájem o zakázkový tisk 20 kusů pro firemní akci. Jaká je cena?',            NOW()-INTERVAL '70 days'),
('Marie Červená',     'marie@ex.cz',    NULL,             'general', 'Ahoj, máte v plánu edici inspirovanou Digimonem?',                          NOW()-INTERVAL '60 days'),
('Pavel Bílý',        'pavel@ex.cz',    '+420 601 300 001','return',  'Chtěl bych vrátit Vintage Edition. Je stále v záruční době.',               NOW()-INTERVAL '55 days'),
('Lucie Veselá',      'lucie@ex.cz',    NULL,             'general', 'Jak dlouho trvá výroba Gold Edition? Potřebuji do 14 dní jako dárek.',       NOW()-INTERVAL '50 days'),
('Ondřej Malík',      'ondrej@ex.cz',   '+420 601 400 001','order',   'Zapomněl jsem zadat kód VITEJ10. Lze ho uplatnit zpětně?',                  NOW()-INTERVAL '45 days'),
('Simona Bílková',    'simona@ex.cz',   NULL,             'custom',  'Zájem o gravírování jménem na pokéball jako dárek k narozeninám.',           NOW()-INTERVAL '40 days'),
('Radek Novotný',     'radek@ex.cz',    '+420 601 500 001','general', 'Prodáváte náhradní stojany pro starší edice? Můj se zlomil.',               NOW()-INTERVAL '35 days'),
('Kateřina Horáková', 'katerina@ex.cz', NULL,             'general', 'Dobrý den, je možné koupit Pokébowl jako prázdnou misku na drobnosti?',     NOW()-INTERVAL '30 days'),
('Martin Šimek',      'martin@ex.cz',   '+420 601 600 001','order',   'Objednávka ORD-1032 — potřebuji změnit způsob dopravy na express.',         NOW()-INTERVAL '25 days'),
('Veronika Pokorná',  'veronika@ex.cz', NULL,             'general', 'Nabízíte možnost osobního odběru i v Brně nebo jen Praha?',                  NOW()-INTERVAL '20 days'),
('Filip Horák',       'filip@ex.cz',    '+420 601 700 001','return',  'Obdržel jsem Ember Edition s malou bublinkou v tisku. Reklamace.',           NOW()-INTERVAL '15 days'),
('Eva Kratochvílová', 'eva@ex.cz',      NULL,             'custom',  'Dotaz na B2B spolupráci — jsme herní kavárna a chceme 50 kusů dekorací.',    NOW()-INTERVAL '12 days'),
('Jakub Sedlák',      'jakub@ex.cz',    '+420 601 800 001','general', 'Kdy vyjde Amethyst Edition? Hlasoval jsem pro ni na fóru.',                  NOW()-INTERVAL '10 days'),
('Petra Vlčková',     'petra@ex.cz',    NULL,             'general', 'Jak mám postupovat pokud chci darovat Pokéball anonymně — bez jména odesílatele?', NOW()-INTERVAL '7 days'),
('Norbert Ryba',      'norbert@ex.cz',  '+420 601 900 001','order',   'Neobdržel jsem fakturu k objednávce ORD-1047. Prosím o zaslání.',            NOW()-INTERVAL '4 days'),
('Olga Tesařová',     'olga@ex.cz',     NULL,             'general', 'Prodáváte dárkové poukazy v hodnotě 1000 Kč? Nenašla jsem v eshopu.',        NOW()-INTERVAL '2 days'),
('Patrik Kašpar',     'patrik@ex.cz',   '+420 601 010 001','custom',  'Zájem o sponzorství Pokemon turnaje — 30 kusů Classic jako ceny.',           NOW()-INTERVAL '1 day'),
('Radmila Holíková',  'radmila@ex.cz',  NULL,             'general', 'Dobrý den, koupit Crystal Edition ale stojí teď méně na jiném webu. Je to fake?', NOW()-INTERVAL '2 hours');

-- ══════════════════════════════════════════════════════════════
-- SUPPORT RATINGS — 50 hodnocení
-- ══════════════════════════════════════════════════════════════
INSERT INTO support_ratings (score, created_at) VALUES
(5,NOW()-INTERVAL '88 days'),(5,NOW()-INTERVAL '86 days'),(4,NOW()-INTERVAL '83 days'),
(5,NOW()-INTERVAL '80 days'),(5,NOW()-INTERVAL '78 days'),(4,NOW()-INTERVAL '75 days'),
(5,NOW()-INTERVAL '72 days'),(5,NOW()-INTERVAL '70 days'),(3,NOW()-INTERVAL '68 days'),
(5,NOW()-INTERVAL '65 days'),(4,NOW()-INTERVAL '62 days'),(5,NOW()-INTERVAL '50 days'),
(5,NOW()-INTERVAL '38 days'),(5,NOW()-INTERVAL '35 days'),(4,NOW()-INTERVAL '32 days'),
(5,NOW()-INTERVAL '30 days'),(5,NOW()-INTERVAL '28 days'),(4,NOW()-INTERVAL '25 days'),
(3,NOW()-INTERVAL '23 days'),(5,NOW()-INTERVAL '20 days'),(5,NOW()-INTERVAL '18 days'),
(4,NOW()-INTERVAL '15 days'),(5,NOW()-INTERVAL '13 days'),(5,NOW()-INTERVAL '11 days'),
(4,NOW()-INTERVAL '9 days'), (5,NOW()-INTERVAL '7 days'), (5,NOW()-INTERVAL '6 days'),
(4,NOW()-INTERVAL '5 days'), (5,NOW()-INTERVAL '4 days'), (5,NOW()-INTERVAL '3 days'),
(4,NOW()-INTERVAL '2 days'), (5,NOW()-INTERVAL '2 days'), (5,NOW()-INTERVAL '1 day'),
(4,NOW()-INTERVAL '22 hours'),(5,NOW()-INTERVAL '20 hours'),(5,NOW()-INTERVAL '18 hours'),
(5,NOW()-INTERVAL '16 hours'),(4,NOW()-INTERVAL '14 hours'),(5,NOW()-INTERVAL '12 hours'),
(5,NOW()-INTERVAL '10 hours'),(5,NOW()-INTERVAL '8 hours'), (4,NOW()-INTERVAL '6 hours'),
(5,NOW()-INTERVAL '5 hours'), (5,NOW()-INTERVAL '4 hours'), (3,NOW()-INTERVAL '3 hours'),
(5,NOW()-INTERVAL '2 hours'), (5,NOW()-INTERVAL '90 minutes'),(4,NOW()-INTERVAL '60 minutes'),
(5,NOW()-INTERVAL '30 minutes'),(5,NOW()-INTERVAL '10 minutes');

-- ══════════════════════════════════════════════════════════════
-- GRANT (zajistí přístup anon role)
-- ══════════════════════════════════════════════════════════════
GRANT USAGE ON SCHEMA public TO anon;
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT ALL ON ALL TABLES IN SCHEMA public TO anon;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO anon;

-- ══════════════════════════════════════════════════════════════
-- SHRNUTÍ
-- ══════════════════════════════════════════════════════════════
SELECT
  'products'              AS tabulka, COUNT(*) AS pocet FROM products UNION ALL
SELECT 'orders',                      COUNT(*) FROM orders UNION ALL
SELECT 'order_items',                 COUNT(*) FROM order_items UNION ALL
SELECT 'reviews',                     COUNT(*) FROM reviews UNION ALL
SELECT 'faq',                         COUNT(*) FROM faq UNION ALL
SELECT 'newsletter_subscribers',      COUNT(*) FROM newsletter_subscribers UNION ALL
SELECT 'blog_posts',                  COUNT(*) FROM blog_posts UNION ALL
SELECT 'blog_comments',               COUNT(*) FROM blog_comments UNION ALL
SELECT 'forum_threads',               COUNT(*) FROM forum_threads UNION ALL
SELECT 'forum_replies',               COUNT(*) FROM forum_replies UNION ALL
SELECT 'coupons',                     COUNT(*) FROM coupons UNION ALL
SELECT 'support_tickets',             COUNT(*) FROM support_tickets UNION ALL
SELECT 'affiliates',                  COUNT(*) FROM affiliates UNION ALL
SELECT 'email_campaigns',             COUNT(*) FROM email_campaigns UNION ALL
SELECT 'contact_messages',            COUNT(*) FROM contact_messages UNION ALL
SELECT 'support_ratings',             COUNT(*) FROM support_ratings UNION ALL
SELECT 'settings',                    COUNT(*) FROM settings
ORDER BY 1;

-- ══════════════════════════════════════════════════════════════
-- ORDER ITEMS — doplněk pro objednávky ORD-1011 až ORD-1050
-- ══════════════════════════════════════════════════════════════
INSERT INTO order_items (order_id, product_id, product_name, color, size, quantity, unit_price, total_price)
SELECT o.id, 1,  'Pokébowl Classic',       'black', 'Standard', 1, 299, 299 FROM orders o WHERE o.order_number='ORD-1011';
INSERT INTO order_items (order_id, product_id, product_name, color, size, quantity, unit_price, total_price)
SELECT o.id, 21, 'Mini Pikachu',           'white', 'Small',    1, 89,  89  FROM orders o WHERE o.order_number='ORD-1011';
INSERT INTO order_items (order_id, product_id, product_name, color, size, quantity, unit_price, total_price)
SELECT o.id, 22, 'Mini Eevee',             'white', 'Small',    1, 89,  89  FROM orders o WHERE o.order_number='ORD-1011';
INSERT INTO order_items (order_id, product_id, product_name, color, size, quantity, unit_price, total_price)
SELECT o.id, 21, 'Mini Pikachu',           'white', 'Small',    1, 89,  89  FROM orders o WHERE o.order_number='ORD-1012';
INSERT INTO order_items (order_id, product_id, product_name, color, size, quantity, unit_price, total_price)
SELECT o.id, 3,  'Pokébowl Shadow',        'black', 'Standard', 1, 349, 349 FROM orders o WHERE o.order_number='ORD-1013';
INSERT INTO order_items (order_id, product_id, product_name, color, size, quantity, unit_price, total_price)
SELECT o.id, 36, 'Display Stand S',        'black', 'Standard', 1, 79,  79  FROM orders o WHERE o.order_number='ORD-1013';
INSERT INTO order_items (order_id, product_id, product_name, color, size, quantity, unit_price, total_price)
SELECT o.id, 2,  'Pokébowl Gold Edition',  'black', 'Standard', 2, 499, 998 FROM orders o WHERE o.order_number='ORD-1014';
INSERT INTO order_items (order_id, product_id, product_name, color, size, quantity, unit_price, total_price)
SELECT o.id, 4,  'Pokébowl Pearl',         'white', 'Standard', 1, 319, 319 FROM orders o WHERE o.order_number='ORD-1015';
INSERT INTO order_items (order_id, product_id, product_name, color, size, quantity, unit_price, total_price)
SELECT o.id, 1,  'Pokébowl Classic',       'gray',  'Standard', 1, 299, 299 FROM orders o WHERE o.order_number='ORD-1016';
INSERT INTO order_items (order_id, product_id, product_name, color, size, quantity, unit_price, total_price)
SELECT o.id, 21, 'Mini Pikachu',           'white', 'Small',    1, 89,  89  FROM orders o WHERE o.order_number='ORD-1016';
INSERT INTO order_items (order_id, product_id, product_name, color, size, quantity, unit_price, total_price)
SELECT o.id, 1,  'Pokébowl Classic',       'black', 'Standard', 1, 299, 299 FROM orders o WHERE o.order_number='ORD-1017';
INSERT INTO order_items (order_id, product_id, product_name, color, size, quantity, unit_price, total_price)
SELECT o.id, 3,  'Pokébowl Shadow',        'black', 'Standard', 2, 349, 698 FROM orders o WHERE o.order_number='ORD-1018';
INSERT INTO order_items (order_id, product_id, product_name, color, size, quantity, unit_price, total_price)
SELECT o.id, 2,  'Pokébowl Gold Edition',  'black', 'Maxi',     1, 699, 699 FROM orders o WHERE o.order_number='ORD-1019';
INSERT INTO order_items (order_id, product_id, product_name, color, size, quantity, unit_price, total_price)
SELECT o.id, 1,  'Pokébowl Classic',       'white', 'Standard', 1, 299, 299 FROM orders o WHERE o.order_number='ORD-1020';
INSERT INTO order_items (order_id, product_id, product_name, color, size, quantity, unit_price, total_price)
SELECT o.id, 5,  'Pokébowl Retro',         'black', 'Standard', 1, 329, 329 FROM orders o WHERE o.order_number='ORD-1021';
INSERT INTO order_items (order_id, product_id, product_name, color, size, quantity, unit_price, total_price)
SELECT o.id, 21, 'Mini Pikachu',           'white', 'Standard', 1, 129, 129 FROM orders o WHERE o.order_number='ORD-1021';
INSERT INTO order_items (order_id, product_id, product_name, color, size, quantity, unit_price, total_price)
SELECT o.id, 2,  'Pokébowl Gold Edition',  'black', 'Standard', 2, 499, 998 FROM orders o WHERE o.order_number='ORD-1022';
INSERT INTO order_items (order_id, product_id, product_name, color, size, quantity, unit_price, total_price)
SELECT o.id, 4,  'Pokébowl Pearl',         'white', 'Standard', 1, 319, 319 FROM orders o WHERE o.order_number='ORD-1023';
INSERT INTO order_items (order_id, product_id, product_name, color, size, quantity, unit_price, total_price)
SELECT o.id, 43, 'Starter Set Classic',    'black', 'Standard', 1, 749, 749 FROM orders o WHERE o.order_number='ORD-1024';
INSERT INTO order_items (order_id, product_id, product_name, color, size, quantity, unit_price, total_price)
SELECT o.id, 12, 'Pokébowl Crystal',       'white', 'Standard', 1, 449, 449 FROM orders o WHERE o.order_number='ORD-1025';
INSERT INTO order_items (order_id, product_id, product_name, color, size, quantity, unit_price, total_price)
SELECT o.id, 37, 'Display Stand L',        'black', 'Standard', 1, 99,  99  FROM orders o WHERE o.order_number='ORD-1025';
INSERT INTO order_items (order_id, product_id, product_name, color, size, quantity, unit_price, total_price)
SELECT o.id, 1,  'Pokébowl Classic',       'black', 'Standard', 1, 299, 299 FROM orders o WHERE o.order_number='ORD-1026';
INSERT INTO order_items (order_id, product_id, product_name, color, size, quantity, unit_price, total_price)
SELECT o.id, 22, 'Mini Eevee',             'white', 'Small',    1, 89,  89  FROM orders o WHERE o.order_number='ORD-1026';
INSERT INTO order_items (order_id, product_id, product_name, color, size, quantity, unit_price, total_price)
SELECT o.id, 1,  'Pokébowl Classic',       'gray',  'Standard', 1, 299, 299 FROM orders o WHERE o.order_number='ORD-1027';
INSERT INTO order_items (order_id, product_id, product_name, color, size, quantity, unit_price, total_price)
SELECT o.id, 2,  'Pokébowl Gold Edition',  'black', 'Standard', 1, 499, 499 FROM orders o WHERE o.order_number='ORD-1028';
INSERT INTO order_items (order_id, product_id, product_name, color, size, quantity, unit_price, total_price)
SELECT o.id, 3,  'Pokébowl Shadow',        'black', 'Small',    1, 249, 249 FROM orders o WHERE o.order_number='ORD-1028';
INSERT INTO order_items (order_id, product_id, product_name, color, size, quantity, unit_price, total_price)
SELECT o.id, 4,  'Pokébowl Pearl',         'white', 'Standard', 1, 319, 319 FROM orders o WHERE o.order_number='ORD-1029';
INSERT INTO order_items (order_id, product_id, product_name, color, size, quantity, unit_price, total_price)
SELECT o.id, 6,  'Pokébowl Midnight',      'black', 'Standard', 1, 369, 369 FROM orders o WHERE o.order_number='ORD-1030';
INSERT INTO order_items (order_id, product_id, product_name, color, size, quantity, unit_price, total_price)
SELECT o.id, 36, 'Display Stand S',        'black', 'Standard', 1, 79,  79  FROM orders o WHERE o.order_number='ORD-1030';
INSERT INTO order_items (order_id, product_id, product_name, color, size, quantity, unit_price, total_price)
SELECT o.id, 1,  'Pokébowl Classic',       'black', 'Standard', 1, 299, 299 FROM orders o WHERE o.order_number='ORD-1031';
INSERT INTO order_items (order_id, product_id, product_name, color, size, quantity, unit_price, total_price)
SELECT o.id, 3,  'Pokébowl Shadow',        'black', 'Standard', 1, 349, 349 FROM orders o WHERE o.order_number='ORD-1032';
INSERT INTO order_items (order_id, product_id, product_name, color, size, quantity, unit_price, total_price)
SELECT o.id, 44, 'Collector Set',          'black', 'Standard', 1,1999,1999 FROM orders o WHERE o.order_number='ORD-1033';
INSERT INTO order_items (order_id, product_id, product_name, color, size, quantity, unit_price, total_price)
SELECT o.id, 4,  'Pokébowl Pearl',         'white', 'Standard', 1, 319, 319 FROM orders o WHERE o.order_number='ORD-1034';
INSERT INTO order_items (order_id, product_id, product_name, color, size, quantity, unit_price, total_price)
SELECT o.id, 1,  'Pokébowl Classic',       'white', 'Standard', 1, 299, 299 FROM orders o WHERE o.order_number='ORD-1035';
INSERT INTO order_items (order_id, product_id, product_name, color, size, quantity, unit_price, total_price)
SELECT o.id, 43, 'Starter Set Classic',    'black', 'Standard', 1, 749, 749 FROM orders o WHERE o.order_number='ORD-1036';
INSERT INTO order_items (order_id, product_id, product_name, color, size, quantity, unit_price, total_price)
SELECT o.id, 1,  'Pokébowl Classic',       'black', 'Standard', 1, 299, 299 FROM orders o WHERE o.order_number='ORD-1037';
INSERT INTO order_items (order_id, product_id, product_name, color, size, quantity, unit_price, total_price)
SELECT o.id, 6,  'Pokébowl Midnight',      'black', 'Standard', 1, 369, 369 FROM orders o WHERE o.order_number='ORD-1038';
INSERT INTO order_items (order_id, product_id, product_name, color, size, quantity, unit_price, total_price)
SELECT o.id, 39, 'Dárková krabička S',     'black', 'Standard', 1, 49,  49  FROM orders o WHERE o.order_number='ORD-1038';
INSERT INTO order_items (order_id, product_id, product_name, color, size, quantity, unit_price, total_price)
SELECT o.id, 3,  'Pokébowl Shadow',        'black', 'Standard', 1, 349, 349 FROM orders o WHERE o.order_number='ORD-1039';
INSERT INTO order_items (order_id, product_id, product_name, color, size, quantity, unit_price, total_price)
SELECT o.id, 21, 'Mini Pikachu',           'white', 'Standard', 1, 129, 129 FROM orders o WHERE o.order_number='ORD-1039';
INSERT INTO order_items (order_id, product_id, product_name, color, size, quantity, unit_price, total_price)
SELECT o.id, 2,  'Pokébowl Gold Edition',  'black', 'Standard', 1, 499, 499 FROM orders o WHERE o.order_number='ORD-1040';
INSERT INTO order_items (order_id, product_id, product_name, color, size, quantity, unit_price, total_price)
SELECT o.id, 5,  'Pokébowl Retro',         'black', 'Standard', 1, 329, 329 FROM orders o WHERE o.order_number='ORD-1040';
INSERT INTO order_items (order_id, product_id, product_name, color, size, quantity, unit_price, total_price)
SELECT o.id, 44, 'Collector Set',          'black', 'Standard', 1,1999,1999 FROM orders o WHERE o.order_number='ORD-1041';
INSERT INTO order_items (order_id, product_id, product_name, color, size, quantity, unit_price, total_price)
SELECT o.id, 4,  'Pokébowl Pearl',         'white', 'Standard', 1, 319, 319 FROM orders o WHERE o.order_number='ORD-1042';
INSERT INTO order_items (order_id, product_id, product_name, color, size, quantity, unit_price, total_price)
SELECT o.id, 1,  'Pokébowl Classic',       'black', 'Standard', 1, 299, 299 FROM orders o WHERE o.order_number='ORD-1043';
INSERT INTO order_items (order_id, product_id, product_name, color, size, quantity, unit_price, total_price)
SELECT o.id, 3,  'Pokébowl Shadow',        'black', 'Standard', 1, 349, 349 FROM orders o WHERE o.order_number='ORD-1044';
INSERT INTO order_items (order_id, product_id, product_name, color, size, quantity, unit_price, total_price)
SELECT o.id, 21, 'Mini Pikachu',           'white', 'Standard', 1, 129, 129 FROM orders o WHERE o.order_number='ORD-1044';
INSERT INTO order_items (order_id, product_id, product_name, color, size, quantity, unit_price, total_price)
SELECT o.id, 6,  'Pokébowl Midnight',      'black', 'Standard', 1, 369, 369 FROM orders o WHERE o.order_number='ORD-1045';
INSERT INTO order_items (order_id, product_id, product_name, color, size, quantity, unit_price, total_price)
SELECT o.id, 39, 'Dárková krabička S',     'black', 'Standard', 1, 49,  49  FROM orders o WHERE o.order_number='ORD-1045';
INSERT INTO order_items (order_id, product_id, product_name, color, size, quantity, unit_price, total_price)
SELECT o.id, 1,  'Pokébowl Classic',       'gray',  'Standard', 1, 299, 299 FROM orders o WHERE o.order_number='ORD-1046';
INSERT INTO order_items (order_id, product_id, product_name, color, size, quantity, unit_price, total_price)
SELECT o.id, 22, 'Mini Eevee',             'white', 'Small',    1, 89,  89  FROM orders o WHERE o.order_number='ORD-1046';
INSERT INTO order_items (order_id, product_id, product_name, color, size, quantity, unit_price, total_price)
SELECT o.id, 4,  'Pokébowl Pearl',         'white', 'Small',    1, 219, 219 FROM orders o WHERE o.order_number='ORD-1047';
INSERT INTO order_items (order_id, product_id, product_name, color, size, quantity, unit_price, total_price)
SELECT o.id, 12, 'Pokébowl Crystal',       'white', 'Standard', 1, 449, 449 FROM orders o WHERE o.order_number='ORD-1048';
INSERT INTO order_items (order_id, product_id, product_name, color, size, quantity, unit_price, total_price)
SELECT o.id, 39, 'Dárková krabička S',     'black', 'Standard', 1, 49,  49  FROM orders o WHERE o.order_number='ORD-1048';
INSERT INTO order_items (order_id, product_id, product_name, color, size, quantity, unit_price, total_price)
SELECT o.id, 44, 'Collector Set',          'black', 'Standard', 1,1999,1999 FROM orders o WHERE o.order_number='ORD-1049';
INSERT INTO order_items (order_id, product_id, product_name, color, size, quantity, unit_price, total_price)
SELECT o.id, 3,  'Pokébowl Shadow',        'black', 'Standard', 1, 349, 349 FROM orders o WHERE o.order_number='ORD-1050';
INSERT INTO order_items (order_id, product_id, product_name, color, size, quantity, unit_price, total_price)
SELECT o.id, 22, 'Mini Eevee',             'white', 'Standard', 1, 129, 129 FROM orders o WHERE o.order_number='ORD-1050';

-- ══════════════════════════════════════════════════════════════
-- INVENTORY LOG — 30 záznamů pohybů skladu
-- ══════════════════════════════════════════════════════════════
INSERT INTO inventory_log (product_id, change, reason, created_at) VALUES
(1,  100, 'Naskladnění — nová série',          NOW()-INTERVAL '180 days'),
(2,  50,  'Naskladnění — Gold Edition série 1', NOW()-INTERVAL '175 days'),
(3,  80,  'Naskladnění — Shadow Edition',       NOW()-INTERVAL '170 days'),
(4,  60,  'Naskladnění — Pearl Edition',        NOW()-INTERVAL '165 days'),
(5,  50,  'Naskladnění — Retro Edition',        NOW()-INTERVAL '160 days'),
(1,  -13, 'Prodej — objednávky leden',          NOW()-INTERVAL '150 days'),
(2,  -26, 'Prodej — objednávky leden',          NOW()-INTERVAL '150 days'),
(3,  -49, 'Prodej — objednávky leden',          NOW()-INTERVAL '150 days'),
(6,  30,  'Naskladnění — Midnight Edition',     NOW()-INTERVAL '140 days'),
(7,  60,  'Naskladnění — Sakura Edition',       NOW()-INTERVAL '135 days'),
(8,  80,  'Naskladnění — Arctic Edition',       NOW()-INTERVAL '130 days'),
(1,  50,  'Naskladnění — Classic doplnění',     NOW()-INTERVAL '120 days'),
(1,  -50, 'Prodej — objednávky únor–březen',   NOW()-INTERVAL '110 days'),
(2,  -24, 'Prodej — objednávky únor',           NOW()-INTERVAL '110 days'),
(9,  20,  'Naskladnění — Ember Edition',        NOW()-INTERVAL '100 days'),
(10, 50,  'Naskladnění — Vintage Edition',      NOW()-INTERVAL '95 days'),
(11, 20,  'Naskladnění — Neon Edition',         NOW()-INTERVAL '90 days'),
(12, 20,  'Naskladnění — Crystal Edition',      NOW()-INTERVAL '80 days'),
(4,  -17, 'Prodej — objednávky duben',          NOW()-INTERVAL '70 days'),
(3,  50,  'Naskladnění — Shadow Edition série 2',NOW()-INTERVAL '60 days'),
(13, 50,  'Naskladnění — Ocean Edition',        NOW()-INTERVAL '55 days'),
(3,  -19, 'Prodej — objednávky květen',         NOW()-INTERVAL '50 days'),
(16, 20,  'Naskladnění — Galaxy Edition',       NOW()-INTERVAL '45 days'),
(20, 10,  'Naskladnění — Prism Edition',        NOW()-INTERVAL '30 days'),
(2,  -2,  'Reklamace — vrácení zákazníka',      NOW()-INTERVAL '25 days'),
(1,  -21, 'Prodej — objednávky červen',         NOW()-INTERVAL '20 days'),
(36, 200, 'Naskladnění — Display Standy',       NOW()-INTERVAL '15 days'),
(39, 300, 'Naskladnění — Dárkové krabičky',    NOW()-INTERVAL '10 days'),
(20, 5,   'Naskladnění — Prism doplnění',       NOW()-INTERVAL '5 days'),
(1,  -7,  'Prodej — objednávky tento týden',    NOW()-INTERVAL '2 days');

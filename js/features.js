// js/features.js — Drobnostík v3 — Extended Features

// ═══════════════════════════════════════════════════════
// COOKIE CONSENT (GDPR)
// ═══════════════════════════════════════════════════════
function initCookieConsent() {
  if (localStorage.getItem('cookie-consent') || localStorage.getItem('cookies_accepted')) return;
  const banner = document.createElement('div');
  banner.id = 'cookie-banner';
  banner.setAttribute('role', 'dialog');
  banner.setAttribute('aria-label', 'Souhlas s cookies');
  banner.style.cssText = `
    position:fixed;bottom:0;left:0;right:0;z-index:9998;
    background:#111;border-top:1px solid rgba(200,169,106,0.2);
    padding:16px 24px;display:flex;align-items:center;
    justify-content:space-between;gap:16px;flex-wrap:wrap;
    animation:slideInToast 0.4s ease;`;
  banner.innerHTML = `
    <div style="flex:1;min-width:260px;">
      <div style="font-weight:600;font-size:14px;margin-bottom:4px;">🍪 Používáme cookies</div>
      <div style="font-size:13px;color:#777;">
        Používáme cookies pro zlepšení funkčnosti webu a analýzu návštěvnosti.
        <a href="/privacy" onclick="event.preventDefault();goTo('/privacy')" style="color:#c8a96a;text-decoration:underline;">Více informací</a>
      </div>
    </div>
    <div style="display:flex;gap:8px;flex-wrap:wrap;">
      <button onclick="acceptCookies('necessary')" style="padding:9px 16px;background:#333;color:#ccc;border:1px solid #444;border-radius:6px;cursor:pointer;font-size:13px;">Jen nutné</button>
      <button onclick="acceptCookies('all')" style="padding:9px 20px;background:linear-gradient(135deg,#c8a96a,#b8995a);color:#000;border:none;border-radius:6px;cursor:pointer;font-weight:600;font-size:13px;">Přijmout vše</button>
    </div>`;
  document.body.appendChild(banner);
}

function acceptCookies(level) {
  // Save with unified key
  localStorage.setItem('cookie-consent', level || 'essential');
  localStorage.setItem('cookies_accepted', level || 'essential'); // backwards compat
  // Remove ANY cookie banner on the page
  document.querySelectorAll('#cookie-banner, [data-cookie-banner]').forEach(function(el) {
    el.style.transform = 'translateY(100%)';
    el.style.transition = 'transform 0.4s ease';
    setTimeout(function() { el.parentNode && el.parentNode.removeChild(el); }, 450);
  });
  if (level === 'all') showToast('✓ Cookies přijaty');
}
window.acceptCookies = acceptCookies;

// ═══════════════════════════════════════════════════════
// SCROLL TO TOP BUTTON
// ═══════════════════════════════════════════════════════
function initScrollToTop() {
  const btn = document.createElement('button');
  btn.id = 'scroll-top-btn';
  btn.innerHTML = '↑';
  btn.setAttribute('aria-label', 'Přejít na začátek stránky');
  btn.title = 'Zpět nahoru';
  btn.style.cssText = `
    position:fixed;bottom:24px;right:24px;z-index:999;
    width:44px;height:44px;border-radius:50%;
    background:linear-gradient(135deg,#c8a96a,#b8995a);
    color:#000;border:none;font-size:18px;font-weight:700;
    cursor:pointer;opacity:0;transition:all 0.3s;
    box-shadow:0 4px 16px rgba(200,169,106,0.3);
    display:flex;align-items:center;justify-content:center;
    pointer-events:none;`;
  btn.onclick = () => window.scrollTo({ top: 0, behavior: 'smooth' });
  document.body.appendChild(btn);

  let ticking = false;
  window.addEventListener('scroll', () => {
    if (!ticking) {
      requestAnimationFrame(() => {
        const show = window.scrollY > 400;
        btn.style.opacity = show ? '1' : '0';
        btn.style.pointerEvents = show ? 'auto' : 'none';
        btn.style.transform = show ? 'translateY(0)' : 'translateY(10px)';
        ticking = false;
      });
      ticking = true;
    }
  });
}

// ═══════════════════════════════════════════════════════
// PAGE LOAD PROGRESS BAR
// ═══════════════════════════════════════════════════════
function initProgressBar() {
  const bar = document.createElement('div');
  bar.id = 'page-progress';
  bar.style.cssText = `
    position:fixed;top:0;left:0;height:2px;width:0%;z-index:9999;
    background:linear-gradient(90deg,#c8a96a,#e0c090);
    transition:width 0.2s ease,opacity 0.3s;
    box-shadow:0 0 8px rgba(200,169,106,0.5);
    pointer-events:none;`;
  document.body.appendChild(bar);
}

function progressStart() {
  const bar = document.getElementById('page-progress');
  if (!bar) return;
  bar.style.width = '30%';
  bar.style.opacity = '1';
  setTimeout(() => { bar.style.width = '70%'; }, 100);
}

function progressDone() {
  const bar = document.getElementById('page-progress');
  if (!bar) return;
  bar.style.width = '100%';
  setTimeout(() => { bar.style.opacity = '0'; bar.style.width = '0%'; }, 300);
}

window.progressStart = progressStart;
window.progressDone = progressDone;

// ═══════════════════════════════════════════════════════
// RECENTLY VIEWED PRODUCTS
// ═══════════════════════════════════════════════════════
const RecentlyViewed = {
  KEY: 'recently_viewed',
  MAX: 6,
  add(item) {
    const obj = (typeof item === 'object' && item !== null) ? item : { id: parseInt(item) };
    if (!obj.id) return;
    let list = this.get();
    list = [obj, ...list.filter(p => p && p.id !== obj.id)].slice(0, this.MAX);
    localStorage.setItem(this.KEY, JSON.stringify(list));
  },
  get() {
    try {
      const raw = JSON.parse(localStorage.getItem(this.KEY) || '[]');
      return raw.map(item => typeof item === 'object' ? item : { id: parseInt(item) }).filter(p => p && p.id);
    } catch { return []; }
  },
  async render(containerId) {
    const el = document.getElementById(containerId);
    if (!el) return;
    const items = this.get();
    if (!items.length) { el.style.display = 'none'; return; }
    try {
      const sb = await getSupabase();
      const ids = items.map(p => p.id);
      const { data } = await sb.from('products').select('*').in('id', ids);
      if (!data?.length) { el.style.display = 'none'; return; }
      const sorted = ids.map(id => data.find(p => p.id === id)).filter(Boolean);
      el.innerHTML = `
        <h2 style="font-size:20px;font-weight:700;margin-bottom:16px;">👁️ Nedávno prohlédnuté</h2>
        <div style="display:grid;grid-template-columns:repeat(auto-fill,minmax(200px,1fr));gap:14px;">
          ${sorted.map(p => renderProductCard(p)).join('')}
        </div>`;
    } catch(e) { el.style.display = 'none'; }
  }
};
window.RecentlyViewed = RecentlyViewed;

// ═══════════════════════════════════════════════════════
// BREADCRUMB NAVIGATION
// ═══════════════════════════════════════════════════════
function renderBreadcrumb(items) {
  // items: [{label, href}]
  return `
    <nav aria-label="Navigace drobečků" style="padding:12px 0;margin-bottom:8px;">
      <ol style="display:flex;flex-wrap:wrap;gap:6px;list-style:none;padding:0;margin:0;font-size:13px;color:#555;" itemscope itemtype="https://schema.org/BreadcrumbList">
        ${items.map((item, i) => `
          <li itemprop="itemListElement" itemscope itemtype="https://schema.org/ListItem" style="display:flex;align-items:center;gap:6px;">
            ${i < items.length - 1
              ? `<a href="${item.href}" onclick="event.preventDefault();goTo('${item.href}')" itemprop="item" style="color:#777;text-decoration:none;transition:color 0.2s;" onmouseover="this.style.color='#c8a96a'" onmouseout="this.style.color='#777'"><span itemprop="name">${escapeHtml(item.label)}</span></a><span aria-hidden="true" style="color:#333;">›</span>`
              : `<span itemprop="name" style="color:#ccc;" aria-current="page">${escapeHtml(item.label)}</span>`
            }
            <meta itemprop="position" content="${i+1}">
          </li>`).join('')}
      </ol>
    </nav>`;
}
window.renderBreadcrumb = renderBreadcrumb;

// ═══════════════════════════════════════════════════════
// MINI CART FLYOUT
// ═══════════════════════════════════════════════════════
function initMiniCart() {
  const trigger = document.querySelector('.btn-cart');
  if (!trigger) return;

  const flyout = document.createElement('div');
  flyout.id = 'mini-cart';
  flyout.setAttribute('role', 'dialog');
  flyout.setAttribute('aria-label', 'Mini košík');
  flyout.style.cssText = `
    position:fixed;top:70px;right:16px;width:320px;max-height:480px;
    background:#111;border:1px solid rgba(200,169,106,0.2);
    border-radius:10px;z-index:1000;overflow:hidden;
    box-shadow:0 16px 40px rgba(0,0,0,0.5);
    transform:translateY(-10px) scale(0.97);opacity:0;
    transition:all 0.25s cubic-bezier(0.4,0,0.2,1);
    pointer-events:none;`;
  document.body.appendChild(flyout);

  let timeout;
  function showMiniCart() {
    clearTimeout(timeout);
    updateMiniCart();
    flyout.style.opacity = '1';
    flyout.style.transform = 'translateY(0) scale(1)';
    flyout.style.pointerEvents = 'auto';
  }
  function hideMiniCart() {
    timeout = setTimeout(() => {
      flyout.style.opacity = '0';
      flyout.style.transform = 'translateY(-10px) scale(0.97)';
      flyout.style.pointerEvents = 'none';
    }, 200);
  }
  trigger.addEventListener('mouseenter', showMiniCart);
  trigger.addEventListener('mouseleave', hideMiniCart);
  flyout.addEventListener('mouseenter', () => clearTimeout(timeout));
  flyout.addEventListener('mouseleave', hideMiniCart);
}

function updateMiniCart() {
  const flyout = document.getElementById('mini-cart');
  if (!flyout) return;
  const items = Cart.getItems();
  const total = Cart.getTotal();
  flyout.innerHTML = `
    <div style="padding:16px;border-bottom:1px solid #1e1e1e;display:flex;justify-content:space-between;align-items:center;">
      <span style="font-weight:700;font-size:14px;">Košík (${items.length})</span>
      <button onclick="goTo('/cart');document.getElementById('mini-cart').style.opacity='0';document.getElementById('mini-cart').style.pointerEvents='none'" style="font-size:12px;background:none;border:none;color:#c8a96a;cursor:pointer;">Zobrazit vše →</button>
    </div>
    <div style="overflow-y:auto;max-height:280px;padding:8px 0;">
      ${items.length ? items.map(item => `
        <div style="display:grid;grid-template-columns:48px 1fr auto;gap:10px;padding:10px 16px;align-items:center;border-bottom:1px solid #1a1a1a;">
          <img src="${item.image || '/images/products/pokebowl-' + (item.color||'black') + '-front.jpg'}" style="width:48px;height:48px;border-radius:6px;object-fit:cover;" alt="${escapeHtml(item.name)}" onerror="this.src='/images/products/pokebowl-black-front.jpg'">
          <div>
            <div style="font-size:13px;font-weight:600;">${escapeHtml(item.name)}</div>
            <div style="font-size:11px;color:#666;">${item.color} · ${item.size} · ${item.quantity}×</div>
          </div>
          <div style="font-size:13px;font-weight:700;color:#c8a96a;white-space:nowrap;">${formatPrice(item.price * item.quantity)} Kč</div>
        </div>`).join('') : `<div style="text-align:center;padding:32px;color:#666;font-size:14px;">Košík je prázdný</div>`}
    </div>
    ${items.length ? `
    <div style="padding:14px 16px;border-top:1px solid #1e1e1e;background:#0d0d0d;">
      <div style="display:flex;justify-content:space-between;margin-bottom:10px;font-size:14px;">
        <span style="color:#999;">Celkem:</span>
        <span style="font-weight:700;color:#c8a96a;">${formatPrice(total)} Kč</span>
      </div>
      <button onclick="goTo('/checkout')" class="btn-primary" style="width:100%;padding:11px;font-size:14px;">Pokladna →</button>
    </div>` : ''}`;
}
window.updateMiniCart = updateMiniCart;
window.initMiniCart = initMiniCart;

// ═══════════════════════════════════════════════════════
// PRODUCT SHARE
// ═══════════════════════════════════════════════════════
async function shareProduct(name, url) {
  const shareUrl = url || window.location.href;
  if (navigator.share) {
    try {
      await navigator.share({ title: name + ' — Drobnostík', text: 'Podívejte se na tento produkt!', url: shareUrl });
      return;
    } catch(e) {}
  }
  // Fallback: copy to clipboard
  try {
    await navigator.clipboard.writeText(shareUrl);
    showToast('✓ Odkaz zkopírován do schránky');
  } catch(e) {
    showToast('URL: ' + shareUrl);
  }
}
window.shareProduct = shareProduct;

// ═══════════════════════════════════════════════════════
// TOAST WITH UNDO ACTION
// ═══════════════════════════════════════════════════════
function showToastWithUndo(msg, undoFn, duration = 5000) {
  const existing = document.getElementById('undo-toast');
  if (existing) existing.remove();

  const el = document.createElement('div');
  el.id = 'undo-toast';
  el.style.cssText = `position:fixed;bottom:24px;right:24px;background:linear-gradient(135deg,#1a1a1a,#222);
    color:white;padding:14px 20px;border-radius:8px;z-index:10001;font-size:14px;
    border-left:3px solid #c8a96a;box-shadow:0 8px 24px rgba(0,0,0,0.4);
    display:flex;align-items:center;gap:16px;animation:slideInToast 0.3s ease;max-width:340px;`;
  el.innerHTML = `<span>${escapeHtml(msg)}</span><button onclick="undoAction()" style="background:rgba(200,169,106,0.2);border:1px solid #c8a96a;color:#c8a96a;padding:5px 12px;border-radius:4px;cursor:pointer;font-size:12px;font-weight:600;white-space:nowrap;">↩ Zpět</button>`;
  document.body.appendChild(el);

  window._undoFn = undoFn;
  window._undoTimeout = setTimeout(() => { el.remove(); window._undoFn = null; }, duration);
}
function undoAction() {
  if (window._undoFn) { window._undoFn(); window._undoFn = null; }
  clearTimeout(window._undoTimeout);
  document.getElementById('undo-toast')?.remove();
}
window.showToastWithUndo = showToastWithUndo;
window.undoAction = undoAction;

// ═══════════════════════════════════════════════════════
// BROWSER NOTIFICATION FOR ADMIN
// ═══════════════════════════════════════════════════════
async function requestNotificationPermission() {
  if (!('Notification' in window)) return false;
  if (Notification.permission === 'granted') return true;
  const perm = await Notification.requestPermission();
  return perm === 'granted';
}

function sendAdminNotification(title, body, icon) {
  if (Notification.permission !== 'granted') return;
  const n = new Notification(title, {
    body, icon: icon || '/images/logo.png',
    badge: '/images/logo.png', tag: 'drobnostik-admin'
  });
  n.onclick = () => { window.focus(); n.close(); };
  setTimeout(() => n.close(), 8000);
}
window.requestNotificationPermission = requestNotificationPermission;
window.sendAdminNotification = sendAdminNotification;

// ═══════════════════════════════════════════════════════
// VOICE SEARCH (Web Speech API)
// ═══════════════════════════════════════════════════════
function startVoiceSearch(inputId) {
  if (!('webkitSpeechRecognition' in window || 'SpeechRecognition' in window)) {
    showToast('Hlasové vyhledávání není podporováno v tomto prohlížeči');
    return;
  }
  const SR = window.SpeechRecognition || window.webkitSpeechRecognition;
  const recognition = new SR();
  recognition.lang = 'cs-CZ';
  recognition.interimResults = false;
  recognition.maxAlternatives = 1;
  recognition.onstart = () => showToast('🎤 Poslouchám...');
  recognition.onresult = (e) => {
    const transcript = e.results[0][0].transcript;
    const input = document.getElementById(inputId);
    if (input) { input.value = transcript; input.dispatchEvent(new Event('input')); }
    showToast(`🔍 Hledám: "${transcript}"`);
  };
  recognition.onerror = () => showToast('Chyba hlasového vyhledávání');
  recognition.start();
}
window.startVoiceSearch = startVoiceSearch;

// ═══════════════════════════════════════════════════════
// BROWSER TAB BADGE (unread/cart count)
// ═══════════════════════════════════════════════════════
function updateTabTitle() {
  const cartCount = Cart ? Cart.getCount() : 0;
  const base = 'Drobnostík';
  document.title = cartCount > 0 ? `(${cartCount}) ${base}` : base;
}
window.updateTabTitle = updateTabTitle;

// ═══════════════════════════════════════════════════════
// AUDIO NOTIFICATION FOR NEW ORDER (Admin)
// ═══════════════════════════════════════════════════════
function playOrderSound() {
  try {
    const ctx = new (window.AudioContext || window.webkitAudioContext)();
    const osc = ctx.createOscillator();
    const gain = ctx.createGain();
    osc.connect(gain);
    gain.connect(ctx.destination);
    osc.frequency.setValueAtTime(880, ctx.currentTime);
    osc.frequency.setValueAtTime(1100, ctx.currentTime + 0.1);
    osc.frequency.setValueAtTime(880, ctx.currentTime + 0.2);
    gain.gain.setValueAtTime(0.3, ctx.currentTime);
    gain.gain.exponentialRampToValueAtTime(0.001, ctx.currentTime + 0.4);
    osc.start(ctx.currentTime);
    osc.stop(ctx.currentTime + 0.4);
  } catch(e) {}
}
window.playOrderSound = playOrderSound;

// ═══════════════════════════════════════════════════════
// STORE CREDIT SYSTEM
// ═══════════════════════════════════════════════════════
const StoreCredit = {
  KEY: 'store_credit',
  get() { return parseFloat(localStorage.getItem(this.KEY) || '0'); },
  add(amount) {
    const current = this.get();
    localStorage.setItem(this.KEY, (current + amount).toFixed(2));
    this.updateDisplay();
  },
  use(amount) {
    const current = this.get();
    if (current < amount) return false;
    localStorage.setItem(this.KEY, Math.max(0, current - amount).toFixed(2));
    this.updateDisplay();
    return true;
  },
  updateDisplay() {
    const els = document.querySelectorAll('.store-credit-display');
    els.forEach(el => { el.textContent = this.get() + ' Kč'; });
  }
};
window.StoreCredit = StoreCredit;

// ═══════════════════════════════════════════════════════
// GIFT CARD GENERATOR
// ═══════════════════════════════════════════════════════
function generateGiftCard(amount) {
  const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
  let code = 'GIFT-';
  for (let i = 0; i < 12; i++) {
    if (i === 4 || i === 8) code += '-';
    code += chars[Math.floor(Math.random() * chars.length)];
  }
  return { code, amount, expires: new Date(Date.now() + 365 * 24 * 60 * 60 * 1000).toISOString() };
}
window.generateGiftCard = generateGiftCard;

// ═══════════════════════════════════════════════════════
// CHARITY ROUND-UP
// ═══════════════════════════════════════════════════════
function calculateRoundUp(total) {
  const nextHundred = Math.ceil(total / 100) * 100;
  return nextHundred - total;
}
window.calculateRoundUp = calculateRoundUp;

// ═══════════════════════════════════════════════════════
// SESSION TRACKING (basic analytics)
// ═══════════════════════════════════════════════════════
const Analytics = {
  events: JSON.parse(sessionStorage.getItem('analytics_events') || '[]'),
  track(event, data = {}) {
    const entry = { event, data, timestamp: new Date().toISOString(), page: window.location.pathname };
    this.events.push(entry);
    sessionStorage.setItem('analytics_events', JSON.stringify(this.events.slice(-100)));
  },
  getSessionSummary() {
    return {
      pageViews: this.events.filter(e => e.event === 'page_view').length,
      addToCart: this.events.filter(e => e.event === 'add_to_cart').length,
      wishlist: this.events.filter(e => e.event === 'wishlist_add').length,
      searches: this.events.filter(e => e.event === 'search').length,
      sessionDuration: this.events.length > 0 ? Math.round((Date.now() - new Date(this.events[0].timestamp)) / 1000) : 0,
    };
  }
};
window.Analytics = Analytics;

// ═══════════════════════════════════════════════════════
// SEARCH AUTOCOMPLETE & HISTORY
// ═══════════════════════════════════════════════════════
const SearchHistory = {
  KEY: 'search_history',
  MAX: 8,
  add(query) {
    if (!query?.trim()) return;
    let history = this.get();
    history = [query, ...history.filter(h => h !== query)].slice(0, this.MAX);
    localStorage.setItem(this.KEY, JSON.stringify(history));
  },
  get() { try { return JSON.parse(localStorage.getItem(this.KEY) || '[]'); } catch { return []; } },
  clear() { localStorage.removeItem(this.KEY); }
};

function showSearchSuggestions(inputId, containerId, allProducts) {
  const input = document.getElementById(inputId);
  const container = document.getElementById(containerId);
  if (!input || !container) return;

  input.addEventListener('input', debounceSearch(() => {
    const q = input.value.toLowerCase().trim();
    if (!q) {
      const history = SearchHistory.get();
      container.innerHTML = history.length ? `
        <div style="padding:8px 14px;font-size:11px;color:#555;text-transform:uppercase;letter-spacing:0.5px;">Nedávné hledání</div>
        ${history.map(h => `<div onclick="document.getElementById('${inputId}').value='${escapeHtml(h)}';document.getElementById('${inputId}').dispatchEvent(new Event('input'))" style="padding:10px 14px;cursor:pointer;font-size:14px;" onmouseover="this.style.background='rgba(200,169,106,0.07)'" onmouseout="this.style.background=''">${escapeHtml(h)}</div>`).join('')}` : '';
      container.style.display = history.length ? 'block' : 'none';
      return;
    }
    const matches = (allProducts || []).filter(p => p.name?.toLowerCase().includes(q) || p.category?.toLowerCase().includes(q)).slice(0, 6);
    if (!matches.length) { container.style.display = 'none'; return; }
    container.innerHTML = matches.map(p => `
      <div onclick="sessionStorage.setItem('selectedProductId','${p.id}');SearchHistory.add('${escapeHtml(p.name)}');goTo('/product');document.getElementById('${containerId}').style.display='none'" style="display:grid;grid-template-columns:36px 1fr auto;gap:10px;padding:10px 14px;cursor:pointer;align-items:center;" onmouseover="this.style.background='rgba(200,169,106,0.07)'" onmouseout="this.style.background=''">
        <img src="/images/products/pokebowl-${p.default_color||'black'}-front.jpg" style="width:36px;height:36px;border-radius:4px;object-fit:cover;" onerror="this.src='/images/products/pokebowl-black-front.jpg'" alt="${escapeHtml(p.name)}">
        <div>
          <div style="font-size:13px;font-weight:600;">${escapeHtml(p.name)}</div>
          <div style="font-size:11px;color:#666;">${escapeHtml(p.category||'')}</div>
        </div>
        <div style="font-size:12px;color:#c8a96a;white-space:nowrap;">${formatPrice(p.price_standard||p.price_small||0)} Kč</div>
      </div>`).join('');
    container.style.display = 'block';
  }, 200));

  document.addEventListener('click', e => {
    if (!container.contains(e.target) && e.target !== input) container.style.display = 'none';
  });
}

function debounceSearch(fn, ms) {
  let t; return (...a) => { clearTimeout(t); t = setTimeout(() => fn(...a), ms); };
}

window.SearchHistory = SearchHistory;
window.showSearchSuggestions = showSearchSuggestions;

// ═══════════════════════════════════════════════════════
// GAMIFICATION — ACHIEVEMENTS
// ═══════════════════════════════════════════════════════
const Achievements = {
  KEY: 'achievements',
  list: {
    'first_purchase':   { label:'První nákup 🎉', desc:'Dokončil jsi první objednávku', points:50 },
    'wishlist_5':       { label:'Sběratel ❤️', desc:'Přidal 5 produktů do oblíbených', points:20 },
    'review_writer':    { label:'Recenzent ⭐', desc:'Napsal jsi svou první recenzi', points:30 },
    'newsletter':       { label:'Odběratel 📬', desc:'Přihlásil ses k newsletteru', points:10 },
    'big_spender':      { label:'Velký hráč 💰', desc:'Objednávka nad 1 000 Kč', points:40 },
    'forum_member':     { label:'Komunitní člen 💬', desc:'Přispěl jsi do fóra', points:15 },
    'loyal_customer':   { label:'Věrný zákazník 🏆', desc:'3 objednávky celkem', points:100 },
    'speed_buyer':      { label:'Rychlý střelec ⚡', desc:'Objednávka do 5 minut od registrace', points:25 },
  },
  get() { try { return JSON.parse(localStorage.getItem(this.KEY) || '[]'); } catch { return []; } },
  unlock(id) {
    if (!this.list[id]) return;
    const unlocked = this.get();
    if (unlocked.includes(id)) return;
    unlocked.push(id);
    localStorage.setItem(this.KEY, JSON.stringify(unlocked));
    const ach = this.list[id];
    // Add loyalty points
    const currentPoints = parseInt(localStorage.getItem('loyalty-points') || '0');
    localStorage.setItem('loyalty-points', currentPoints + ach.points);
    // Show achievement toast
    const el = document.createElement('div');
    el.style.cssText = `position:fixed;top:80px;right:24px;background:linear-gradient(135deg,#1a1a0a,#2a2a10);border:1px solid rgba(200,169,106,0.4);border-radius:10px;padding:16px 20px;z-index:10002;animation:slideInToast 0.4s ease;display:flex;align-items:center;gap:12px;max-width:300px;box-shadow:0 8px 24px rgba(0,0,0,0.4);`;
    el.innerHTML = `<div style="font-size:32px;">🏅</div><div><div style="font-weight:700;font-size:14px;color:#c8a96a;">Achievement odemčen!</div><div style="font-size:13px;color:#ccc;margin-top:2px;">${escapeHtml(ach.label)}</div><div style="font-size:11px;color:#777;margin-top:2px;">+${ach.points} bodů</div></div>`;
    document.body.appendChild(el);
    setTimeout(() => { el.style.opacity='0'; el.style.transform='translateX(20px)'; el.style.transition='all 0.3s'; setTimeout(()=>el.remove(),300); }, 4000);
  }
  // check() is an alias for unlock() — used by product.js and checkout.js
  check(id) { this.unlock(id); }
};
window.Achievements = Achievements;

// ═══════════════════════════════════════════════════════
// REFERRAL CODE SYSTEM
// ═══════════════════════════════════════════════════════
function generateReferralCode() {
  const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ0123456789';
  let code = 'REF-';
  for (let i = 0; i < 8; i++) code += chars[Math.floor(Math.random() * chars.length)];
  localStorage.setItem('my_referral_code', code);
  return code;
}
function getMyReferralCode() {
  return localStorage.getItem('my_referral_code') || generateReferralCode();
}
window.generateReferralCode = generateReferralCode;
window.getMyReferralCode = getMyReferralCode;

// ═══════════════════════════════════════════════════════
// INSTALLMENT CALCULATOR
// ═══════════════════════════════════════════════════════
function calculateInstallments(totalPrice, months = 3) {
  const installment = Math.ceil(totalPrice / months);
  return { months, installment, total: installment * months, noExtra: installment * months === totalPrice };
}
window.calculateInstallments = calculateInstallments;

// ═══════════════════════════════════════════════════════
// IMAGE ZOOM ON PRODUCT PAGE
// ═══════════════════════════════════════════════════════
function initImageZoom(imgId) {
  const img = document.getElementById(imgId);
  if (!img) return;
  const container = img.parentElement;
  if (!container) return;

  // Prevent double-init
  if (container._zoomInited) return;
  container._zoomInited = true;

  container.style.cssText += ';overflow:hidden;cursor:zoom-in;position:relative;';
  img.style.transition = 'transform 0.2s ease, transform-origin 0s';
  img.style.willChange = 'transform';

  let isZoomed = false;

  container.addEventListener('mouseenter', () => {
    isZoomed = true;
    img.style.transition = 'transform 0.25s ease';
    img.style.transform = 'scale(2.2)';
    container.style.cursor = 'crosshair';
  });

  container.addEventListener('mousemove', (e) => {
    if (!isZoomed) return;
    const rect = container.getBoundingClientRect();
    const x = Math.max(0, Math.min(100, ((e.clientX - rect.left) / rect.width) * 100));
    const y = Math.max(0, Math.min(100, ((e.clientY - rect.top) / rect.height) * 100));
    img.style.transition = 'transform-origin 0s';
    img.style.transformOrigin = `${x}% ${y}%`;
  });

  container.addEventListener('mouseleave', () => {
    isZoomed = false;
    img.style.transition = 'transform 0.25s ease, transform-origin 0.25s ease';
    img.style.transform = 'scale(1)';
    img.style.transformOrigin = 'center center';
    container.style.cursor = 'zoom-in';
  });
}
window.initImageZoom = initImageZoom;

// ═══════════════════════════════════════════════════════
// META OG TAGS UPDATER
// ═══════════════════════════════════════════════════════
function updateMetaTags({ title, description, image, url }) {
  document.title = title + ' — Drobnostík';
  const setMeta = (prop, content, isOg = false) => {
    const sel = isOg ? `meta[property="${prop}"]` : `meta[name="${prop}"]`;
    let el = document.querySelector(sel);
    if (!el) {
      el = document.createElement('meta');
      el.setAttribute(isOg ? 'property' : 'name', prop);
      document.head.appendChild(el);
    }
    el.setAttribute('content', content);
  };
  if (description) { setMeta('description', description); setMeta('og:description', description, true); }
  if (title) { setMeta('og:title', title + ' — Drobnostík', true); setMeta('twitter:title', title); }
  if (image) { setMeta('og:image', image, true); setMeta('twitter:image', image); }
  if (url) { setMeta('og:url', url || window.location.href, true); }
  setMeta('og:type', 'website', true);
  setMeta('og:site_name', 'Drobnostík', true);
  setMeta('twitter:card', 'summary_large_image');
}
window.updateMetaTags = updateMetaTags;

// ═══════════════════════════════════════════════════════
// STRUCTURED DATA (JSON-LD)
// ═══════════════════════════════════════════════════════
function injectProductSchema(product) {
  const existing = document.getElementById('product-schema');
  if (existing) existing.remove();
  const script = document.createElement('script');
  script.id = 'product-schema';
  script.type = 'application/ld+json';
  script.textContent = JSON.stringify({
    '@context': 'https://schema.org',
    '@type': 'Product',
    name: product.name,
    description: product.description,
    image: `https://drobnostik.cz/images/products/pokebowl-${product.default_color||'black'}-front.jpg`,
    brand: { '@type': 'Brand', name: 'Drobnostík' },
    offers: {
      '@type': 'Offer',
      price: product.price_standard || product.price_small,
      priceCurrency: 'CZK',
      availability: (product.stock_quantity || 0) > 0 ? 'https://schema.org/InStock' : 'https://schema.org/OutOfStock',
      seller: { '@type': 'Organization', name: 'Drobnostík' }
    }
  });
  document.head.appendChild(script);
}
window.injectProductSchema = injectProductSchema;

// ═══════════════════════════════════════════════════════
// ESTIMATED DELIVERY DATE
// ═══════════════════════════════════════════════════════
function getDeliveryEstimate(method) {
  const today = new Date();
  const cutoffHour = 14;
  const isBeforeCutoff = today.getHours() < cutoffHour;
  const addDays = (d, n) => { const r = new Date(d); r.setDate(r.getDate() + n); return r; };
  const skipWeekends = (d, n) => {
    let count = 0, cur = new Date(d);
    while (count < n) {
      cur.setDate(cur.getDate() + 1);
      if (cur.getDay() !== 0 && cur.getDay() !== 6) count++;
    }
    return cur;
  };
  const fmt = (d) => d.toLocaleDateString('cs-CZ', { weekday:'short', day:'numeric', month:'short' });
  const baseDay = isBeforeCutoff ? today : addDays(today, 1);

  const estimates = {
    // Real carriers
    zasilkovna:       { min: 1, max: 3, label: 'Zásilkovna' },
    zasilkovna_home:  { min: 2, max: 3, label: 'Zásilkovna domů' },
    ppl:              { min: 1, max: 2, label: 'PPL' },
    dpd:              { min: 1, max: 2, label: 'DPD' },
    gls:              { min: 1, max: 2, label: 'GLS' },
    ceska_posta:      { min: 2, max: 4, label: 'Česká pošta' },
    ceska_posta_box:  { min: 2, max: 4, label: 'Česká pošta — Na poštu' },
    dhl_express:      { min: 1, max: 1, label: 'DHL Express' },
    pickup:           { min: 0, max: 0, label: 'Osobní odběr' },
    // Legacy
    standard:         { min: 3, max: 5, label: 'Standardní' },
    express:          { min: 1, max: 2, label: 'Expres' },
  };
  const e = estimates[method] || estimates.standard;
  const minDate = skipWeekends(baseDay, e.min);
  const maxDate = skipWeekends(baseDay, e.max);
  if (method === 'pickup') return 'Po dokončení výroby (3–5 prac. dní)';
  return e.min === e.max
    ? `${fmt(minDate)}`
    : `${fmt(minDate)} – ${fmt(maxDate)}`;
}
window.getDeliveryEstimate = getDeliveryEstimate;

// ═══════════════════════════════════════════════════════
// STOCK URGENCY INDICATOR
// ═══════════════════════════════════════════════════════
function getStockUrgency(qty) {
  if (qty === 0) return { level:'out', label:'❌ Vyprodáno', color:'#f44' };
  if (qty <= 2) return { level:'critical', label:`🔥 Poslední ${qty} kusy!`, color:'#f44' };
  if (qty <= 5) return { level:'low', label:`⚠️ Zbývá jen ${qty} kusů`, color:'#fa0' };
  if (qty <= 10) return { level:'medium', label:`📦 Zbývá ${qty} kusů`, color:'#4af' };
  return { level:'ok', label:'✅ Na skladě', color:'#4f4' };
}
window.getStockUrgency = getStockUrgency;

// ═══════════════════════════════════════════════════════
// INIT ALL FEATURES ON PAGE LOAD
// ═══════════════════════════════════════════════════════
document.addEventListener('DOMContentLoaded', () => {
  initCookieConsent();
  initScrollToTop();
  initProgressBar();
  initMiniCart();
  updateTabTitle();

  // Track page view
  Analytics.track('page_view', { path: window.location.pathname });

  // Inject base OG tags
  const baseOgImage = 'https://drobnostik.cz/images/pokebowl-lifestyle-desk.jpg';
  updateMetaTags({
    title: 'Drobnostík',
    description: 'Prémiové 3D tisknuté Pokebally z Česka. 3 barvy, 3 velikosti. Rychlé doručení.',
    image: baseOgImage,
    url: window.location.href
  });

  // Inject organization JSON-LD
  if (!document.getElementById('org-schema')) {
    const s = document.createElement('script');
    s.id = 'org-schema';
    s.type = 'application/ld+json';
    s.textContent = JSON.stringify({
      '@context': 'https://schema.org',
      '@type': 'Organization',
      name: 'Drobnostík',
      url: 'https://drobnostik.cz',
      logo: 'https://drobnostik.cz/images/logo.png',
      contactPoint: { '@type': 'ContactPoint', telephone: '+420-777-123-456', contactType: 'customer service', availableLanguage: 'Czech' },
      sameAs: ['https://instagram.com/drobnostik', 'https://facebook.com/drobnostik']
    });
    document.head.appendChild(s);
  }
});

// ═══════════════════════════════════════════════════════
// REPEAT LAST ORDER
// ═══════════════════════════════════════════════════════
async function repeatOrder(orderNumber) {
  try {
    const sb = await getSupabase();
    const { data: items } = await sb.from('order_items').select('*')
      .eq('order_id', (await sb.from('orders').select('id').eq('order_number', orderNumber).single()).data?.id);
    if (!items?.length) { showToast('Položky objednávky nenalezeny'); return; }
    items.forEach(item => {
      Cart.add({ id: item.product_id, name: item.product_name, price: item.unit_price, color: item.color || 'black', size: item.size || 'Standard', quantity: item.quantity });
    });
    showToast(`✓ ${items.length} položek přidáno do košíku`);
    goTo('/cart');
  } catch(e) { showToast('Chyba: ' + e.message); }
}
window.repeatOrder = repeatOrder;

// ═══════════════════════════════════════════════════════
// INSTALLMENT DISPLAY IN PRODUCT PAGE
// ═══════════════════════════════════════════════════════
function showInstallmentInfo(price) {
  if (typeof calculateInstallments !== 'function') return;
  const info = calculateInstallments(price, 3);
  const el = document.getElementById('installment-info');
  if (el) {
    el.innerHTML = `💳 Nebo <strong style="color:#c8a96a;">3× ${formatPrice(info.installment)} Kč</strong> bez navýšení`;
    el.style.display = 'block';
  }
}
window.showInstallmentInfo = showInstallmentInfo;

// ═══════════════════════════════════════════════════════
// SEARCH SYNONYMS
// ═══════════════════════════════════════════════════════
const SEARCH_SYNONYMS = {
  'pokeball': 'pokébol', 'pokebowl': 'pokébol', 'míček': 'pokébol', 'ball': 'pokébol',
  'cerny': 'černý', 'bily': 'bílý', 'sedy': 'šedý', 'grey': 'šedý', 'gray': 'šedý', 'white': 'bílý', 'black': 'černý',
  'maly': 'small', 'velky': 'maxi', 'střední': 'standard',
};

function applySynonyms(query) {
  let q = query.toLowerCase();
  for (const [syn, canonical] of Object.entries(SEARCH_SYNONYMS)) {
    q = q.replace(new RegExp(syn, 'g'), canonical);
  }
  return q;
}
window.applySynonyms = applySynonyms;

// ═══════════════════════════════════════════════════════
// ADMIN NOTIFICATION BADGE ON PAGE TITLE
// ═══════════════════════════════════════════════════════
async function checkAdminNotifications() {
  if (!sessionStorage.getItem('admin-auth')) return;
  try {
    const sb = await getSupabase();
    const { count: pendingOrders } = await sb.from('orders').select('*', {count:'exact',head:true}).eq('status','pending');
    const { count: openTickets } = await sb.from('support_tickets').select('*', {count:'exact',head:true}).eq('status','open');
    const total = (pendingOrders || 0) + (openTickets || 0);
    if (total > 0) {
      document.title = `(${total}) ${document.title.replace(/^\(\d+\) /, '')}`;
    }
  } catch(e) {}
}
window.checkAdminNotifications = checkAdminNotifications;

// ═══════════════════════════════════════════════════════
// PRINT INVOICE (from success page / order detail)
// ═══════════════════════════════════════════════════════
async function printInvoice(orderNumber) {
  try {
    const sb = await getSupabase();
    const { data: order } = await sb.from('orders').select('*').eq('order_number', orderNumber).single();
    const { data: items } = await sb.from('order_items').select('*').eq('order_id', order?.id);
    if (!order) { showToast('Objednávka nenalezena'); return; }
    
    const win = window.open('', '_blank');
    win.document.write(`<!DOCTYPE html><html lang="cs"><head><meta charset="UTF-8"><title>Faktura ${orderNumber}</title>
    <style>body{font-family:sans-serif;max-width:700px;margin:40px auto;color:#111;}h1{font-size:24px;}table{width:100%;border-collapse:collapse;}th,td{padding:10px;border-bottom:1px solid #ddd;text-align:left;}th{background:#f5f5f5;}.total{font-size:18px;font-weight:700;}.footer{margin-top:40px;color:#777;font-size:12px;}</style>
    </head><body>
    <img src="/images/logo.png" height="40" alt="Drobnostík">
    <h1>Faktura / Daňový doklad</h1>
    <p><strong>Číslo:</strong> ${orderNumber} &nbsp;|&nbsp; <strong>Datum:</strong> ${new Date(order.created_at).toLocaleDateString('cs-CZ')}</p>
    <hr>
    <p><strong>Zákazník:</strong> ${order.customer_name}<br>${order.customer_street}, ${order.customer_city} ${order.customer_postal}</p>
    <p><strong>Prodávající:</strong> Drobnostík, IČO: 123 45 678, Dlouhá 15, 110 00 Praha 1</p>
    <hr>
    <table><thead><tr><th>Produkt</th><th>Barva</th><th>Vel.</th><th>Ks</th><th>Cena/ks</th><th>Celkem</th></tr></thead>
    <tbody>${(items||[]).map(i=>`<tr><td>${i.product_name}</td><td>${i.color}</td><td>${i.size||'Standard'}</td><td>${i.quantity}</td><td>${i.unit_price} Kč</td><td>${i.total_price} Kč</td></tr>`).join('')}</tbody></table>
    <p>Doprava: ${order.shipping_cost} Kč</p>
    <p class="total">Celkem: ${order.total_amount} Kč (vč. DPH 21%)</p>
    <p>Způsob platby: ${order.shipping_method === 'pickup' ? 'Osobní odběr' : 'Zásilka'}</p>
    <div class="footer">Drobnostík | info@drobnostik.cz | +420 777 123 456 | drobnostik.cz<br>Děkujeme za nákup!</div>
    </body></html>`);
    win.document.close();
    win.print();
  } catch(e) { showToast('Chyba tisku: ' + e.message); }
}
window.printInvoice = printInvoice;

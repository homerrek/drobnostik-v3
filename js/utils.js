// js/utils.js — Drobnostík v3

// ─── Toast ───────────────────────────────────────────────────────
function showToast(msg, duration = 3200) {
  const el = document.createElement('div');
  el.className = 'toast';
  el.textContent = msg;
  document.body.appendChild(el);
  setTimeout(() => {
    el.style.opacity = '0';
    el.style.transform = 'translateX(20px)';
    el.style.transition = 'all 0.3s';
    setTimeout(() => el.remove(), 300);
  }, duration);
}

// ─── Formátování ceny ────────────────────────────────────────────
function formatPrice(num) {
  return new Intl.NumberFormat('cs-CZ').format(Math.round(num));
}

// ─── Formátování data ────────────────────────────────────────────
function formatDate(date) {
  return new Date(date).toLocaleDateString('cs-CZ');
}

// ─── Local storage helper ────────────────────────────────────────
const Storage = {
  set: (key, val) => localStorage.setItem('drobnostik_' + key, JSON.stringify(val)),
  get: (key, def = null) => {
    try {
      const item = localStorage.getItem('drobnostik_' + key);
      return item !== null ? JSON.parse(item) : def;
    } catch { return def; }
  },
  remove: (key) => localStorage.removeItem('drobnostik_' + key),
  clear: () => {
    Object.keys(localStorage)
      .filter(k => k.startsWith('drobnostik_'))
      .forEach(k => localStorage.removeItem(k));
  }
};

// ─── Theme ───────────────────────────────────────────────────────
function toggleTheme() {
  const isLight = document.body.classList.contains('light-mode');
  if (isLight) {
    document.body.classList.remove('light-mode');
    localStorage.setItem('theme', 'dark');
  } else {
    document.body.classList.add('light-mode');
    localStorage.setItem('theme', 'light');
  }
  updateThemeButton();
}

function updateThemeButton() {
  const btn = document.querySelector('.btn-theme');
  if (!btn) return;
  btn.textContent = document.body.classList.contains('light-mode') ? '🌙' : '☀️';
}

function initTheme() {
  const saved = localStorage.getItem('theme') || 'dark';
  if (saved === 'light') {
    document.body.classList.add('light-mode');
  } else {
    document.body.classList.remove('light-mode');
  }
  updateThemeButton();
}

// ─── HTML escape ─────────────────────────────────────────────────
function escapeHtml(text) {
  if (!text) return '';
  const map = { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#039;' };
  return String(text).replace(/[&<>"']/g, m => map[m]);
}

// ─── Loading spinner helper ───────────────────────────────────────
function showLoading(containerId) {
  const el = document.getElementById(containerId);
  if (el) el.innerHTML = '<div class="loading-spinner"></div>';
}

// ─── Active nav link highlight ────────────────────────────────────
function updateActiveNav(path) {
  document.querySelectorAll('.nav-link').forEach(a => {
    const href = a.getAttribute('href');
    a.classList.toggle('active', href === path || (path === '/' && href === '/'));
  });
}

// ─── Init on load ─────────────────────────────────────────────────
document.addEventListener('DOMContentLoaded', initTheme);

// ─── Exports ──────────────────────────────────────────────────────
window.showToast = showToast;
window.formatPrice = formatPrice;
window.formatDate = formatDate;
window.Storage = Storage;
window.toggleTheme = toggleTheme;
window.initTheme = initTheme;
window.escapeHtml = escapeHtml;
window.showLoading = showLoading;
window.updateActiveNav = updateActiveNav;

// ─── Scroll to Top ────────────────────────────────────────────
function initScrollToTop() {
  const btn = document.getElementById('scroll-to-top');
  if (!btn) return;
  window.addEventListener('scroll', () => {
    btn.classList.toggle('visible', window.scrollY > 400);
  });
  btn.addEventListener('click', () => window.scrollTo({ top: 0, behavior: 'smooth' }));
}

// ─── Page progress bar ─────────────────────────────────────────
function initProgressBar() {
  const bar = document.getElementById('page-progress');
  if (!bar) return;
  window.addEventListener('scroll', () => {
    const total = document.documentElement.scrollHeight - window.innerHeight;
    const pct = total > 0 ? (window.scrollY / total) * 100 : 0;
    bar.style.width = pct + '%';
  });
}

// ─── Cookie Consent ────────────────────────────────────────────
function initCookieConsent() {
  if (localStorage.getItem('cookies_accepted')) return;
  const banner = document.getElementById('cookie-banner');
  if (banner) {
    setTimeout(() => banner.classList.add('visible'), 1200);
  }
}
function acceptCookies(type) {
  localStorage.setItem('cookies_accepted', type || 'essential');
  var banner = document.getElementById('cookie-banner');
  if (banner) {
    // Slide down and remove
    banner.style.transform = 'translateY(100%)';
    banner.style.transition = 'transform 0.4s ease';
    setTimeout(function() { if (banner.parentNode) banner.parentNode.removeChild(banner); }, 450);
  }
  if (type === 'all') showToast('✓ Cookies přijaty');
}

// ─── Recently Viewed ──────────────────────────────────────────
// RecentlyViewed defined in features.js
;

// ─── Browser Notifications ────────────────────────────────────
async function requestNotificationPermission() {
  if (!('Notification' in window)) return false;
  if (Notification.permission === 'granted') return true;
  const result = await Notification.requestPermission();
  return result === 'granted';
}
function sendBrowserNotification(title, body, icon) {
  if (Notification.permission !== 'granted') return;
  new Notification(title, { body, icon: icon || '/images/logo.png' });
}

// ─── Page title badge (unread) ────────────────────────────────
let _originalTitle = document.title;
function setTitleBadge(count) {
  document.title = count > 0 ? `(${count}) ${_originalTitle}` : _originalTitle;
}

// ─── Breadcrumbs ──────────────────────────────────────────────
function renderBreadcrumbs(items) {
  return `<nav aria-label="Breadcrumb" style="display:flex;align-items:center;gap:6px;font-size:13px;color:#666;margin-bottom:20px;flex-wrap:wrap;">
    ${items.map((item, i) => i < items.length - 1
      ? `<a href="${item.href}" onclick="event.preventDefault();goTo('${item.href}')" style="color:#666;text-decoration:none;transition:color 0.2s;" onmouseover="this.style.color='#c8a96a'" onmouseout="this.style.color='#666'">${escapeHtml(item.label)}</a><span style="color:#444;">›</span>`
      : `<span style="color:#999;">${escapeHtml(item.label)}</span>`
    ).join('')}
  </nav>`;
}

// ─── Share product ────────────────────────────────────────────
async function shareProduct(name, url) {
  const shareUrl = url || window.location.href;
  if (navigator.share) {
    try {
      await navigator.share({ title: name || 'Drobnostík', text: 'Podívej se na tento Pokeball!', url: shareUrl });
      return;
    } catch(e) {}
  }
  await navigator.clipboard?.writeText(shareUrl);
  showToast('✓ Odkaz zkopírován do schránky');
}

// ─── Init all global features ─────────────────────────────────
document.addEventListener('DOMContentLoaded', () => {
  initScrollToTop();
  initProgressBar();
  initCookieConsent();
  _originalTitle = document.title;
});

window.acceptCookies = acceptCookies;
window.shareProduct = shareProduct;
window.renderBreadcrumbs = renderBreadcrumbs;
if (typeof RecentlyViewed !== "undefined") window.RecentlyViewed = RecentlyViewed;
window.requestNotificationPermission = requestNotificationPermission;
window.sendBrowserNotification = sendBrowserNotification;
window.setTitleBadge = setTitleBadge;

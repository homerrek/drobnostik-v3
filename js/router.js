// js/router.js — Drobnostík v3 — Complete

const Router = {
  routes: {
    '/': '/pages/home.html',
    '/shop': '/pages/shop.html',
    '/product': '/pages/product.html',
    '/cart': '/pages/cart.html',
    '/checkout': '/pages/checkout.html',
    '/success': '/pages/success.html',
    '/faq': '/pages/faq.html',
    '/contact': '/pages/contact.html',
    '/wishlist': '/pages/wishlist.html',
    '/compare': '/pages/compare.html',
    '/deals': '/pages/deals.html',
    '/best-sellers': '/pages/best-sellers.html',
    '/search': '/pages/search.html',
    '/my-account': '/pages/my-account.html',
    '/reviews': '/pages/reviews.html',
    '/about': '/pages/about.html',
    '/track-order': '/pages/track-order.html',
    '/subscriptions': '/pages/subscriptions.html',
    '/loyalty': '/pages/loyalty.html',
    '/live-chat': '/pages/live-chat.html',
    '/quick-view': '/pages/quick-view.html',
    '/terms': '/pages/terms.html',
    '/privacy': '/pages/privacy.html',
    '/returns': '/pages/returns.html',
    '/achievements': '/pages/achievements.html',
    // Phase 3 — Blog
    '/blog': '/pages/blog.html',
    '/blog/post': '/pages/blog-post.html',
    // Phase 4 — Affiliate
    '/affiliate': '/pages/affiliate.html',
    '/affiliate/dashboard': '/pages/affiliate-dashboard.html',
    // Phase 5 — Forum
    '/forum': '/pages/forum.html',
    '/forum/thread': '/pages/forum-thread.html',
    // Phase 6 — B2B
    '/b2b': '/pages/b2b.html',
    // Phase 10 — Tickets
    '/support': '/pages/support.html',
    '/help': '/pages/help.html',
    // Admin
    '/gift-card': '/pages/gift-card.html',
    '/help-center': '/pages/help-center.html',
    '/terms': '/pages/terms.html',
    '/privacy': '/pages/privacy.html',
    '/returns': '/pages/returns.html',
    '/cookies': '/pages/privacy.html',
    '/admin/login': '/pages/admin/login.html',
    '/admin': '/pages/admin/dashboard.html',
    '/admin/products': '/pages/admin/products.html',
    '/admin/orders': '/pages/admin/orders.html',
    '/admin/reports': '/pages/admin/reports.html',
    '/admin/import': '/pages/admin/import.html',
    '/admin/categories': '/pages/admin/categories.html',
    '/admin/analytics': '/pages/admin/analytics.html',
    '/admin/multi-language': '/pages/admin/multi-language.html',
    '/admin/payment-settings': '/pages/admin/payment-settings.html',
    '/admin/email-templates': '/pages/admin/email-templates.html',
    // Phase 1 — Email marketing admin
    '/admin/email-campaigns': '/pages/admin/email-campaigns.html',
    // Phase 7 — Inventory admin
    '/admin/inventory': '/pages/admin/inventory.html',
    // Phase 2 — Advanced analytics admin
    '/admin/analytics/sales': '/pages/admin/analytics.html',
    // Blog admin
    '/admin/blog': '/pages/admin/blog.html',
    // Affiliate admin
    '/admin/affiliates': '/pages/admin/affiliates.html',
    // Tickets admin
    '/admin/tickets': '/pages/admin/tickets.html',
    // Coupon admin
    '/admin/coupons': '/pages/admin/coupons.html',
    // Customer admin
    '/admin/customers': '/pages/admin/customers.html',
  },

  getPath() {
    let path = window.location.pathname.replace(/\/index\.html$/, '');
    if (!path.startsWith('/')) path = '/' + path;
    if (path !== '/' && path.endsWith('/')) path = path.slice(0, -1);
    return path || '/';
  },

  async load(path) {
    // Strip query string for route lookup (but keep it in the URL)
    const cleanPath = path.split('?')[0].split('#')[0];
    let file = this.routes[cleanPath];
    if (!file) {
      // Try /admin/* prefix match
      if (cleanPath.startsWith('/admin/')) {
        const adminBase = '/admin/' + cleanPath.split('/')[2];
        file = this.routes[adminBase];
      }
      // Try /blog/post, /forum/thread etc
      if (!file) {
        const prefix = '/' + cleanPath.split('/')[1];
        if (this.routes[prefix + '/post'] && cleanPath.startsWith(prefix + '/')) {
          file = this.routes[prefix + '/post'];
        }
        if (!file && this.routes[prefix + '/thread'] && cleanPath.startsWith(prefix + '/')) {
          file = this.routes[prefix + '/thread'];
        }
      }
      // Last resort: home
      file = file || this.routes['/'];
    }

    window.scrollTo(0, 0);
    if (typeof updateActiveNav === 'function') updateActiveNav(path);
    if (typeof progressStart === 'function') progressStart();

    const app = document.getElementById('app');
    app.innerHTML = '<div style="display:flex;justify-content:center;padding:80px 20px;"><div class="loading-spinner"></div></div>';

    try {
      const res = await fetch(file + '?v=' + Date.now());
      if (!res.ok) throw new Error('Stránka nenalezena: ' + file);
      let html = await res.text();

      // Safety: if Netlify returned index.html instead of the fragment,
      // detect by checking for our shell markers
      if (html.includes('id="header"') || html.includes('<html') || html.includes('<!DOCTYPE')) {
        console.warn('Router: received full HTML instead of fragment for', file, '- retrying without cache');
        const res2 = await fetch(file + '?nocache=' + Math.random());
        if (res2.ok) {
          const html2 = await res2.text();
          if (!html2.includes('id="header"') && !html2.includes('<html')) {
            html = html2;
          }
        }
      }

      app.innerHTML = html;

      // Remove old page scripts
      document.querySelectorAll('script[data-page-script]').forEach(s => s.remove());

      // Collect and re-execute inline scripts
      // Wrap in async IIFE so top-level await works (e.g. var sb = await getSupabase())
      const pageScripts = Array.from(app.querySelectorAll('script'));
      const scriptPromises = [];

      pageScripts.forEach(oldScript => {
        oldScript.remove();
        if (oldScript.src) {
          // External src - inject normally
          const s = document.createElement('script');
          s.setAttribute('data-page-script', '1');
          s.src = oldScript.src;
          document.body.appendChild(s);
        } else if (oldScript.textContent.trim()) {
          // Inline - wrap in async IIFE, capture promise
          const code = oldScript.textContent;
          const s = document.createElement('script');
          s.setAttribute('data-page-script', '1');
          // Use a global slot to pass the promise out of the script tag
          const slotId = '__pageScriptDone_' + Date.now() + '_' + Math.random().toString(36).slice(2);
          s.textContent = `window['${slotId}'] = (async function(){\n${code}\n})().catch(e=>console.warn('Page script error:',e));`;
          document.body.appendChild(s);
          if (window[slotId]) scriptPromises.push(window[slotId]);
        }
      });

      // Wait for all inline async scripts to finish executing, then run page init
      Promise.all(scriptPromises).then(() => {
        this.runPageScripts(path);
        if (typeof progressDone === 'function') progressDone();
        if (typeof Analytics !== 'undefined') Analytics.track('page_view', { path });
      });
    } catch (e) {
      console.error('Router error:', e);
      if (typeof progressDone === 'function') progressDone();
      app.innerHTML = `
        <div style="padding:80px 40px;text-align:center;">
          <div style="font-size:48px;margin-bottom:20px;">🔍</div>
          <h2 style="margin-bottom:12px;color:#c8a96a;">Stránka nenalezena</h2>
          <p style="color:#999;margin-bottom:24px;">${escapeHtml(e.message)}</p>
          <button class="btn-primary" onclick="goTo('/')">← Domů</button>
        </div>`;
    }
  },

  runPageScripts(path) {
    const run = (fn, delay = 0) => {
      // Wait for page script to execute (it's injected async via appendChild)
      // Then call the function - retry if not yet available
      const callFn = (attempts) => {
        const f = typeof fn === 'function' ? fn : window[fn];
        if (typeof f === 'function') {
          f();
        } else if (attempts > 0) {
          setTimeout(() => callFn(attempts - 1), 100);
        } else {
          console.warn('Function not available after retries:', fn);
        }
      };
      // Minimum 150ms to allow injected scripts to execute on Netlify CDN
      setTimeout(() => callFn(5), Math.max(delay, 150));
    };

    // Normalize dynamic paths
    const base = '/' + path.split('/').slice(1, 3).join('/');

    const map = {
      '/': () => run(initializeHome, 100),
      '/shop': () => run(loadShop),
      '/product': () => run(loadProductDetail, 80),
      '/cart': () => run(loadCart),
      '/checkout': () => run(loadCheckout),
      '/success': () => run(loadSuccess),
      '/faq': () => run(loadFAQ),
      '/wishlist': () => run(loadWishlist, 80),
      '/compare': () => run(initComparison, 80),
      '/search': () => run(initSearch, 80),
      '/best-sellers': () => run(loadBestSellers, 80),
      '/deals': () => run(loadDeals, 80),
      '/reviews': () => run(loadReviews, 80),
      '/my-account': () => run(loadMyAccount, 80),
      '/loyalty': () => run(loadLoyalty, 80),
      '/subscriptions': () => { /* static */ },
      '/about': () => { /* static */ },
      '/contact': () => { /* static */ },
      '/track-order': () => { /* user-triggered */ },
      '/live-chat': () => { /* static */ },
      '/terms': () => { /* static */ },
      '/privacy': () => { /* static */ },
      '/returns': () => { /* static */ },
      '/achievements': () => run(loadAchievements, 80),
      '/blog': () => run(loadBlog, 80),
      '/blog/post': () => run(loadBlogPost, 80),
      '/affiliate': () => { /* static */ },
      '/affiliate/dashboard': () => run(loadAffiliateDash, 80),
      '/forum': () => run(loadForum, 80),
      '/forum/thread': () => run(loadForumThread, 80),
      '/b2b': () => { /* static */ },
      '/support': () => run(loadSupport, 80),
      '/help': () => run(loadHelp, 80),
      '/admin': () => { run(loadAdminDash, 80); if(typeof checkAdminNotifications==='function') checkAdminNotifications(); },
      '/admin/products': () => run(loadAdminProducts, 80),
      '/admin/orders': () => run(loadAdminOrders, 80),
      '/admin/reports': () => run(loadAdminReports, 80),
      '/admin/analytics': () => run(loadAdminAnalytics, 80),
      '/admin/categories': () => run(loadAdminCategories, 80),
      '/admin/email-campaigns': () => run(loadEmailCampaigns, 80),
      '/admin/inventory': () => run(loadInventory, 80),
      '/admin/blog': () => run(loadAdminBlog, 80),
      '/admin/affiliates': () => run(loadAdminAffiliates, 80),
      '/admin/tickets': () => run(loadAdminTickets, 80),
      '/admin/coupons': () => run(loadAdminCoupons, 80),
      '/admin/email-templates': () => run(loadEmailTemplates, 80),
      '/admin/payment-settings': () => run(loadPaymentSettings, 80),
      '/admin/multi-language': () => { /* static */ },
      '/admin/import': () => { /* user-triggered */ },
      '/admin/customers': () => run(loadAdminCustomers, 80),
      '/admin/login': () => { /* static form */ },
      '/gift-card': () => { /* static */ },
      '/help-center': () => { /* renders on DOMContentLoaded */ },
      '/quick-view': () => { /* modal, not a page */ },
      '/cookies': () => { /* static */ },
    };

    try {
      const cleanPath = path.split('?')[0].split('#')[0];
      const cleanBase = '/' + cleanPath.split('/').slice(1, 3).join('/');
      const handler = map[cleanPath] || map[cleanBase] || map[path] || map[base];
      if (handler) handler();
    } catch (e) { console.warn('runPageScripts error:', e); }
  }
};

// Global error handlers — prevent unhandled promise rejections from crashing the app
window.addEventListener('unhandledrejection', function(e) {
  console.warn('Unhandled promise rejection (caught globally):', e.reason);
  e.preventDefault(); // prevent browser error overlay
});

window.addEventListener('error', function(e) {
  // Only intercept errors from page scripts, not from core JS files
  if (e.filename && e.filename.includes('VM')) {
    console.warn('Page script error (caught globally):', e.message);
    e.preventDefault();
    return false;
  }
});

function goTo(path) {
  window.history.pushState({}, '', path);
  Router.load(path);
}

document.addEventListener('DOMContentLoaded', () => {
  Router.load(Router.getPath());
  window.addEventListener('popstate', () => Router.load(Router.getPath()));
  document.addEventListener('click', e => {
    const a = e.target.closest('a');
    if (!a) return;
    const href = a.getAttribute('href');
    if (href && href.startsWith('/') && !href.match(/\.(html|css|js|png|jpg|svg|ico|pdf|zip)/) && !href.includes('mailto:') && !href.includes('tel:')) {
      e.preventDefault();
      goTo(href);
    }
  });
});

// Stubs for functions not yet loaded
['loadWishlist','initComparison','initSearch','loadBestSellers','loadDeals',
 'loadReviews','loadMyAccount','loadLoyalty','loadBlog','loadBlogPost',
 'loadAffiliateDash','loadForum','loadForumThread','loadSupport',
 'loadAdminReports','loadAdminAnalytics','loadAdminCategories',
 'loadEmailCampaigns','loadInventory','loadAdminBlog','loadAdminAffiliates',
 'loadAdminTickets','loadAdminCoupons','loadAdminCustomers','loadEmailTemplates','loadPaymentSettings','loadHelp','loadAchievements','loadSubscriptions','loadAdminDash'
].forEach(name => {
  if (typeof window[name] === 'undefined') {
    window[name] = () => console.log(name + ' not loaded yet');
  }
});

window.Router = Router;
window.goTo = goTo;

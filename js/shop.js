// js/shop.js — Drobnostík v3

// All available product images for fallback rotation
var ALL_PRODUCT_IMAGES = [
  '/images/products/pokebowl-black-front.jpg',
  '/images/products/pokebowl-white-front.jpg',
  '/images/products/pokebowl-gray-front.jpg',
  '/images/products/pokebowl-red-front.jpg',
  '/images/products/pokebowl-black-back.jpg',
  '/images/products/pokebowl-white-back.jpg',
  '/images/products/pokebowl-gray-back.jpg',
];

// Track recently used images to prevent duplicates in grid
var _recentGridImages = [];

function getProductImage(product, color) {
  var c = color || product.default_color || 'black';

  // 1. Custom color_images from DB (highest priority)
  if (product.color_images && product.color_images[c] && product.color_images[c].front) {
    return product.color_images[c].front;
  }

  // 2. Map color to best matching available image
  var colorToFile = {
    black:  '/images/products/pokebowl-black-front.jpg',
    white:  '/images/products/pokebowl-white-front.jpg',
    gray:   '/images/products/pokebowl-gray-front.jpg',
    grey:   '/images/products/pokebowl-gray-front.jpg',
    red:    '/images/products/pokebowl-red-front.jpg',
    // Colors without own image — will pick a non-duplicate fallback
    blue:   null,
    green:  null,
    purple: null,
    yellow: '/images/products/pokebowl-white-front.jpg',
    orange: '/images/products/pokebowl-red-front.jpg',
  };

  var preferred = colorToFile[c];
  if (preferred) return preferred;

  // 3. For unknown colors: pick the LEAST recently used image to avoid duplicates
  var available = ALL_PRODUCT_IMAGES.slice(); // copy
  // Sort: put least-recently-used first
  available.sort(function(a, b) {
    var ia = _recentGridImages.lastIndexOf(a);
    var ib = _recentGridImages.lastIndexOf(b);
    return ia - ib; // lower index = used longer ago = prefer
  });
  return available[0];
}

function resetGridImageTracking() {
  _recentGridImages = [];
}

function trackGridImage(src) {
  _recentGridImages.push(src);
  if (_recentGridImages.length > 12) _recentGridImages.shift();
}

async function loadShop() {
  const grid = document.getElementById('products-grid');
  if (!grid) return;
  grid.innerHTML = '<div class="loading-spinner"></div>';

  try {
    const sb = await getSupabase();
    let query = sb.from('products').select('*').eq('is_active', true);

    // Filtrování pokud existují filtry na stránce
    const catFilter = document.getElementById('filter-category')?.value;
    const sortFilter = document.getElementById('filter-sort')?.value;
    const searchFilter = document.getElementById('shop-search')?.value?.toLowerCase();

    if (catFilter) query = query.eq('category', catFilter);
    if (sortFilter === 'price_asc') query = query.order('price_standard', { ascending: true });
    else if (sortFilter === 'price_desc') query = query.order('price_standard', { ascending: false });
    else query = query.order('created_at', { ascending: false });

    const { data: products, error } = await query;

    if (error) throw error;

    let list = products || [];
    if (searchFilter) {
      list = list.filter(p =>
        p.name?.toLowerCase().includes(searchFilter) ||
        p.description?.toLowerCase().includes(searchFilter) ||
        p.category?.toLowerCase().includes(searchFilter)
      );
    }

    if (list.length === 0) {
      grid.innerHTML = `<div style="grid-column:1/-1;text-align:center;padding:60px 20px;color:#999;">
        <div style="font-size:48px;margin-bottom:16px;">🔍</div>
        <p>Žádné produkty nebyly nalezeny</p>
      </div>`;
      return;
    }

    resetGridImageTracking();
    grid.innerHTML = list.map(p => renderProductCard(p)).join('');
    grid.querySelectorAll('.product-card-el').forEach(el => {
      el.addEventListener('click', (e) => {
        if (!e.target.closest('button')) {
          viewProduct(el.dataset.id);
        }
      });
    });

  } catch (e) {
    console.error('Shop error:', e);
    grid.innerHTML = `<div style="grid-column:1/-1;text-align:center;padding:40px;color:#f44;">❌ Chyba: ${e.message}</div>`;
  }
}

function renderProductCard(p) {
  var img = getProductImage(p, p.default_color);
  // Prevent same image appearing in adjacent cards (check last 3)
  var recentWindow = _recentGridImages.slice(-3);
  if (recentWindow.includes(img)) {
    // Try all available images, pick the one least recently used
    var candidates = ALL_PRODUCT_IMAGES.slice().sort(function(a, b) {
      return _recentGridImages.lastIndexOf(a) - _recentGridImages.lastIndexOf(b);
    });
    for (var ci = 0; ci < candidates.length; ci++) {
      if (!recentWindow.includes(candidates[ci])) {
        img = candidates[ci];
        break;
      }
    }
  }
  trackGridImage(img);
  const isWishlisted = Wishlist.has(p.id);
  const price = p.price_small || p.price_standard || 0;

  return `
    <div class="product-card product-card-el" data-id="${p.id}">
      <div class="product-img">
        <img src="${img}" alt="${escapeHtml(p.name)}" loading="lazy"
          onerror="var fb=['/images/products/pokebowl-black-front.jpg','/images/products/pokebowl-white-front.jpg','/images/products/pokebowl-gray-front.jpg','/images/products/pokebowl-red-front.jpg','/images/products/pokebowl-black-back.jpg','/images/products/pokebowl-white-back.jpg','/images/products/pokebowl-gray-back.jpg'];this.src=fb[${p.id % 7}];this.onerror=null;">
        <button class="quick-view-btn" onclick="event.stopPropagation(); openQuickView(${p.id})">👁️ Quick View</button>
        <button onclick="event.stopPropagation(); Wishlist.toggle(${p.id}); this.textContent = Wishlist.has(${p.id}) ? '❤️' : '🤍';"
          style="position:absolute;top:10px;right:10px;background:rgba(0,0,0,0.5);border:none;font-size:18px;cursor:pointer;border-radius:50%;width:36px;height:36px;display:flex;align-items:center;justify-content:center;"
          title="Přidat do oblíbených">${isWishlisted ? '❤️' : '🤍'}</button>
        ${p.is_new ? '<div style="position:absolute;top:10px;left:10px;background:#c8a96a;color:#000;font-size:11px;font-weight:700;padding:3px 8px;border-radius:4px;">NOVÉ</div>' : ''}
        ${p.sale_price ? '<div style="position:absolute;top:10px;left:10px;background:#f44;color:#fff;font-size:11px;font-weight:700;padding:3px 8px;border-radius:4px;">SLEVA</div>' : ''}
      </div>
      <div class="product-info">
        <div class="product-name">${escapeHtml(p.name)}</div>
        <div class="product-cat">${escapeHtml(p.category || 'Pokebally')}</div>
        <div style="display:flex;justify-content:space-between;align-items:center;gap:8px;">
          <div class="product-price">
            ${p.sale_price ? `<span style="text-decoration:line-through;color:#666;font-size:13px;margin-right:6px;">Od ${formatPrice(price)} Kč</span>Od ${formatPrice(p.sale_price)} Kč` : `Od ${formatPrice(price)} Kč`}
          </div>
          <button onclick="viewProduct(${p.id})"
            style="background:#c8a96a;color:#000;border:none;border-radius:4px;padding:8px 12px;font-size:12px;font-weight:600;cursor:pointer;white-space:nowrap;">
            Koupit
          </button>
        </div>
        <div style="display:flex;gap:6px;margin-top:10px;flex-wrap:wrap;">
          ${(p.colors || ['black']).slice(0,6).map(c => {
            const meta = p.color_images && p.color_images[c];
            const hex = meta?.hex || {black:'#222',white:'#f0f0f0',gray:'#888',red:'#c22',blue:'#228',green:'#282',yellow:'#cc0',purple:'#828',orange:'#c60'}[c] || '#555';
            const label = meta?.name || c;
            return `<div style="width:16px;height:16px;border-radius:50%;background:${hex};border:2px solid rgba(255,255,255,0.2);cursor:pointer;transition:transform 0.15s;" title="${label}" onclick="event.stopPropagation()" onmouseover="this.style.transform='scale(1.3)'" onmouseout="this.style.transform='scale(1)'"></div>`;
          }).join('')}
        </div>
      </div>
    </div>`;
}

function viewProduct(productId) {
  sessionStorage.setItem('selectedProductId', productId);
  goTo('/product');
}

function addToCart(id, name, price, color, size) {
  Cart.add({ id, name, price, color: color || 'black', size: size || 'Standard' });
}

function openQuickView(productId) {
  sessionStorage.setItem('quickViewId', productId);
  loadQuickView(productId);
}

async function loadQuickView(productId) {
  try {
    const sb = await getSupabase();
    const { data: p } = await sb.from('products').select('*').eq('id', productId).single();
    if (!p) return;

    const overlay = document.createElement('div');
    overlay.id = 'quick-view-overlay';
    overlay.style.cssText = 'position:fixed;inset:0;background:rgba(0,0,0,0.8);z-index:1000;display:flex;align-items:center;justify-content:center;padding:20px;';
    overlay.onclick = (e) => { if (e.target === overlay) overlay.remove(); };

    overlay.innerHTML = `
      <div style="background:#1a1a1a;border:1px solid rgba(200,169,106,0.2);border-radius:12px;max-width:700px;width:100%;max-height:90vh;overflow-y:auto;position:relative;">
        <button onclick="document.getElementById('quick-view-overlay').remove()"
          style="position:absolute;top:16px;right:16px;background:none;border:none;color:#999;font-size:24px;cursor:pointer;z-index:1;">✕</button>
        <div style="display:grid;grid-template-columns:1fr 1fr;gap:0;">
          <img src="${getProductImage(p, 'black')}" style="width:100%;aspect-ratio:1;object-fit:cover;border-radius:12px 0 0 12px;" onerror="this.src='/images/products/pokebowl-black-front.jpg'">
          <div style="padding:28px;">
            <div style="font-size:12px;color:#c8a96a;text-transform:uppercase;letter-spacing:1px;margin-bottom:8px;">${escapeHtml(p.category || 'Pokebally')}</div>
            <h2 style="font-size:22px;font-weight:700;margin-bottom:12px;">${escapeHtml(p.name)}</h2>
            <p style="color:#999;font-size:14px;line-height:1.7;margin-bottom:20px;">${escapeHtml(p.description || '')}</p>
            <div style="font-size:22px;font-weight:700;color:#c8a96a;margin-bottom:20px;">Od ${formatPrice(p.price_small || p.price_standard || 0)} Kč</div>
            <div style="display:flex;gap:10px;">
              <button onclick="Cart.add({id:${p.id},name:'${escapeHtml(p.name)}',price:${p.price_standard||p.price_small||0},color:'black',size:'Standard'}); document.getElementById('quick-view-overlay').remove();"
                class="btn-primary" style="flex:1;padding:12px;">Přidat do košíku</button>
              <button onclick="viewProduct(${p.id}); document.getElementById('quick-view-overlay').remove();"
                style="padding:12px 16px;background:#333;color:#fff;border:none;border-radius:6px;cursor:pointer;">Detail</button>
            </div>
          </div>
        </div>
      </div>`;

    document.body.appendChild(overlay);
  } catch (e) {
    console.error('QuickView error:', e);
  }
}

async function loadFeaturedProducts() {
  try {
    const sb = await getSupabase();
    const { data: products } = await sb.from('products').select('*').eq('is_featured', true).limit(4);
    const container = document.getElementById('featured-products');
    if (!container || !products?.length) return;
    resetGridImageTracking();
    container.innerHTML = products.map(p => renderProductCard(p)).join('');
  } catch (e) { console.error('Featured error:', e); }
}

async function loadBestSellers() {
  const grid = document.getElementById('bestsellers-grid');
  if (!grid) return;
  grid.innerHTML = '<div class="loading-spinner"></div>';
  try {
    const sb = await getSupabase();
    const { data: products, error } = await sb.from('products').select('*').eq('is_active', true).order('sold_count', { ascending: false }).limit(12);
    if (error) throw error;
    grid.innerHTML = (products && products.length > 0)
      ? (function(){ resetGridImageTracking(); return products.map(p => renderProductCard(p)).join(''); })()
      : '<div style="text-align:center;padding:40px;color:#999;">Žádné bestsellery</div>';
  } catch (e) {
    grid.innerHTML = `<div style="text-align:center;padding:40px;color:#f44;">❌ ${e.message}</div>`;
  }
}

async function loadDeals() {
  const grid = document.getElementById('deals-grid');
  if (!grid) return;
  grid.innerHTML = '<div class="loading-spinner"></div>';
  try {
    const sb = await getSupabase();
    const { data: products, error } = await sb.from('products').select('*').not('sale_price', 'is', null).eq('is_active', true);
    if (error) throw error;
    grid.innerHTML = (products && products.length > 0)
      ? (function(){ resetGridImageTracking(); return products.map(p => renderProductCard(p)).join(''); })()
      : '<div style="text-align:center;padding:40px;color:#999;">Žádné akce momentálně</div>';
  } catch (e) {
    grid.innerHTML = `<div style="text-align:center;padding:40px;color:#f44;">❌ ${e.message}</div>`;
  }
}

window.loadShop = window.loadShop = loadShop;
window.viewProduct = viewProduct;
window.addToCart = addToCart;
window.openQuickView = openQuickView;
window.loadQuickView = loadQuickView;
window.loadFeaturedProducts = loadFeaturedProducts;
window.loadBestSellers = loadBestSellers;
window.loadDeals = loadDeals;
window.renderProductCard = renderProductCard;
window.getProductImage = getProductImage;

// ─── Autocomplete search ──────────────────────────────────────
let _allProductsCache = null;

async function initSearchAutocomplete(inputId, suggestionsId) {
  if (!_allProductsCache) {
    try {
      const sb = await getSupabase();
      const { data } = await sb.from('products').select('id,name,category,price_standard,price_small').eq('is_active', true);
      _allProductsCache = data || [];
    } catch(e) { return; }
  }

  const input = document.getElementById(inputId);
  const container = document.getElementById(suggestionsId);
  if (!input || !container) return;

  input.addEventListener('input', () => {
    const q = input.value.trim().toLowerCase();
    if (q.length < 2) { container.style.display = 'none'; return; }

    const matches = _allProductsCache.filter(p =>
      p.name?.toLowerCase().includes(q) || p.category?.toLowerCase().includes(q)
    ).slice(0, 6);

    if (!matches.length) { container.style.display = 'none'; return; }

    container.innerHTML = matches.map(p => `
      <div class="search-suggestion-item" onclick="viewProduct(${p.id});document.getElementById('${suggestionsId}').style.display='none'">
        <span style="font-size:18px;">🎮</span>
        <div>
          <div style="font-weight:600;">${escapeHtml(p.name)}</div>
          <div style="font-size:12px;color:#555;">${escapeHtml(p.category || '')} · od ${formatPrice(p.price_small||p.price_standard||0)} Kč</div>
        </div>
      </div>`).join('');
    container.style.display = 'block';
  });

  document.addEventListener('click', e => {
    if (!input.contains(e.target) && !container.contains(e.target)) {
      container.style.display = 'none';
    }
  });
  input.addEventListener('keydown', e => {
    if (e.key === 'Escape') container.style.display = 'none';
  });
}

// ─── Star rating renderer ─────────────────────────────────────
function renderStars(rating, count) {
  const full = Math.round(rating || 0);
  return `<div class="star-rating" title="${(rating||0).toFixed(1)} z 5 (${count||0} recenzí)">
    ${[1,2,3,4,5].map(i => `<span class="star ${i<=full?'filled':''}">★</span>`).join('')}
    ${count ? `<span style="font-size:11px;color:#666;margin-left:4px;">(${count})</span>` : ''}
  </div>`;
}

// ─── Fetch avg rating per product ────────────────────────────
const _ratingCache = {};
async function fetchProductRating(productId) {
  if (_ratingCache[productId] !== undefined) return _ratingCache[productId];
  try {
    const sb = await getSupabase();
    const { data } = await sb.from('reviews').select('rating').eq('product_id', productId).eq('is_approved', true);
    if (data && data.length) {
      const avg = data.reduce((s,r) => s + r.rating, 0) / data.length;
      _ratingCache[productId] = { avg: avg.toFixed(1), count: data.length };
    } else {
      _ratingCache[productId] = null;
    }
  } catch(e) { _ratingCache[productId] = null; }
  return _ratingCache[productId];
}

window.initSearchAutocomplete = initSearchAutocomplete;
window.renderStars = renderStars;
window.fetchProductRating = fetchProductRating;

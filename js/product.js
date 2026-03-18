// js/product.js — Drobnostík v3

let currentProduct = null;
let selectedSize = 'Standard';
let selectedColor = 'black';
let currentView = 'front';

function getProductImageUrl(color, view) {
  // Use custom color images if product has them defined
  if (currentColorImages && currentColorImages[color]) {
    const side = view === 'back' ? 'back' : 'front';
    const customImg = currentColorImages[color][side];
    if (customImg) return customImg;
  }
  // Known product files
  const knownColors = ['black', 'white', 'gray', 'red'];
  const c = knownColors.includes(color) ? color : 'black';
  const v = view === 'back' ? 'back' : 'front';
  // red only has front image
  if (c === 'red' && v === 'back') return `/images/products/pokebowl-red-front.jpg`;
  return `/images/products/pokebowl-${c}-${v}.jpg`;
}

async function loadProductDetail() {
  const main = document.querySelector('main') || document.getElementById('app');
  if (!main) return;

  try {
    // Support URL params: /product?id=1&color=black&size=Standard
  const urlParams = new URLSearchParams(window.location.search);
  const urlId = urlParams.get('id');
  const urlColor = urlParams.get('color');
  const urlSize = urlParams.get('size');
  
  const productId = urlId || sessionStorage.getItem('selectedProductId');
  if (urlId) sessionStorage.setItem('selectedProductId', urlId);
    if (!productId) { goTo('/shop'); return; }

    const sb = await getSupabase();
    const { data: product, error } = await sb.from('products').select('*').eq('id', productId).single();
    if (error || !product) {
      main.innerHTML = '<div style="padding:60px;text-align:center;color:#999;">Produkt nenalezen. <button class="btn-primary" onclick="goTo(\'/shop\')">Zpět na obchod</button></div>';
      return;
    }

    currentProduct = product;
    selectedColor = product.default_color || 'black';
    selectedSize = 'Standard';

    // Track recently viewed
    if (typeof RecentlyViewed !== 'undefined') RecentlyViewed.add(productId);
    // Update meta tags
    if (typeof updateMetaTags !== 'undefined') updateMetaTags({
      title: product.name,
      description: product.description || 'Prémiový 3D tisknutý Pokeball od Drobnostík',
      image: 'https://drobnostik.cz/images/products/pokebowl-' + (product.default_color||'black') + '-front.jpg',
      url: window.location.href
    });
    // Inject structured data
    if (typeof injectProductSchema !== 'undefined') injectProductSchema(product);

    // Fill data
    const set = (id, val) => { const el = document.getElementById(id); if (el) el.textContent = val; };
    set('product-name', product.name);
    set('product-category', product.category || 'Pokebally');
    set('product-desc', product.description || '');

    // Image
    const img = document.getElementById('product-image');
    if (img) img.src = getProductImageUrl(selectedColor, 'front');

    // Stock
    const stockEl = document.getElementById('stock-status');
    if (stockEl) {
      if (product.stock_quantity > 0) {
        stockEl.innerHTML = `<span class="text-success">✓ Na skladě (${product.stock_quantity} ks)</span>`;
      } else {
        stockEl.innerHTML = '<span class="text-danger">✗ Dočasně vyprodáno</span>';
      }
    }

    // Price
    updatePrice();

    // Image zoom
    if (typeof initImageZoom === 'function') {
      setTimeout(() => initImageZoom('product-image'), 200);
    }
    
    // Stock urgency
    if (typeof getStockUrgency === 'function' && stockEl) {
      const urgency = getStockUrgency(product.stock_quantity || 0);
      stockEl.innerHTML = `<span style="color:${urgency.color};font-weight:600;">${urgency.label}</span>`;
    }
    
    // Add to recently viewed
    if (typeof RecentlyViewed !== 'undefined') {
      RecentlyViewed.add({ id: product.id, name: product.name, price: product.price_standard || product.price_small, image: getProductImageUrl(selectedColor, 'front') });
    }
    
    // Track achievement
    if (typeof Achievements !== 'undefined' && typeof Achievements.check === 'function') {
      Achievements.check('first_view');
    }

    // Render dynamic color buttons from product data
    const defaultHex = { black:'#111', white:'#f0f0f0', gray:'#888', red:'#c22', blue:'#228', green:'#282', yellow:'#cc0', purple:'#828', orange:'#c60' };
    const colorList = product.colors || ['black'];
    const colorImgData = product.color_images || {};

    function renderColorBtns(containerId, activeColor) {
      const container = document.getElementById(containerId);
      if (!container) return;
      const active = activeColor || selectedColor;
      container.innerHTML = colorList.map(colorVal => {
        const meta = colorImgData[colorVal] || {};
        const name = meta.name || colorVal;
        const hex  = meta.hex  || defaultHex[colorVal] || '#666';
        const isSel = colorVal === active;
        return `<button
          data-color="${escapeHtml(colorVal)}"
          onclick="selectColor('${escapeHtml(colorVal)}')"
          aria-label="Barva: ${escapeHtml(name)}"
          title="${escapeHtml(name)}"
          style="width:28px;height:28px;border-radius:50%;background:${hex};border:2px solid ${isSel ? '#c8a96a' : 'rgba(255,255,255,0.2)'};cursor:pointer;transition:all 0.2s;display:flex;align-items:center;justify-content:center;font-size:10px;color:${isSel ? '#fff' : 'transparent'};box-shadow:${isSel ? '0 0 0 3px rgba(200,169,106,0.3)' : 'none'};">
          <span class="sr-only">${escapeHtml(name)}</span>${isSel ? '✓' : ''}
        </button>`;
      }).join('');
    }

    renderColorBtns('color-buttons-overlay');
    renderColorBtns('color-buttons-detail');
    window._renderColorBtns = renderColorBtns;

    // Reviews
    const { data: reviews } = await sb.from('reviews').select('*').eq('product_id', productId).order('created_at', { ascending: false });
    renderReviews(reviews || []);

    // Customers also bought
    if (typeof loadAlsoBought === 'function') setTimeout(loadAlsoBought, 300);

    // Related products
    const { data: related } = await sb.from('products').select('*').eq('category', product.category).neq('id', productId).limit(3);
    const relatedEl = document.getElementById('related-products');
    if (relatedEl && related?.length) {
      relatedEl.innerHTML = related.map(p => renderProductCard(p)).join('');
    }

  } catch (e) {
    console.error('Product detail error:', e);
    showToast('Chyba při načítání produktu');
  }
}

function renderReviews(reviews) {
  const el = document.getElementById('reviews-list');
  if (!el) return;

  if (!reviews.length) {
    el.innerHTML = '<div style="color:#777;font-size:14px;padding:16px 0;">Zatím žádné recenze. Buďte první!</div>';
    return;
  }

  const avgRating = reviews.reduce((s, r) => s + r.rating, 0) / reviews.length;
  const stars = (r) => '★'.repeat(r) + '☆'.repeat(5 - r);

  el.innerHTML = `
    <div style="display:flex;align-items:center;gap:16px;margin-bottom:24px;padding:16px;background:rgba(200,169,106,0.05);border-radius:8px;border:1px solid rgba(200,169,106,0.1);">
      <div style="font-size:40px;font-weight:700;color:#c8a96a;">${avgRating.toFixed(1)}</div>
      <div>
        <div style="color:#c8a96a;font-size:20px;">${stars(Math.round(avgRating))}</div>
        <div style="color:#999;font-size:13px;">${reviews.length} recenzí</div>
      </div>
    </div>
    ${reviews.map(r => `
      <div style="padding:16px 0;border-bottom:1px solid rgba(255,255,255,0.06);">
        <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:8px;">
          <div style="display:flex;align-items:center;gap:10px;">
            <div style="width:32px;height:32px;background:#c8a96a;border-radius:50%;display:flex;align-items:center;justify-content:center;font-weight:700;color:#000;font-size:13px;">${(r.author_name || 'A')[0].toUpperCase()}</div>
            <span style="font-weight:600;">${escapeHtml(r.author_name || 'Anonymní')}</span>
          </div>
          <div style="display:flex;gap:8px;align-items:center;">
            <span style="color:#c8a96a;">${stars(r.rating)}</span>
            <span style="color:#555;font-size:12px;">${formatDate(r.created_at)}</span>
          </div>
        </div>
        <p style="color:#ccc;font-size:14px;line-height:1.7;margin:0;">${escapeHtml(r.text || '')}</p>
      </div>`).join('')}`;
}

function updatePrice() {
  if (!currentProduct) return;
  const prices = {
    'Small': currentProduct.price_small,
    'Standard': currentProduct.price_standard,
    'Maxi': currentProduct.price_maxi
  };
  const price = prices[selectedSize] || currentProduct.price_standard || currentProduct.price_small || 0;
  const el = document.getElementById('product-price');
  if (el) el.textContent = formatPrice(price) + ' Kč';
  if (typeof showInstallmentInfo === 'function' && price >= 300) showInstallmentInfo(price);
}

function selectSize(size) {
  selectedSize = size;
  document.querySelectorAll('[data-size]').forEach(btn => {
    const isSelected = btn.dataset.size === size;
    btn.style.borderColor = isSelected ? '#c8a96a' : '#333';
    btn.style.background = isSelected ? 'rgba(200,169,106,0.1)' : 'transparent';
    btn.textContent = btn.dataset.size + (isSelected ? ' ✓' : '');
  });
  updatePrice();
}

function selectColor(color) {
  selectedColor = color;
  const img = document.getElementById('product-image');
  if (img) {
    img.style.opacity = '0';
    setTimeout(() => {
      img.src = getProductImageUrl(color, currentView);
      img.style.opacity = '1';
    }, 200);
  }
  // Re-render dynamic color buttons with new selection highlighted
  if (typeof window._renderColorBtns === 'function') {
    window._renderColorBtns('color-buttons-overlay', color);
    window._renderColorBtns('color-buttons-detail', color);
  } else {
    document.querySelectorAll('[data-color]').forEach(btn => {
      const sel = btn.dataset.color === color;
      btn.style.borderColor = sel ? '#c8a96a' : 'rgba(255,255,255,0.2)';
      btn.style.boxShadow   = sel ? '0 0 0 3px rgba(200,169,106,0.3)' : 'none';
      btn.innerHTML = `<span class="sr-only">${btn.title||btn.dataset.color}</span>${sel ? '✓' : ''}`;
    });
  }
}

function changeProductImage(view) {
  currentView = view;
  const img = document.getElementById('product-image');
  if (img) {
    img.style.opacity = '0';
    setTimeout(() => { img.src = getProductImageUrl(selectedColor, view); img.style.opacity = '1'; }, 150);
  }
}

function addProductToCart() {
  if (!currentProduct) return;
  const qty = parseInt(document.getElementById('quantity')?.value || '1');
  if (qty < 1) { showToast('Neplatné množství'); return; }

  const prices = {
    'Small': currentProduct.price_small,
    'Standard': currentProduct.price_standard,
    'Maxi': currentProduct.price_maxi
  };
  const price = prices[selectedSize] || currentProduct.price_standard || 0;

  if (typeof Analytics !== 'undefined') Analytics.track('add_to_cart', { id: currentProduct.id, name: currentProduct.name });
  if (typeof Achievements !== 'undefined') { /* check achievement later */ }
  Cart.add({
    id: currentProduct.id,
    name: currentProduct.name + ' (' + selectedSize + ')',
    price: price,
    color: selectedColor,
    size: selectedSize,
    image: getProductImageUrl(selectedColor, 'front'),
    quantity: qty
  });
}

async function submitReview() {
  const name = document.getElementById('review-name')?.value?.trim();
  const text = document.getElementById('review-text')?.value?.trim();
  const rating = parseInt(document.getElementById('review-rating')?.value || '5');

  if (!name || !text) { showToast('Vyplňte jméno a text recenze'); return; }
  if (!currentProduct) return;

  try {
    const sb = await getSupabase();
    await sb.from('reviews').insert([{
      product_id: currentProduct.id,
      author_name: name,
      text: text,
      rating: rating
    }]);
    showToast('✓ Recenze odeslána – čeká na schválení');
    if (document.getElementById('review-name')) document.getElementById('review-name').value = '';
    if (document.getElementById('review-text')) document.getElementById('review-text').value = '';
  } catch (e) {
    showToast('Chyba: ' + e.message);
  }
}

window.loadProductDetail = loadProductDetail;
window.selectSize = selectSize;
// Make color_images accessible globally for image switching
let currentColorImages = null;

window.selectColor = selectColor;
window.setProductColorImages = function(colorImages) { currentColorImages = colorImages; };
window.changeProductImage = changeProductImage;
window.addProductToCart = addProductToCart;
window.updatePrice = updatePrice;
window.submitReview = submitReview;

// ─── Product share ────────────────────────────────────────────
async function shareCurrentProduct() {
  if (!currentProduct) return;
  const url = `${window.location.origin}/product?id=${currentProduct.id}`;
  await shareProduct(currentProduct.name, url);
}

// ─── Recently viewed ──────────────────────────────────────────
function renderRecentlyViewed() {
  if (typeof RecentlyViewed === 'undefined') return;
  const items = RecentlyViewed.get().filter(p => p && p.id && (!currentProduct || p.id !== currentProduct.id)).slice(0, 4);
  const el = document.getElementById('recently-viewed-section');
  if (!el || !items.length) return;

  el.innerHTML = `
    <div class="recently-viewed">
      <h3 style="font-size:18px;font-weight:700;margin-bottom:20px;">🕐 Nedávno zobrazené</h3>
      <div style="display:grid;grid-template-columns:repeat(auto-fill,minmax(160px,1fr));gap:14px;">
        ${items.map(p => `
          <div onclick="sessionStorage.setItem('selectedProductId','${p.id}');goTo('/product')" style="cursor:pointer;background:#1a1a1a;border:1px solid #2a2a2a;border-radius:8px;overflow:hidden;transition:all 0.2s;" onmouseover="this.style.borderColor='#c8a96a'" onmouseout="this.style.borderColor='#2a2a2a'">
            <img src="/images/products/pokebowl-${p.color||'black'}-front.jpg" style="width:100%;aspect-ratio:1;object-fit:cover;" onerror="this.src='/images/products/pokebowl-black-front.jpg'" alt="${escapeHtml(p.name)}">
            <div style="padding:10px;">
              <div style="font-size:13px;font-weight:600;color:#ccc;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;">${escapeHtml(p.name)}</div>
              <div style="font-size:12px;color:#c8a96a;margin-top:3px;">${formatPrice(p.price)} Kč</div>
            </div>
          </div>`).join('')}
      </div>
    </div>`;
}

// Save to recently viewed when product loads
const _origLoadProductDetail = loadProductDetail;
window.loadProductDetail = async function() {
  await _origLoadProductDetail();
  setTimeout(() => {
    if (currentProduct) {
      RecentlyViewed.add({
        id: currentProduct.id,
        name: currentProduct.name,
        price: currentProduct.price_standard || currentProduct.price_small || 0,
        color: currentProduct.default_color || 'black'
      });
      renderRecentlyViewed();
      // Add breadcrumbs
      const breadcrumbEl = document.getElementById('product-breadcrumb');
      if (breadcrumbEl) {
        breadcrumbEl.innerHTML = renderBreadcrumbs([
          { label: 'Domů', href: '/' },
          { label: 'Obchod', href: '/shop' },
          { label: currentProduct.category || 'Produkty', href: '/shop' },
          { label: currentProduct.name, href: '/product' }
        ]);
      }
    }
  }, 200);
};

window.shareCurrentProduct = shareCurrentProduct;
window.renderRecentlyViewed = renderRecentlyViewed;

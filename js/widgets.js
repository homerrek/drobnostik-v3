// js/widgets.js - Custom widgets & components

// Rating widget
function createRatingWidget(productId, currentRating = 0) {
  let rating = currentRating;
  
  const html = `
    <div data-rating-widget="${productId}" style="display: flex; gap: 4px; cursor: pointer;">
      ${[1,2,3,4,5].map(i => `
        <button 
          data-rating="${i}" 
          onclick="setProductRating(${productId}, ${i})"
          style="background: none; border: none; cursor: pointer; font-size: 20px; opacity: ${i <= rating ? '1' : '0.3'}; transition: all 0.2s;"
          onmouseover="this.style.transform='scale(1.2)'"
          onmouseout="this.style.transform='scale(1)'"
        >⭐</button>
      `).join('')}
    </div>
  `;
  
  return html;
}

function setProductRating(productId, rating) {
  const widget = document.querySelector(`[data-rating-widget="${productId}"]`);
  if (!widget) return;
  
  widget.querySelectorAll('button').forEach((btn, i) => {
    btn.style.opacity = (i + 1) <= rating ? '1' : '0.3';
  });
  
  showToast(`✓ Hodnocení: ${rating} hvězd`);
}

// Wishlist heart widget
function createWishlistWidget(productId, isWishlisted = false) {
  return `
    <button 
      data-wishlist-btn="${productId}"
      onclick="toggleWishlist(${productId})"
      style="background: none; border: none; cursor: pointer; font-size: 20px; color: ${isWishlisted ? '#f44' : '#666'}; transition: all 0.3s;"
      onmouseover="this.style.transform='scale(1.2)'"
      onmouseout="this.style.transform='scale(1)'"
      title="Přidat do oblíbených"
    >❤️</button>
  `;
}

function toggleWishlist(productId) {
  let wishlist = JSON.parse(localStorage.getItem('wishlist') || '[]');
  const btn = document.querySelector(`[data-wishlist-btn="${productId}"]`);
  
  if (wishlist.includes(productId)) {
    wishlist = wishlist.filter(id => id !== productId);
    btn.style.color = '#666';
    showToast('❤️ Odebráno z oblíbených');
  } else {
    wishlist.push(productId);
    btn.style.color = '#f44';
    showToast('❤️ Přidáno do oblíbených');
  }
  
  localStorage.setItem('wishlist', JSON.stringify(wishlist));
}

// Stock indicator
function createStockIndicator(stock) {
  const status = stock > 5 ? 'dostupný' : stock > 0 ? 'poslední kusy' : 'vyprodáno';
  const color = stock > 5 ? '#4f4' : stock > 0 ? '#fa0' : '#f44';
  
  return `
    <div style="display: flex; align-items: center; gap: 8px;">
      <div style="width: 8px; height: 8px; border-radius: 50%; background: ${color};"></div>
      <span style="font-size: 12px; color: ${color}; font-weight: 600;">
        ${status} ${stock > 0 ? `(${stock} ks)` : ''}
      </span>
    </div>
  `;
}

// Badge widget
function createBadge(text, type = 'default') {
  const colors = {
    default: { bg: '#c8a96a', text: '#000' },
    success: { bg: '#4f4', text: '#000' },
    warning: { bg: '#fa0', text: '#000' },
    danger: { bg: '#f44', text: '#fff' },
    info: { bg: '#4af', text: '#000' }
  };
  
  const style = colors[type] || colors.default;
  
  return `
    <span style="background: ${style.bg}; color: ${style.text}; padding: 4px 12px; border-radius: 20px; font-size: 11px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px;">
      ${text}
    </span>
  `;
}

// Loading skeleton
function createSkeleton(width = '100%', height = '20px') {
  return `
    <div style="background: linear-gradient(90deg, #333 25%, #444 50%, #333 75%); background-size: 200% 100%; animation: shimmer 1.5s infinite; width: ${width}; height: ${height}; border-radius: 4px;">
    </div>
  `;
}

// Price comparison widget
function createPriceWidget(price_small, price_standard, price_maxi) {
  return `
    <div style="display: flex; gap: 12px; flex-wrap: wrap;">
      <div style="text-align: center;">
        <div style="font-size: 12px; color: #999;">Small</div>
        <div style="font-size: 16px; font-weight: 700; color: #c8a96a;">${price_small} Kč</div>
      </div>
      <div style="text-align: center;">
        <div style="font-size: 12px; color: #999;">Standard</div>
        <div style="font-size: 16px; font-weight: 700; color: #c8a96a;">${price_standard} Kč</div>
      </div>
      <div style="text-align: center;">
        <div style="font-size: 12px; color: #999;">Maxi</div>
        <div style="font-size: 16px; font-weight: 700; color: #c8a96a;">${price_maxi} Kč</div>
      </div>
    </div>
  `;
}

// Export
window.createRatingWidget = createRatingWidget;
window.setProductRating = setProductRating;
window.createWishlistWidget = createWishlistWidget;
window.toggleWishlist = toggleWishlist;
window.createStockIndicator = createStockIndicator;
window.createBadge = createBadge;
window.createSkeleton = createSkeleton;
window.createPriceWidget = createPriceWidget;

// js/cart.js — Drobnostík v3

const Cart = {
  getItems() { return Storage.get('cart', []); },

  add(product) {
    const items = this.getItems();
    const existing = items.find(i => i.id === product.id && i.color === product.color && i.size === product.size);
    if (existing) {
      existing.quantity += (product.quantity || 1);
    } else {
      items.push({
        id: product.id,
        name: product.name,
        price: product.price,
        color: product.color || 'black',
        size: product.size || 'Standard',
        image: product.image || '/images/products/pokebowl-black-front.jpg',
        quantity: product.quantity || 1
      });
    }
    Storage.set('cart', items);
    this.updateBadge();
    showToast(`✓ ${product.name} přidáno do košíku`);
    // Animate cart button
    const cartBtn = document.querySelector('.btn-cart');
    if (cartBtn) {
      cartBtn.style.transform = 'scale(1.25)';
      cartBtn.style.boxShadow = '0 0 20px rgba(200,169,106,0.6)';
      setTimeout(() => {
        cartBtn.style.transform = '';
        cartBtn.style.boxShadow = '';
      }, 350);
    }
  },

  remove(id, color, size) {
    let items = this.getItems();
    items = items.filter(i => !(i.id == id && i.color === color && (i.size === size || !size)));
    Storage.set('cart', items);
    this.updateBadge();
  },

  updateQty(id, color, qty, size) {
    const items = this.getItems();
    const item = items.find(i => i.id == id && i.color === color && (i.size === size || !size));
    if (item) {
      const q = parseInt(qty);
      if (q <= 0) {
        this.remove(id, color, size);
        return;
      }
      item.quantity = q;
      Storage.set('cart', items);
    }
    this.updateBadge();
  },

  clear() {
    Storage.set('cart', []);
    this.updateBadge();
  },

  updateBadge() {
    const items = this.getItems();
    const total = items.reduce((s, i) => s + i.quantity, 0);
    document.querySelectorAll('.cart-count').forEach(el => {
      el.textContent = total;
      el.style.display = total > 0 ? 'flex' : 'none';
    });
    if (typeof updateTabTitle === 'function') updateTabTitle();
    if (typeof updateMiniCart === 'function') updateMiniCart();
  },

  getTotal() {
    return this.getItems().reduce((s, i) => s + i.price * i.quantity, 0);
  },

  getCount() {
    return this.getItems().reduce((s, i) => s + i.quantity, 0);
  }
};

// Wishlist helpers (centralized)
const Wishlist = {
  getItems() {
    try { return JSON.parse(localStorage.getItem('wishlist') || '[]'); } catch { return []; }
  },
  add(id) {
    const list = this.getItems();
    if (!list.includes(id)) {
      list.push(id);
      localStorage.setItem('wishlist', JSON.stringify(list));
    }
    this.updateBadge();
  },
  remove(id) {
    const list = this.getItems().filter(i => i != id);
    localStorage.setItem('wishlist', JSON.stringify(list));
    this.updateBadge();
  },
  toggle(id) {
    if (this.has(id)) { this.remove(id); showToast('Odebráno z oblíbených'); }
    else { this.add(id); showToast('❤️ Přidáno do oblíbených'); }
  },
  has(id) { return this.getItems().includes(id) || this.getItems().includes(String(id)); },
  updateBadge() {
    const count = this.getItems().length;
    document.querySelectorAll('.wishlist-count').forEach(el => el.textContent = count);
  }
};

document.addEventListener('DOMContentLoaded', () => {
  Cart.updateBadge();
  Wishlist.updateBadge();
});

window.Cart = Cart;
window.Wishlist = Wishlist;

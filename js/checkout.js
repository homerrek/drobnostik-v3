// js/checkout.js — Drobnostík v3

let appliedCoupon = null;
let giftWrapAdded = false;

// ─── Load checkout summary ────────────────────────────────────
function loadCheckout() {
  const items = Cart.getItems();
  const subtotal = Cart.getTotal();

  renderSummary('standard');

  // Shipping select dropdown
  const shippingEl = document.getElementById('shipping');
  if (shippingEl) {
    shippingEl.addEventListener('change', (e) => {
      renderSummary(e.target.value);
      // Show delivery estimate
      if (typeof getDeliveryEstimate === 'function') {
        const dateEl = document.getElementById('delivery-date');
        if (dateEl) dateEl.textContent = getDeliveryEstimate(e.target.value);
      }
    });
  }

  // Show initial delivery estimate
  if (typeof getDeliveryEstimate === 'function') {
    const dateEl = document.getElementById('delivery-date');
    if (dateEl) dateEl.textContent = getDeliveryEstimate('standard');
  }

  // Gift toggle
  const giftChk = document.getElementById('gift-wrap');
  if (giftChk) {
    giftChk.addEventListener('change', (e) => {
      giftWrapAdded = e.target.checked;
      const priceEl = document.getElementById('gift-wrap-price');
      if (priceEl) priceEl.style.display = giftWrapAdded ? 'block' : 'none';
      renderSummary(document.getElementById('shipping')?.value || 'standard');
    });
  }
}

function getShippingCost(method) {
  const costs = {
    zasilkovna:       79,
    zasilkovna_home:  119,
    ppl:              129,
    dpd:              139,
    gls:              129,
    ceska_posta:      99,
    ceska_posta_box:  79,
    dhl_express:      299,
    pickup:           0,
    // Legacy keys
    standard:         99,
    express:          249,
  };
  return costs[method] ?? 99;
}

function getShippingLabel(method) {
  const labels = {
    zasilkovna:       'Zásilkovna — výdejní místo',
    zasilkovna_home:  'Zásilkovna — doručení domů',
    ppl:              'PPL — doručení domů',
    dpd:              'DPD — doručení domů',
    gls:              'GLS — doručení domů',
    ceska_posta:      'Česká pošta — Balík Do ruky',
    ceska_posta_box:  'Česká pošta — Balík Na poštu',
    dhl_express:      'DHL Express',
    pickup:           'Osobní odběr Night City',
    standard:         'Standardní zásilka',
    express:          'Expres doručení',
  };
  return labels[method] || method;
}
window.getShippingLabel = getShippingLabel;

function getDiscount(subtotal) {
  if (!appliedCoupon) return 0;
  if (appliedCoupon.discount_type === 'percent') {
    return Math.round(subtotal * appliedCoupon.discount_value / 100);
  }
  return appliedCoupon.discount_value || 0;
}

function renderSummary(shippingMethod) {
  const items = Cart.getItems();
  const subtotal = Cart.getTotal();
  const shippingCost = getShippingCost(shippingMethod);
  const discount = getDiscount(subtotal);
  const giftCost = giftWrapAdded ? 39 : 0;
  const payMethod = document.getElementById('selected-payment-method')?.value || 'card';
  const codFee = payMethod === 'cod' ? 30 : 0;
  const total = subtotal + shippingCost - discount + giftCost + codFee;

  const summaryEl = document.getElementById('summary');
  if (!summaryEl) return;

  if (!items.length) {
    summaryEl.innerHTML = '<p style="color:#999;text-align:center;padding:20px;">Košík je prázdný</p>';
    return;
  }

  const itemsHtml = items.map(item => `
    <div style="display:flex;justify-content:space-between;margin-bottom:10px;font-size:14px;">
      <span style="color:#ccc;flex:1;min-width:0;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;padding-right:12px;">${escapeHtml(item.name)} <span style="color:#555;">×${item.quantity}</span></span>
      <span style="font-weight:600;white-space:nowrap;">${formatPrice(item.price * item.quantity)} Kč</span>
    </div>`).join('');

  summaryEl.innerHTML = `
    <div style="background:#111;padding:20px;border-radius:8px;border:1px solid #2a2a2a;">
      ${itemsHtml}
      <div style="border-top:1px solid #2a2a2a;margin-top:14px;padding-top:14px;">
        <div style="display:flex;justify-content:space-between;margin-bottom:8px;font-size:14px;color:#999;">
          <span>Mezisoučet</span><span>${formatPrice(subtotal)} Kč</span>
        </div>
        <div style="display:flex;justify-content:space-between;margin-bottom:8px;font-size:14px;color:#999;">
          <span>Doprava (${typeof getShippingLabel === 'function' ? getShippingLabel(shippingMethod).split(' — ')[0] : shippingMethod})</span>
          <span>${shippingCost === 0 ? '<span style=\"color:#4f4;\">Zdarma</span>' : formatPrice(shippingCost) + ' Kč'}</span>
        </div>
        ${giftCost ? `<div style="display:flex;justify-content:space-between;margin-bottom:8px;font-size:14px;color:#999;"><span>🎁 Dárkové balení</span><span>+39 Kč</span></div>` : ''}
        ${codFee ? `<div style="display:flex;justify-content:space-between;margin-bottom:8px;font-size:14px;color:#fa0;"><span>💵 Dobírka</span><span>+${codFee} Kč</span></div>` : ''}
        ${discount > 0 ? `<div style="display:flex;justify-content:space-between;margin-bottom:8px;font-size:14px;color:#4f4;"><span>🎟️ Sleva (${escapeHtml(appliedCoupon?.code||'')})</span><span>-${formatPrice(discount)} Kč</span></div>` : ''}
        <div style="display:flex;justify-content:space-between;padding-top:10px;border-top:1px solid #2a2a2a;font-weight:700;font-size:18px;color:#c8a96a;">
          <span>Celkem</span><span>${formatPrice(total)} Kč</span>
        </div>
      </div>
    </div>`;
}

// ─── Apply coupon ─────────────────────────────────────────────
async function applyCoupon() {
  const codeEl = document.getElementById('coupon-code') || document.getElementById('coupon-input');
  const code = codeEl?.value?.trim().toUpperCase();
  const resultEl = document.getElementById('coupon-result');
  if (!code) { showToast('Zadejte kód kupónu'); return; }

  try {
    const sb = await getSupabase();
    const { data: coupon, error } = await sb.from('coupons')
      .select('*').eq('code', code).eq('is_active', true).single();

    if (error || !coupon) {
      if (resultEl) resultEl.innerHTML = '<span style="color:#f44;">❌ Neplatný nebo vypršelý kód</span>';
      showToast('Neplatný kupón'); return;
    }

    const subtotal = Cart.getTotal();
    if (coupon.min_order && subtotal < coupon.min_order) {
      if (resultEl) resultEl.innerHTML = `<span style="color:#fa0;">⚠️ Min. objednávka ${formatPrice(coupon.min_order)} Kč</span>`;
      return;
    }

    if (coupon.max_uses && (coupon.used_count || 0) >= coupon.max_uses) {
      if (resultEl) resultEl.innerHTML = '<span style="color:#f44;">❌ Kód je vyčerpán</span>';
      return;
    }

    appliedCoupon = coupon;
    const discount = getDiscount(subtotal);
    if (resultEl) resultEl.innerHTML = `<span style="color:#4f4;">✓ Sleva ${coupon.discount_type === 'percent' ? coupon.discount_value + '%' : formatPrice(coupon.discount_value) + ' Kč'} uplatněna!</span>`;
    showToast(`✓ Kupón ${code} uplatněn — sleva ${formatPrice(discount)} Kč`);
    renderSummary(document.getElementById('shipping')?.value || 'standard');

    if (typeof Achievements !== 'undefined') Achievements.check('used_coupon');
  } catch (e) {
    if (resultEl) resultEl.innerHTML = `<span style="color:#f44;">Chyba: ${escapeHtml(e.message)}</span>`;
  }
}

// ─── Odeslat order ─────────────────────────────────────────────
async function submitOrder() {
  const paymentMethod = document.getElementById('selected-payment-method')?.value || 'transfer';

  // Validate card fields if card payment selected
  if (paymentMethod === 'card') {
    if (typeof validateCard === 'function' && !validateCard()) {
      showToast('❌ Zkontrolujte údaje karty');
      document.getElementById('card-number')?.scrollIntoView({ behavior: 'smooth', block: 'center' });
      return;
    }
    // Store last 4 digits for order display
    const num = (document.getElementById('card-number')?.value || '').replace(/[^0-9]/g,'');
    window._cardLast4 = num.slice(-4);
  }

  return _doOdeslatOrder(paymentMethod);
}

async function _doOdeslatOrder(paymentMethod) {
  const required = ['name','email','street','city','postal'];
  const values = {};
  let valid = true;

  required.forEach(id => {
    const el = document.getElementById(id);
    if (el) {
      values[id] = el.value.trim();
      el.style.borderColor = values[id] ? '' : '#f44';
      if (!values[id]) valid = false;
    }
  });

  if (!valid) { showToast('⚠️ Vyplňte všechna povinná pole'); return; }
  const emailEl = document.getElementById('email');
  if (emailEl && !emailEl.value.includes('@')) {
    emailEl.style.borderColor = '#f44';
    showToast('⚠️ Neplatný email'); return;
  }

  const items = Cart.getItems();
  if (!items.length) { showToast('Košík je prázdný'); return; }

  const shipping = document.getElementById('shipping')?.value || 'standard';
  const subtotal = Cart.getTotal();
  const shippingCost = getShippingCost(shipping);
  const discount = getDiscount(subtotal);
  const giftCost = giftWrapAdded ? 39 : 0;
  const total = subtotal + shippingCost - discount + giftCost;

  const btn = document.querySelector('[onclick="submitOrder()"]');
  if (btn) { btn.disabled = true; btn.textContent = 'Odesílám...'; }

  try {
    const sb = await getSupabase();
    const orderNum = 'ORD-' + Date.now();
    const isGift = document.getElementById('is-gift')?.checked || false;
    const giftMsg = document.getElementById('gift-message')?.value || '';
    const charityRoundup = document.getElementById('charity-roundup')?.checked || false;

    const { data: order, error } = await sb.from('orders').insert([{
      order_number: orderNum,
      customer_name: values.name,
      customer_email: values.email,
      customer_phone: document.getElementById('phone')?.value || '',
      customer_street: values.street,
      customer_city: values.city,
      customer_postal: values.postal,
      shipping_method: shipping,
      payment_method: paymentMethod || 'transfer',
      stripe_payment_method_id: paymentMethod === 'card' ? (window._stripePaymentMethodId || null) : null,
      subtotal_amount: subtotal,
      shipping_cost: shippingCost,
      discount_amount: discount,
      coupon_code: appliedCoupon?.code || null,
      total_amount: total,
      status: 'pending',
      note: `${document.getElementById('note')?.value || ''}${isGift ? ' [DÁREK: ' + giftMsg + ']' : ''}${charityRoundup ? ' [CHARITY]' : ''}`
    }]).select();

    if (error) throw error;

    if (order?.[0]) {
      const orderId = order[0].id;
      await sb.from('order_items').insert(
        items.map(item => ({
          order_id: orderId, product_id: item.id, product_name: item.name,
          color: item.color, size: item.size || 'Standard',
          quantity: item.quantity, unit_price: item.price, total_price: item.price * item.quantity
        }))
      );

      // Update coupon usage
      if (appliedCoupon) {
        await sb.from('coupons').update({ used_count: (appliedCoupon.used_count || 0) + 1 }).eq('id', appliedCoupon.id);
      }

      // Loyalty points
      const loyaltyPoints = Math.floor(total / 10);
      const current = parseInt(localStorage.getItem('loyalty-points') || '0');
      localStorage.setItem('loyalty-points', current + loyaltyPoints);

      if (typeof Achievements !== 'undefined' && typeof Achievements.check === 'function') {
        Achievements.check('first_order');
        const orderCount = parseInt(localStorage.getItem('order-count') || '0') + 1;
        localStorage.setItem('order-count', orderCount);
        if (orderCount >= 5) Achievements.check('loyal_customer');
      }

      Cart.clear();
      appliedCoupon = null;
      giftWrapAdded = false;
      Storage.set('last-order', orderNum);
      goTo('/success');
    }
  } catch (e) {
    showToast('❌ Chyba: ' + e.message);
    if (btn) { btn.disabled = false; btn.textContent = 'Potvrdit objednávku'; }
  }
}

window.loadCheckout = loadCheckout;
window.submitOrder = submitOrder;
window.applyCoupon = applyCoupon;

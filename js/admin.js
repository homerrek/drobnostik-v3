
// ── České překlady stavů ──────────────────────────────────
function statusCZ(status) {
  return {
    // Objednávky
    pending:    'Čeká na zpracování',
    processing: 'Zpracovává se',
    printing:   'Probíhá tisk',
    shipped:    'Odesláno',
    delivered:  'Doručeno',
    cancelled:  'Zrušeno',
    // Tickety
    open:       'Otevřený',
    in_progress:'Řeší se',
    resolved:   'Vyřešený',
    closed:     'Uzavřený',
    // Blog
    published:  'Publikovaný',
    draft:      'Koncept',
    // Affiliate
    approved:   'Schválený',
    rejected:   'Zamítnutý',
  }[status] || status;
}
window.statusCZ = statusCZ;
// js/admin.js — Drobnostík v3

function adminLogout() {
  sessionStorage.removeItem('admin-auth');
  showToast('Odhlášení úspěšné');
  goTo('/');
}

// Admin sidebar helper — highlight current page
function highlightAdminNav() {
  const path = window.location.pathname;
  document.querySelectorAll('.admin-sidebar a').forEach(a => {
    const href = a.getAttribute('href');
    a.classList.toggle('active', href === path);
  });
}

// ─── Products ─────────────────────────────────────────────────────
async function loadAdminProducts() {
  if (!checkAdminAuth()) return;
  const container = document.getElementById('admin-products-list');
  if (!container) return;
  container.innerHTML = '<div class="loading-spinner"></div>';

  try {
    const sb = await getSupabase();
    const { data: products, error } = await sb.from('products').select('*').order('created_at', { ascending: false });
    if (error) throw error;

    if (!products?.length) {
      container.innerHTML = '<div style="color:#666;text-align:center;padding:40px;">Žádné produkty</div>';
      return;
    }

    container.innerHTML = `
      <table class="data-table">
        <thead><tr><th>Název</th><th>Kategorie</th><th>Cena od</th><th>Sklad</th><th>Aktivní</th><th>Akce</th></tr></thead>
        <tbody>${products.map(p => `
          <tr>
            <td style="font-weight:600;">${escapeHtml(p.name)}</td>
            <td style="color:#777;">${escapeHtml(p.category||'—')}</td>
            <td style="color:#c8a96a;font-weight:600;">${formatPrice(p.price_small||p.price_standard||0)} Kč</td>
            <td><span style="color:${(p.stock_quantity||0) <= 5 ? '#f44' : '#4f4'};font-weight:600;">${p.stock_quantity||0}</span></td>
            <td><span class="badge ${p.is_active ? 'badge-success' : 'badge-warning'}">${p.is_active ? 'Aktivní' : 'Skrytý'}</span></td>
            <td>
              <div style="display:flex;gap:4px;margin-bottom:6px;flex-wrap:wrap;">
                ${(p.colors||['black']).map(c => {
                  const hex = p.color_images?.[c]?.hex || { black:'#111', white:'#eee', gray:'#888', red:'#c00', blue:'#00c', green:'#0a0' }[c] || '#666';
                  return `<span title="${escapeHtml(p.color_images?.[c]?.name||c)}" style="width:16px;height:16px;border-radius:50%;background:${hex};border:1px solid rgba(255,255,255,0.2);display:inline-block;cursor:help;"></span>`;
                }).join('')}
              </div>
              <button onclick="editProduct(${p.id})" style="background:rgba(200,169,106,0.15);color:#c8a96a;border:none;padding:6px 12px;border-radius:4px;cursor:pointer;font-size:12px;margin-right:6px;">✏️ Upravit</button>
              <button onclick="deleteProduct(${p.id},'${escapeHtml(p.name)}')" style="background:rgba(244,68,68,0.15);color:#f44;border:none;padding:6px 12px;border-radius:4px;cursor:pointer;font-size:12px;">🗑️ Smazat</button>
            </td>
          </tr>`).join('')}
        </tbody>
      </table>`;
  } catch (e) {
    container.innerHTML = `<div style="color:#f44;padding:20px;">Chyba: ${e.message}</div>`;
  }
}

async function createProduct() {
  const name = document.getElementById('new-name')?.value?.trim();
  if (!name) { showToast('Název produktu je povinný'); return; }

  // Collect colors
  const colors = typeof collectColors === 'function' ? collectColors('new') : [];
  const colorValues = colors.map(c => c.value).filter(Boolean);
  const defaultColor = colorValues[0] || 'black';

  // Build color images map { black: { front: '...', back: '...' } }
  const colorImages = {};
  colors.forEach(c => {
    if (c.value) colorImages[c.value] = { front: c.front_image || '', back: c.back_image || '', name: c.name || c.value, hex: c.hex || '' };
  });

  try {
    const sb = await getSupabase();
    const { error } = await sb.from('products').insert([{
      name,
      category:       document.getElementById('new-category')?.value?.trim() || 'Pokebally',
      sku:            document.getElementById('new-sku')?.value?.trim() || null,
      description:    document.getElementById('new-description')?.value?.trim() || '',
      price_small:    parseFloat(document.getElementById('new-price_small')?.value)    || null,
      price_standard: parseFloat(document.getElementById('new-price_standard')?.value) || null,
      price_maxi:     parseFloat(document.getElementById('new-price_maxi')?.value)     || null,
      sale_price:     parseFloat(document.getElementById('new-sale_price')?.value)     || null,
      stock_quantity: parseInt(document.getElementById('new-stock_quantity')?.value)   || 0,
      colors:         colorValues.length ? colorValues : ['black'],
      default_color:  defaultColor,
      color_images:   Object.keys(colorImages).length ? colorImages : null,
      is_active:      document.getElementById('new-is_active')?.checked ?? true,
      is_featured:    document.getElementById('new-is_featured')?.checked ?? false,
      is_new:         document.getElementById('new-is_new')?.checked ?? false,
    }]);
    if (error) throw error;
    showToast('✓ Produkt vytvořen');
    if(typeof AuditLog!=='undefined') AuditLog.add('Produkt vytvořen', name);
    document.getElementById('new-product-form').style.display = 'none';
    loadAdminProducts();
  } catch (e) { showToast('Chyba: ' + e.message); }
}

async function editProduct(id) {
  const sb = await getSupabase();
  const { data: p } = await sb.from('products').select('*').eq('id', id).single();
  if (!p) return;

  // Build existing colors array for the editor
  const existingColors = [];
  const colorList = p.colors || ['black'];
  const colorImages = p.color_images || {};
  colorList.forEach((colorVal, i) => {
    const imgData = colorImages[colorVal] || {};
    existingColors.push({
      value: colorVal,
      name:  imgData.name || colorVal,
      hex:   imgData.hex  || '',
      front_image: imgData.front || `/images/products/pokebowl-${colorVal}-front.jpg`,
      back_image:  imgData.back  || `/images/products/pokebowl-${colorVal}-back.jpg`,
    });
  });

  const modal = document.createElement('div');
  modal.style.cssText = 'position:fixed;inset:0;background:rgba(0,0,0,0.85);z-index:1000;display:flex;align-items:center;justify-content:center;padding:20px;overflow-y:auto;';
  modal.onclick = e => { if(e.target===modal) modal.remove(); };
  modal.innerHTML = `
    <div style="background:#1a1a1a;border:1px solid #333;border-radius:12px;padding:28px;width:100%;max-width:660px;max-height:92vh;overflow-y:auto;">
      <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:20px;">
        <h2 style="font-size:18px;font-weight:700;">✏️ Upravit produkt</h2>
        <button onclick="this.closest('[style*=position]').remove()" style="background:none;border:none;color:#777;font-size:22px;cursor:pointer;" aria-label="Zavřít">✕</button>
      </div>
      <div style="display:flex;flex-direction:column;gap:12px;">
        <div style="display:grid;grid-template-columns:1fr 1fr;gap:10px;">
          <div><label>Název *</label><input id="edit-name" value="${escapeHtml(p.name)}" style="width:100%;"></div>
          <div><label>Kategorie</label><input id="edit-category" value="${escapeHtml(p.category||'')}" style="width:100%;"></div>
        </div>
        <div><label>Popis</label><textarea id="edit-description" rows="2" style="width:100%;">${escapeHtml(p.description||'')}</textarea></div>
        <div style="display:grid;grid-template-columns:1fr 1fr 1fr;gap:10px;">
          <div><label>Small (Kč)</label><input id="edit-small" type="number" value="${p.price_small||''}" style="width:100%;"></div>
          <div><label>Standard (Kč)</label><input id="edit-standard" type="number" value="${p.price_standard||''}" style="width:100%;"></div>
          <div><label>Maxi (Kč)</label><input id="edit-maxi" type="number" value="${p.price_maxi||''}" style="width:100%;"></div>
        </div>
        <div style="display:grid;grid-template-columns:1fr 1fr;gap:10px;">
          <div><label>Výprodejní cena (Kč)</label><input id="edit-sale" type="number" value="${p.sale_price||''}" placeholder="Ponechat prázdné" style="width:100%;"></div>
          <div><label>Sklad (ks)</label><input id="edit-stock" type="number" value="${p.stock_quantity||0}" style="width:100%;"></div>
        </div>
        <div style="display:flex;gap:16px;flex-wrap:wrap;">
          <label style="display:flex;align-items:center;gap:8px;cursor:pointer;margin:0;"><input id="edit-active" type="checkbox" ${p.is_active?'checked':''} style="width:auto;accent-color:#c8a96a;"> Aktivní</label>
          <label style="display:flex;align-items:center;gap:8px;cursor:pointer;margin:0;"><input id="edit-featured" type="checkbox" ${p.is_featured?'checked':''} style="width:auto;accent-color:#c8a96a;"> Doporučený</label>
          <label style="display:flex;align-items:center;gap:8px;cursor:pointer;margin:0;"><input id="edit-isnew" type="checkbox" ${p.is_new?'checked':''} style="width:auto;accent-color:#c8a96a;"> Novinka</label>
        </div>

        <!-- Colors section -->
        <div style="border-top:1px solid #2a2a2a;padding-top:14px;margin-top:4px;">
          <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:10px;">
            <label style="margin:0;font-weight:600;">🎨 Barvy a obrázky</label>
            <div style="display:flex;align-items:center;gap:8px;">
              <span style="font-size:13px;color:#777;">Počet barev:</span>
<input type="number" id="edit-color-count" value="${colorList.length}" min="1" max="50"
                style="width:70px;padding:5px 10px;border:1px solid #333;border-radius:5px;background:#0a0a0a;color:#fff;font-size:13px;text-align:center;"
                onchange="renderColorInputs('edit', this.value, _editColors)"
                oninput="renderColorInputs('edit', this.value, _editColors)">
            </div>
          </div>
          <div id="edit-color-inputs" style="display:grid;grid-template-columns:repeat(auto-fill,minmax(280px,1fr));gap:10px;"></div>
        </div>
      </div>
      <div style="display:flex;gap:10px;margin-top:20px;">
        <button onclick="saveProduct(${p.id})" class="btn-primary" style="flex:1;padding:11px;">💾 Uložit změny</button>
        <button onclick="this.closest('[style*=position]').remove()" class="btn-secondary" style="padding:11px 16px;">Zrušit</button>
      </div>
    </div>`;
  document.body.appendChild(modal);
  window._editModal = modal;
  window._editColors = existingColors;

  // Render color inputs with existing data
  setTimeout(() => {
    if (typeof renderColorInputs === 'function') {
      renderColorInputs('edit', colorList.length, existingColors);
    }
  }, 50);
}

async function saveProduct(id) {
  const name = document.getElementById('edit-name')?.value?.trim();
  if (!name) { showToast('Název je povinný'); return; }

  // Collect color data
  const colors = typeof collectColors === 'function' ? collectColors('edit') : [];
  const colorValues = colors.map(c => c.value).filter(Boolean);
  const colorImages = {};
  colors.forEach(c => {
    if (c.value) colorImages[c.value] = { front: c.front_image||'', back: c.back_image||'', name: c.name||c.value, hex: c.hex||'' };
  });

  const data = {
    name,
    category:       document.getElementById('edit-category')?.value?.trim() || '',
    description:    document.getElementById('edit-description')?.value?.trim() || '',
    price_small:    parseFloat(document.getElementById('edit-small')?.value)    || null,
    price_standard: parseFloat(document.getElementById('edit-standard')?.value) || null,
    price_maxi:     parseFloat(document.getElementById('edit-maxi')?.value)     || null,
    sale_price:     parseFloat(document.getElementById('edit-sale')?.value)     || null,
    stock_quantity: parseInt(document.getElementById('edit-stock')?.value)      || 0,
    is_active:      document.getElementById('edit-active')?.checked   ?? false,
    is_featured:    document.getElementById('edit-featured')?.checked  ?? false,
    is_new:         document.getElementById('edit-isnew')?.checked     ?? false,
    colors:         colorValues.length ? colorValues : ['black'],
    default_color:  colorValues[0] || 'black',
    color_images:   Object.keys(colorImages).length ? colorImages : null,
  };

  try {
    const sb = await getSupabase();
    const { error } = await sb.from('products').update(data).eq('id', id);
    if (error) throw error;
    document.querySelector('[style*="position:fixed"]')?.remove();
    showToast('✓ Produkt uložen');
    if(typeof AuditLog!=='undefined') AuditLog.add('Produkt upraven', name);
    loadAdminProducts();
  } catch (e) { showToast('Chyba: ' + e.message); }
}

async function deleteProduct(id, name) {
  if (!confirm(`Opravdu smazat "${name}"?`)) return;
  try {
    const sb = await getSupabase();
    const { error } = await sb.from('products').delete().eq('id', id);
    if (error) throw error;
    showToast('Produkt smazán');
  if(typeof AuditLog!=='undefined') AuditLog.add('Produkt smazán', name);
    loadAdminProducts();
  } catch (e) { showToast('Chyba: ' + e.message); }
}

// ─── Orders ─────────────────────────────────────────────────────
async function loadAdminOrders() {
  if (!checkAdminAuth()) return;
  const container = document.getElementById('admin-orders-list');
  if (!container) return;
  container.innerHTML = '<div class="loading-spinner"></div>';

  try {
    const sb = await getSupabase();
    const filterStatus = document.getElementById('filter-order-status')?.value || '';
    let query = sb.from('orders').select('*').order('created_at', { ascending: false });
    if (filterStatus) query = query.eq('status', filterStatus);
    const { data: orders, error } = await query;
    if (error) throw error;

    if (!orders?.length) {
      container.innerHTML = '<div style="color:#666;text-align:center;padding:40px;">Žádné objednávky</div>';
      return;
    }

    container.innerHTML = `
      <table class="data-table">
        <thead><tr><th>Objednávka</th><th>Zákazník</th><th>Email</th><th>Částka</th><th>Stav</th><th>Datum</th><th>Akce</th></tr></thead>
        <tbody>${orders.map(o => `
          <tr>
            <td style="font-family:monospace;color:#c8a96a;font-size:13px;">${escapeHtml(o.order_number)}</td>
            <td style="font-weight:600;">${escapeHtml(o.customer_name)}</td>
            <td style="color:#777;font-size:13px;">${escapeHtml(o.customer_email)}</td>
            <td style="font-weight:700;">${formatPrice(o.total_amount)} Kč</td>
            <td>
              <select onchange="updateStatus(${o.id}, this.value)" style="padding:5px 8px;background:#0a0a0a;color:#fff;border:1px solid #333;border-radius:4px;font-size:12px;">
                ${['pending','processing','printing','shipped','delivered','cancelled'].map(s =>
                  `<option value="${s}" ${o.status === s ? 'selected' : ''}>${statusCZ(s)}</option>`).join('')}
              </select>
            </td>
            <td style="color:#666;font-size:12px;">${formatDate(o.created_at)}</td>
            <td>
              <button onclick="viewOrderDetail(${o.id})" style="background:rgba(200,169,106,0.15);color:#c8a96a;border:none;padding:5px 10px;border-radius:4px;cursor:pointer;font-size:11px;">Detail</button>
            </td>
          </tr>`).join('')}
        </tbody>
      </table>`;
  } catch (e) {
    container.innerHTML = `<div style="color:#f44;padding:20px;">Chyba: ${e.message}</div>`;
  }
}

async function updateStatus(orderId, newStatus) {
  try {
    const sb = await getSupabase();
    const { error } = await sb.from('orders').update({ status: newStatus }).eq('id', orderId);
    if (error) throw error;
    showToast('✓ Stav aktualizován: ' + newStatus);
  if(typeof AuditLog!=='undefined') AuditLog.add('Stav objednávky změněn', newStatus);
  } catch (e) { showToast('Chyba: ' + e.message); }
}

async function viewOrderDetail(orderId) {
  try {
    const sb = await getSupabase();
    const { data: order } = await sb.from('orders').select('*').eq('id', orderId).single();
    const { data: items } = await sb.from('order_items').select('*').eq('order_id', orderId);

    const modal = document.createElement('div');
    modal.style.cssText = 'position:fixed;inset:0;background:rgba(0,0,0,0.85);z-index:1000;display:flex;align-items:center;justify-content:center;padding:20px;';
    modal.onclick = (e) => { if (e.target === modal) modal.remove(); };
    modal.innerHTML = `
      <div style="background:#1a1a1a;border:1px solid #333;border-radius:12px;padding:28px;width:100%;max-width:560px;max-height:90vh;overflow-y:auto;">
        <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:20px;">
          <h2 style="font-size:17px;font-weight:700;">${escapeHtml(order.order_number)}</h2>
          <button onclick="this.closest('[style*=position]').remove()" style="background:none;border:none;color:#777;font-size:22px;cursor:pointer;">✕</button>
        </div>
        <div style="display:grid;grid-template-columns:1fr 1fr;gap:12px;margin-bottom:20px;font-size:14px;color:#999;">
          <div><strong style="color:#ccc;">Zákazník</strong><br>${escapeHtml(order.customer_name)}</div>
          <div><strong style="color:#ccc;">Email</strong><br>${escapeHtml(order.customer_email)}</div>
          <div><strong style="color:#ccc;">Telefon</strong><br>${escapeHtml(order.customer_phone||'—')}</div>
          <div><strong style="color:#ccc;">Doručení</strong><br>${escapeHtml(order.shipping_method)}</div>
          <div style="grid-column:1/-1;"><strong style="color:#ccc;">Adresa</strong><br>${escapeHtml(order.customer_street)}, ${escapeHtml(order.customer_city)} ${escapeHtml(order.customer_postal)}</div>
        </div>
        <div style="border-top:1px solid #2a2a2a;padding-top:16px;">
          <strong style="display:block;margin-bottom:10px;font-size:14px;">Položky objednávky</strong>
          ${(items||[]).map(i => `<div style="display:flex;justify-content:space-between;padding:8px 0;border-bottom:1px solid #1e1e1e;font-size:13px;color:#ccc;">
            <span>${escapeHtml(i.product_name)} <span style="color:#666;">(${i.color}, ${i.size||'Standard'}) × ${i.quantity}</span></span>
            <span style="font-weight:600;">${formatPrice(i.total_price)} Kč</span>
          </div>`).join('')}
          <div style="display:flex;justify-content:space-between;padding:12px 0;font-weight:700;font-size:16px;color:#c8a96a;">
            <span>Celkem</span><span>${formatPrice(order.total_amount)} Kč</span>
          </div>
        </div>
      </div>`;
    document.body.appendChild(modal);
  } catch (e) { showToast('Chyba: ' + e.message); }
}

// ─── Reports ─────────────────────────────────────────────────────
async function loadAdminReports() {
  if (!checkAdminAuth()) return;
  const el = document.getElementById('reports-content');
  if (!el) return;
  el.innerHTML = '<div class="loading-spinner"></div>';
  try {
    const sb = await getSupabase();
    const { data: orders } = await sb.from('orders').select('*');
    const { data: products } = await sb.from('products').select('*');
    if (!orders) return;

    const total = orders.reduce((s, o) => s + (o.total_amount || 0), 0);
    const byStatus = {};
    orders.forEach(o => { byStatus[o.status] = (byStatus[o.status] || 0) + 1; });

    el.innerHTML = `
      <div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(200px,1fr));gap:16px;margin-bottom:24px;">
        <div style="padding:20px;background:#1a1a1a;border-radius:8px;border:1px solid #2a2a2a;">
          <div style="font-size:11px;color:#666;text-transform:uppercase;margin-bottom:6px;">Celkový obrat</div>
          <div style="font-size:28px;font-weight:700;color:#4f4;">${formatPrice(total)} Kč</div>
        </div>
        <div style="padding:20px;background:#1a1a1a;border-radius:8px;border:1px solid #2a2a2a;">
          <div style="font-size:11px;color:#666;text-transform:uppercase;margin-bottom:6px;">Objednávek celkem</div>
          <div style="font-size:28px;font-weight:700;">${orders.length}</div>
        </div>
        <div style="padding:20px;background:#1a1a1a;border-radius:8px;border:1px solid #2a2a2a;">
          <div style="font-size:11px;color:#666;text-transform:uppercase;margin-bottom:6px;">Průměrná objednávka</div>
          <div style="font-size:28px;font-weight:700;color:#c8a96a;">${orders.length ? formatPrice(total/orders.length) : 0} Kč</div>
        </div>
      </div>
      <div style="background:#1a1a1a;border:1px solid #2a2a2a;border-radius:8px;padding:20px;">
        <h3 style="margin-bottom:14px;font-size:15px;">Objednávky dle stavu</h3>
        ${Object.entries(byStatus).map(([s,c]) => `
          <div style="display:flex;justify-content:space-between;padding:8px 0;border-bottom:1px solid #1e1e1e;font-size:14px;">
            <span style="color:#999;">${s}</span>
            <span style="font-weight:600;">${c} objednávek</span>
          </div>`).join('')}
      </div>`;
  } catch (e) { el.innerHTML = `<div style="color:#f44;">Chyba: ${e.message}</div>`; }
}

async function loadAdminAnalytics() {
  if (!checkAdminAuth()) return;
  const el = document.getElementById('analytics-content');
  if (!el) { return; }
  el.innerHTML = '<div style="text-align:center;padding:60px;color:#666;"><div style="font-size:40px;margin-bottom:12px;">📊</div><p>Analytics dashboard — připojte Google Analytics nebo Plausible pro detailní statistiky.</p></div>';
}

async function loadAdminCategories() {
  if (!checkAdminAuth()) return;
  const el = document.getElementById('categories-list');
  if (!el) return;
  el.innerHTML = '<div class="loading-spinner"></div>';
  try {
    const sb = await getSupabase();
    const { data: products } = await sb.from('products').select('category');
    const cats = [...new Set(products?.map(p => p.category).filter(Boolean))];
    el.innerHTML = cats.length ? cats.map(c => `
      <div style="display:flex;justify-content:space-between;align-items:center;padding:14px 16px;background:#111;border-radius:6px;border:1px solid #222;margin-bottom:8px;">
        <span style="font-weight:600;">${escapeHtml(c)}</span>
        <span style="color:#666;font-size:13px;">${products.filter(p => p.category === c).length} produktů</span>
      </div>`).join('') : '<div style="color:#666;text-align:center;padding:40px;">Žádné kategorie</div>';
  } catch (e) { el.innerHTML = `<div style="color:#f44;">Chyba: ${e.message}</div>`; }
}

function checkAdminAuth() {
  const auth = sessionStorage.getItem('admin-auth');
  if (!auth) { goTo('/admin/login'); return false; }
  return true;
}

// Exports
window.adminLogout = adminLogout;
window.loadAdminProducts = loadAdminProducts;
window.loadAdminOrders = loadAdminOrders;
window.createProduct = createProduct;
window.deleteProduct = deleteProduct;
window.updateStatus = updateStatus;
window.editProduct = editProduct;
window.saveProduct = saveProduct;
window.viewOrderDetail = viewOrderDetail;
window.loadAdminReports = loadAdminReports;
window.loadAdminAnalytics = loadAdminAnalytics;
window.loadAdminCategories = loadAdminCategories;
window.checkAdminAuth = checkAdminAuth;

// ─── Bulk order actions ───────────────────────────────────────
async function bulkUpdateOrders(newStatus) {
  const checkboxes = document.querySelectorAll('.order-checkbox:checked');
  if (!checkboxes.length) { showToast('Vyberte alespoň jednu objednávku'); return; }
  if (!confirm(`Změnit stav ${checkboxes.length} objednávek na "${newStatus}"?`)) return;

  const ids = [...checkboxes].map(cb => parseInt(cb.dataset.id));
  try {
    const sb = await getSupabase();
    for (const id of ids) {
      await sb.from('orders').update({ status: newStatus }).eq('id', id);
    }
    showToast(`✓ ${ids.length} objednávek aktualizováno`);
    loadAdminOrders();
  } catch(e) { showToast('Chyba: ' + e.message); }
}

// ─── New order browser notification ──────────────────────────
let _lastOrderCount = 0;
async function checkForNewOrders() {
  try {
    const sb = await getSupabase();
    const { count } = await sb.from('orders').select('*', { count: 'exact', head: true }).eq('status', 'pending');
    if (_lastOrderCount > 0 && count > _lastOrderCount) {
      sendBrowserNotification('🛒 Nová objednávka!', `Máte ${count - _lastOrderCount} novou objednávku čekající na zpracování.`);
      setTitleBadge(count);
      showToast(`🛒 Nová objednávka! (${count} čekajících)`);
    }
    _lastOrderCount = count || 0;
    setTitleBadge(_lastOrderCount);
  } catch(e) {}
}

function startOrderPolling() {
  checkForNewOrders();
  setInterval(checkForNewOrders, 30000); // Check every 30s
}

// ─── Admin audit log ──────────────────────────────────────────
function logAdminAction(action, details) {
  const log = JSON.parse(localStorage.getItem('admin_audit_log') || '[]');
  log.unshift({ action, details, timestamp: new Date().toISOString(), user: 'admin' });
  localStorage.setItem('admin_audit_log', JSON.stringify(log.slice(0, 100)));
}

function getAdminAuditLog() {
  return JSON.parse(localStorage.getItem('admin_audit_log') || '[]');
}

// ─── Quick order filter ───────────────────────────────────────
function filterOrdersQuick(period) {
  const filter = document.getElementById('filter-order-status');
  const dateFilter = document.getElementById('filter-order-date');

  const now = new Date();
  let since;
  if (period === 'today') { since = new Date(now.setHours(0,0,0,0)).toISOString(); }
  else if (period === 'week') { const d = new Date(); d.setDate(d.getDate()-7); since = d.toISOString(); }
  else if (period === 'month') { const d = new Date(); d.setDate(d.getDate()-30); since = d.toISOString(); }

  // Store for loadAdminOrders to use
  window._orderSince = since || null;
  loadAdminOrders();
}

window.bulkUpdateOrders = bulkUpdateOrders;
window.startOrderPolling = startOrderPolling;
window.checkForNewOrders = checkForNewOrders;
window.logAdminAction = logAdminAction;
window.getAdminAuditLog = getAdminAuditLog;
window.filterOrdersQuick = filterOrdersQuick;

// js/search.js — Drobnostík v3

let allProducts = [];

async function initSearch() {
  await fetchAllProducts();
  performSearch();
  // Show search history chips
  renderSearchHistoryChips();

  const queryInput = document.getElementById('search-query');
  if (queryInput) {
    // Load query from URL if any
    const params = new URLSearchParams(window.location.search);
    const q = params.get('q');
    if (q) { queryInput.value = q; }
    queryInput.addEventListener('input', debounce(performSearch, 250));
    queryInput.focus();
    // Autocomplete
    if (typeof showSearchSuggestions !== 'undefined') {
      showSearchSuggestions('search-query', 'search-suggestions', allProducts);
    }
    queryInput.addEventListener('keydown', e => {
      if (e.key === 'Enter') {
        const q = queryInput.value.trim();
        if (q && typeof SearchHistory !== 'undefined') {
          SearchHistory.add(q);
          renderSearchHistoryChips();
        }
      }
    });
  }
  document.getElementById('search-category')?.addEventListener('change', performSearch);
  document.getElementById('search-price-min')?.addEventListener('input', debounce(performSearch, 300));
  document.getElementById('search-price-max')?.addEventListener('input', debounce(performSearch, 300));
  document.getElementById('search-sort')?.addEventListener('change', performSearch);
}

async function fetchAllProducts() {
  try {
    const sb = await getSupabase();
    const { data } = await sb.from('products').select('*').eq('is_active', true);
    allProducts = data || [];
  } catch (e) { console.error('Search fetch error:', e); }
}

function debounce(fn, ms) {
  let timer;
  return (...args) => { clearTimeout(timer); timer = setTimeout(() => fn(...args), ms); };
}

function performSearch() {
  let query = document.getElementById('search-query')?.value?.toLowerCase().trim() || '';
  if (typeof applySynonyms === 'function') query = applySynonyms(query);
  const category = document.getElementById('search-category')?.value || '';
  const priceMin = parseFloat(document.getElementById('search-price-min')?.value) || 0;
  const priceMax = parseFloat(document.getElementById('search-price-max')?.value) || Infinity;
  const sort = document.getElementById('search-sort')?.value || 'relevance';

  let results = allProducts.filter(p => {
    const price = p.price_standard || p.price_small || 0;
    const matchQuery = !query ||
      p.name?.toLowerCase().includes(query) ||
      p.description?.toLowerCase().includes(query) ||
      p.category?.toLowerCase().includes(query);
    const matchCat = !category || p.category === category;
    const matchPrice = price >= priceMin && price <= priceMax;
    return matchQuery && matchCat && matchPrice;
  });

  if (sort === 'price_asc') results.sort((a, b) => (a.price_standard || a.price_small || 0) - (b.price_standard || b.price_small || 0));
  else if (sort === 'price_desc') results.sort((a, b) => (b.price_standard || b.price_small || 0) - (a.price_standard || a.price_small || 0));
  else if (sort === 'name') results.sort((a, b) => a.name?.localeCompare(b.name || ''));

  const countEl = document.getElementById('search-count');
  if (countEl) countEl.textContent = results.length;

  const container = document.getElementById('search-results');
  if (!container) return;

  if (results.length === 0) {
    container.innerHTML = `<div style="grid-column:1/-1;text-align:center;padding:60px 20px;color:#999;">
      <div style="font-size:48px;margin-bottom:16px;">🔍</div>
      <p>Nic nenalezeno pro "<strong>${escapeHtml(query)}</strong>"</p>
      <p style="font-size:13px;margin-top:8px;">Zkuste jiná klíčová slova nebo odstraňte filtry</p>
    </div>`;
    return;
  }

  container.innerHTML = results.map(p => renderProductCard(p)).join('');
}

window.initSearch = initSearch;
window.performSearch = performSearch;

function renderSearchHistoryChips() {
  const container = document.getElementById('search-history-chips');
  if (!container || typeof SearchHistory === 'undefined') return;
  const history = SearchHistory.get();
  if (!history.length) return;
  container.innerHTML = history.map(h => `
    <button onclick="document.getElementById('search-query').value='${escapeHtml(h)}';performSearch();SearchHistory.add('${escapeHtml(h)}')"
      style="padding:5px 12px;background:rgba(200,169,106,0.1);border:1px solid rgba(200,169,106,0.2);color:#c8a96a;border-radius:20px;font-size:12px;cursor:pointer;" aria-label="Hledat ${escapeHtml(h)}">
      🕐 ${escapeHtml(h)}
    </button>`).join('') +
    `<button onclick="SearchHistory.clear();document.getElementById('search-history-chips').innerHTML=''" style="padding:5px 12px;background:none;border:1px solid #333;color:#555;border-radius:20px;font-size:12px;cursor:pointer;" aria-label="Vymazat historii">Vymazat</button>`;
}
window.renderSearchHistoryChips = renderSearchHistoryChips;

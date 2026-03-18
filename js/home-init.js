// js/home-init.js — Drobnostík v3

const homeImages = [
  '/images/home-collection.jpg',             // 1. Celá kolekce (panorama)
  '/images/pokebowl-hero-detail.jpg',        // 2. Černý pokéball — close-up
  '/images/pokebowl-lifestyle-desk.jpg',     // 3. Lifestyle na stole
  '/images/products/pokebowl-white-front.jpg', // 4. Bílý pokéball
  '/images/products/pokebowl-red-front.jpg', // 5. Červený pokéball
  '/images/products/pokebowl-gray-front.jpg', // 6. Šedý pokéball
];
const homeImagesBack = [
  '/images/about-process-printing.jpg',      // 1. 3D tiskárna v akci
  '/images/about-process-finishing.jpg',     // 2. Ruční finišování
  '/images/pokebowl-gift-box.jpg',           // 3. Dárkové balení
  '/images/pokebowl-size-comparison.jpg',    // 4. Porovnání velikostí
  '/images/about-packaging.jpg',             // 5. Balení zásilky
  '/images/about-quality-check.jpg',         // 6. Kontrola kvality
];

let homeCurrentIndex = 0;
let homeViewMode = 'front';
let homeRotateInterval = null;

// Track which layer is currently visible (A=true, B=false)
let _layerA = true;

function homeUpdateImage() {
  const imgA = document.getElementById('rotating-image-a');
  const imgB = document.getElementById('rotating-image-b');
  // Fallback: single image mode
  const imgSingle = document.getElementById('rotating-image');

  const newSrc = (homeViewMode === 'back' ? homeImagesBack : homeImages)[homeCurrentIndex];
  const fallback = '/images/pokebowl-hero-detail.jpg';

  if (imgA && imgB) {
    // Dual-layer crossfade: preload into the HIDDEN layer, then swap opacity
    const incoming = _layerA ? imgB : imgA;
    const outgoing = _layerA ? imgA : imgB;

    // Preload new image
    const preload = new Image();
    preload.onload = function() {
      incoming.src = newSrc;
      // Small delay so browser registers the new src before fading
      requestAnimationFrame(function() {
        requestAnimationFrame(function() {
          incoming.style.opacity = '1';
          outgoing.style.opacity = '0';
          _layerA = !_layerA;
        });
      });
    };
    preload.onerror = function() {
      incoming.src = fallback;
      requestAnimationFrame(function() {
        requestAnimationFrame(function() {
          incoming.style.opacity = '1';
          outgoing.style.opacity = '0';
          _layerA = !_layerA;
        });
      });
    };
    preload.src = newSrc;
  } else if (imgSingle) {
    // Fallback single-image fade
    imgSingle.style.transition = 'opacity 0.9s ease-in-out';
    imgSingle.style.opacity = '0';
    setTimeout(function() {
      imgSingle.src = newSrc;
      imgSingle.onload = function() { imgSingle.style.opacity = '1'; };
      imgSingle.onerror = function() { imgSingle.src = fallback; imgSingle.style.opacity = '1'; };
    }, 400);
  }

  // Update indicators
  for (let i = 0; i < 6; i++) {
    const btn = document.getElementById('indicator-' + i);
    if (btn) {
      btn.style.transition = 'all 0.3s ease';
      btn.style.background = i === homeCurrentIndex ? '#c8a96a' : '#333';
      btn.style.transform  = i === homeCurrentIndex ? 'scale(1.3)' : 'scale(1)';
    }
  }
}

function homeShowImage(index) {
  homeCurrentIndex = index;
  homeUpdateImage();
  clearInterval(homeRotateInterval);
  homeStartAutoRotate();
}

function homeSetView(view) {
  homeViewMode = view;
  homeUpdateImage();
  const fBtn = document.getElementById('btn-front');
  const bBtn = document.getElementById('btn-back');
  if (fBtn) { fBtn.style.background = view === 'front' ? 'rgba(200,169,106,0.9)' : 'rgba(0,0,0,0.5)'; fBtn.style.color = view === 'front' ? '#000' : '#ccc'; }
  if (bBtn) { bBtn.style.background = view === 'back' ? 'rgba(200,169,106,0.9)' : 'rgba(0,0,0,0.5)'; bBtn.style.color = view === 'back' ? '#000' : '#ccc'; }
}

function homeStartAutoRotate() {
  homeRotateInterval = setInterval(() => {
    homeCurrentIndex = (homeCurrentIndex + 1) % homeImages.length;
    homeUpdateImage();
  }, 6000);
}

function initializeHome() {
  homeUpdateImage();
  homeStartAutoRotate();
  if (typeof loadFeaturedProducts === 'function') loadFeaturedProducts();
}

window.homeShowImage = homeShowImage;
window.homeSetView = homeSetView;
window.initializeHome = initializeHome;

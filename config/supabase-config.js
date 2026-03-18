// config/supabase-config.js — Drobnostík v3

const SUPABASE_CONFIG = {
  URL: 'https://wwezzahputwjfzzhybny.supabase.co',
  KEY: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Ind3ZXp6YWhwdXR3amZ6emh5Ym55Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzM3OTgwMTQsImV4cCI6MjA4OTM3NDAxNH0.Sy7ud317RNFq59J4Ewk29iq5wmzZSW0RkFAdOKRybUM',
  ADMIN_USER: 'admin',
  ADMIN_PASS: 'admin'
};

let sb = null;

function initSupabase() {
  if (sb) return sb;
  if (typeof supabase === 'undefined' || typeof supabase.createClient !== 'function') return null;
  sb = supabase.createClient(SUPABASE_CONFIG.URL, SUPABASE_CONFIG.KEY, {
    auth: { persistSession: false }
  });
  return sb;
}

initSupabase();

async function getSupabase() {
  if (sb) return sb;
  for (let i = 0; i < 50; i++) {
    const client = initSupabase();
    if (client) return client;
    await new Promise(r => setTimeout(r, 100));
  }
  throw new Error('Supabase se nepodařilo načíst.');
}

window.SUPABASE_CONFIG = SUPABASE_CONFIG;
window.getSupabase = getSupabase;
window.initSupabase = initSupabase;

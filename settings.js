// ─── Adjustable settings ──────────────────────────────────────────────────────
// Edit this file to change map appearance and data source.

const SETTINGS = {
  // Overpass API endpoint — public mirrors (swap if one is slow)
  //   https://overpass.kumi.systems/api/interpreter   (default, reliable)
  //   https://overpass.private.coffee/api/interpreter
  //   https://overpass-api.de/api/interpreter         (main, sometimes busy)
  overpassEndpoint: 'https://overpass.kumi.systems/api/interpreter',

  // Street line style (all streets, default state)
  streetColor: '#e63946',
  streetWidth: 4,

  // Address dot style (shown when a street is selected)
  addrDotColor:       '#e63946',
  addrDotRadius:      7,
  addrDotStrokeColor: '#ffffff',
  addrDotStrokeWidth: 1.5,

  // Map initial view [longitude, latitude] and zoom
  mapCenter: [44.863, 40.741],  // Dilijan, Armenia
  mapZoom:   14,

  // MapTiler API key (optional — free tier at maptiler.com, 100k tiles/month)
  // When set, uses MapTiler Streets v2 style (fresher snapshots, better style).
  // Leave empty to use OpenFreeMap (no key needed).
  mapTilerApiKey: '',
};

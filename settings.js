// ─── Adjustable settings ──────────────────────────────────────────────────────
// Edit this file to change map appearance and data source.

const SETTINGS = {
  // Overpass API endpoint — public mirrors (swap if one is slow)
  //   https://overpass.kumi.systems/api/interpreter   (default, reliable)
  //   https://overpass.private.coffee/api/interpreter
  //   https://overpass-api.de/api/interpreter         (main, sometimes busy)
  overpassEndpoint: 'https://overpass.kumi.systems/api/interpreter',

  // Street line style (all streets, default state)
  streetColor:   '#2563eb',
  streetWidth:   2.5,
  streetOpacity: 0.8,

  // Address dot style (shown when a street is selected)
  addrDotColor:        '#2563eb',
  addrDotRadius:       7,
  addrDotStrokeColor:  '#ffffff',
  addrDotStrokeWidth:  1.5,

  // Map initial view [longitude, latitude] and zoom
  mapCenter: [24.745, 59.437],  // Tallinn Old Town
  mapZoom:   14,
};

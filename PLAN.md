# osm-housenumber-checker — Version 1

## Context
A browser-based prototype that queries streets + address buildings from OSM via Overpass,
keeps them in memory, and lets the user explore which buildings belong to each street via
simple click interactions. Vector tiles give a crisp basemap. No backend needed.

---

## Stack

| Concern | Choice | Why |
|---------|--------|-----|
| Map rendering | **MapLibre GL JS** (CDN) | Modern, open source, native vector tile support |
| Basemap tiles | **OpenFreeMap** (`tiles.openfreemap.org`) | Truly free, no API key, auto-attribution |
| OSM data | **Overpass `overpass.kumi.systems`** | Reliable public mirror, less loaded than main |
| Output | Single **`index.html`** | Easy to serve, version-control, deploy |
| Deployment | User's VPS via **`deploy.sh`** | Checks deps, copies to `/opt/osm-housenumber-checker` |

No `associatedStreet` relation used — streets linked to buildings purely by `addr:street` = `name`.

---

## File Structure

```
osm-housenumber-checker/
├── index.html          ← entire prototype (MapLibre + app logic)
├── settings.js         ← adjustable style constants (line color, width, dot size…)
├── deploy.sh           ← dependency check + copy to /opt/osm-housenumber-checker
└── PLAN.md             ← this file
```

---

## `index.html` — Behaviour

### On load
1. Init MapLibre map with OpenFreeMap basemap
2. On map `moveend` (and initial load): fire Overpass query for current bbox
   - Named highways: `way[highway][name](bbox)`
   - Address nodes + ways: `node[addr:housenumber](bbox)` + `way[addr:housenumber](bbox)`
3. Parse response → store two JS Maps in memory:
   - `streets: Map<id, {name, geometry, names (all lang tags)}>`
   - `addresses: Map<street_name, [{housenumber, point}]>`
4. Add GeoJSON source `streets-source` → layer `streets-layer`
   - Solid lines, color/width from `settings.js`
   - All streets visible

### On street click
1. Identify clicked street feature
2. Set layer filter: show only clicked street
3. Show multilingual name popup at click point
   (display `name`, `name:en`, `name:ru`, etc. if present)
4. Look up `addresses[street.name]`
5. Add temporary GeoJSON source `addr-source` → circle layer `addr-layer`
   - Same accent color as street, dot size from `settings.js`
   - Each dot has a popup with housenumber

### On map click (no street feature)
1. Remove `addr-layer` + `addr-source`
2. Reset street filter → all streets visible
3. Close any open popups

---

## `settings.js`

```js
export const SETTINGS = {
  streetColor: '#2563eb',
  streetWidth: 2,
  streetOpacity: 0.85,
  addrDotColor: '#2563eb',
  addrDotRadius: 6,
  overpassEndpoint: 'https://overpass.kumi.systems/api/interpreter',
};
```

---

## `deploy.sh`

Workflow:
1. Claude commits changes to repo
2. User pulls repo on server into `~/osm-housenumber-checker`
3. User runs `./deploy.sh`

Script responsibilities:
- Check for required tools (no runtime deps — pure static files)
- Create `/opt/osm-housenumber-checker/` if it doesn't exist
- Copy `index.html`, `settings.js` to `/opt/osm-housenumber-checker/`
- Print success + serve instructions

---

## Overpass Query (bbox, QL)

```
[out:json][timeout:25];
(
  way[highway][name]({{bbox}});
  node[addr:housenumber]({{bbox}});
  way[addr:housenumber]({{bbox}});
);
out body geom;
```

One combined query → one round trip per bbox.

---

## Verification
1. Open `index.html` directly in browser (`file://` or `python3 -m http.server`)
2. Pan to a known dense area (e.g. Old Town, Tallinn)
3. Confirm streets render as solid lines
4. Click a street → only that street highlighted, buildings appear as dots with numbers
5. Click blank map → all streets return, dots gone
6. On server: `./deploy.sh` → files land in `/opt/osm-housenumber-checker/`

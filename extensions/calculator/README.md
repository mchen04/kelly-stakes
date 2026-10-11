# Calculator extension

Independent Manifest V3 popup named **Calculator Only**. It requests only `storage`, and does not depend on OddsJam. Original popup, stylesheet, icons, manifest identity, defaults and storage keys remain. The old README was copied from the OddsJam extension; that original is preserved in the bundle.

```sh
# From repository root
npm ci
npm run build:extensions
```

Load unpacked `dist/extensions/calculator` in Chrome's extensions developer page. Enter Projected Odds (your true American odds), Offered Odds, Bankroll and Kelly %, then click **Calculate Kelly**. Bankroll/multiplier changes are stored locally. Defaults are $4,000 and 1.0. Sizing retains legacy two-decimal probability rounding.

Workspace imports are bundled locally; do not load the source folder directly. Rebuild and reload after source changes. No runtime npm service is required.

Inherited behavior: `parseFloat(value) || default` substitutes defaults for zero bankroll/multiplier; permissive integer parsing and limited validation remain. Browser checks use a separate task-owned automation browser and no personal profile.

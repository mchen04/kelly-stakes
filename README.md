# Kelly Stakes

One repository for the existing website, native iOS app, standalone calculator extension and OddsJam extension. The survivor remains [mchen04/kelly-stakes-web](https://github.com/mchen04/kelly-stakes-web), on `consolidate/kelly-monorepo`.

| Component | Source | Existing capability |
| --- | --- | --- |
| [Web](apps/web/README.md) | `apps/web` | React/Vite site, two American-odds calculators, education, help/privacy/terms routes |
| [iOS](apps/ios/README.md) | `apps/ios` | SwiftUI American/decimal calculator, local presets, age gate, StoreKit preset-slot flow |
| [Calculator extension](extensions/calculator/README.md) | `extensions/calculator` | Manual American-odds sizing popup; local settings |
| [OddsJam extension](extensions/oddsjam/README.md) | `extensions/oddsjam` | Manual sizing, table column injection, per-page automation and URL presets |
| [JavaScript math](packages/kelly/README.md) | `packages/kelly` | Shared odds helpers and web Kelly fraction |
| [Preservation](archives/README.md) | `archives` | Baseline bundles, refs, public metadata, inventories/checksums |

## Local setup

Use Node.js 20+ and npm workspaces. Exercised on Node 26.3.1/npm 11.17.0 on macOS. Existing resolved web dependency versions are retained; esbuild 0.25.8 is now an explicit extension build dependency.

```sh
npm ci
npm run dev -- --host 127.0.0.1 --port 5173
```

Open `http://127.0.0.1:5173`. Other commands:

```sh
npm run build                  # web + both loadable extension directories
npm run build:web              # apps/web/dist
npm run build:extensions       # dist/extensions/{calculator,oddsjam}
npm run preview -- --host 127.0.0.1 --port 4173
npm test                       # shared JS math regressions
npm run lint                   # existing ESLint check; baseline failure
npm run typecheck              # existing strict TS configs; baseline errors
```

Load each generated extension directory separately using **Load unpacked** in Chrome's extension developer page. Build first: source folders contain workspace imports. iOS remains an independent Xcode project at `apps/ios/KellyCriterion.xcodeproj`; no JavaScript bridge or Swift dependency migration is needed.

## Validation and limits

[Consolidation notes](docs/consolidation.md) describe exercised behavior, inherited defects and preservation choices. Local checks do not establish live OddsJam compatibility, App Store readiness, device behavior or purchase behavior. Existing website marketing and links remain legacy content; documentation describes actual implemented capabilities. No multi-bet, history, cloud service or new betting feature was added.

Generated outputs, dependencies, Xcode user/build state and environment files are ignored. Useful native calculation and UI tests remain. Only the assertion-free generated launch screenshot test was omitted from the active app; its original is in the bundle.

## Deployment boundary

Root `vercel.json` retains SPA routing and points future builds at `apps/web/dist`. It disables Git deployment for `consolidate/kelly-monorepo` through [Vercel's branch setting](https://vercel.com/docs/project-configuration/git-configuration). No merge, deployment, rename or deletion is part of this task. Review future production configuration separately before merging. The web survivor must be retained.

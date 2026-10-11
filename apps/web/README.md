# Kelly Stakes web

Part of [mchen04/kelly-stakes](https://github.com/mchen04/kelly-stakes), maintained on the default branch `consolidate/kelly-monorepo`.

Existing React 18, TypeScript, Vite 6, Tailwind CSS 3, React Router and Framer Motion website. All 16 original components remain, including currently unused `HowItWorks.tsx`. Hero and LiveDemo use the workspace odds/Kelly helpers, retaining their UI and amount rounding.

From the repository root:

```sh
npm ci
npm run dev -- --host 127.0.0.1 --port 5173
npm run build:web
npm run preview -- --host 127.0.0.1 --port 4173
npm run lint
npm run typecheck
```

Routes: `/`, `/help`, `/privacy`, `/terms`. Calculators use American odds, bankroll and fractional Kelly; LiveDemo retains NFL/NBA/UFC selectors. General landing copy discusses other capabilities and formats; those claims do not imply a web implementation.

Vite builds without running TypeScript checking, matching the baseline. Baseline ESLint crashes on `@typescript-eslint/no-unused-expressions`; strict TypeScript reports unused imports/state, animation typing and React `style jsx` attributes. The favicon URL `/vite.svg` also lacks a baseline source asset. See [consolidation notes](../../docs/consolidation.md).

Vite/PostCSS/Tailwind configurations remain beside the app so relative content paths resolve from its workspace. Root scripts delegate to this directory. Output is `apps/web/dist`; root Vercel configuration supplies SPA fallback routing.

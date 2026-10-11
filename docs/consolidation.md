# Consolidation record

The writable survivor is [mchen04/kelly-stakes](https://github.com/mchen04/kelly-stakes), with current origin `https://github.com/mchen04/kelly-stakes.git` and GitHub default branch `consolidate/kelly-monorepo`. Forge renamed the surviving `kelly-stakes-web` repository and selected the consolidation branch as default after successful build/publish readback. No merge into `main` or deployment accompanied those changes; `main` remains at baseline `3584be811b0f0938062c4b6a3160b29c9e548373`.

The following names, origins and revisions describe the historical sources, not current repository configuration. Three read-only sources were compared against the actual web tree:

| Original repository | Source revision | Active destination |
| --- | --- | --- |
| `mchen04/kelly-stakes-web` | `3584be811b0f0938062c4b6a3160b29c9e548373` | `apps/web` |
| `mchen04/kelly-stakes-ios` | `dfe55d1f4623b5dfd8eda22ec8708b84a97bcb0c` | `apps/ios` |
| `mchen04/kelly_criterion_google_extension` | `0afae754ae37bcdcaab3413fae9e3be0a642e437` | `extensions/calculator` |
| `mchen04/oddsjam-kelly-extension` | `f9c066fcaf6d16aab8afbe017b7d202e797f1fbf` | `extensions/oddsjam` |

Source clone paths are `/Users/michaelchen/GoalRuns/kelly/t_05cbc7e9/sources/<repository-name>`. Historical origins are `https://github.com/mchen04/<repository-name>.git`. Archive paths, bundle bytes and source/metadata snapshots retain those original identities. The survivor checkout is `/Users/michaelchen/Projects/Apps/kelly-stakes`; it must never be deleted.

## Preservation and organization

All 115 baseline files have explicit dispositions in [the preservation ledger](../archives/preservation-decisions.json): 89 active destinations and 26 archive-only files. Full fetched histories and original bytes remain in [verified bundles](../archives/README.md), including the survivor baseline. The manifest records each file's blob/mode/size/SHA-256, source SHAs, refs, metadata and archive checksums.

The website's full component tree, educational/legal content and configuration are retained. iOS retains all 24 app Swift sources, app icons/colors, native project/workspace/shared scheme, StoreKit configuration, manual accessibility checklist and useful unit/UI suites. Both extensions retain their distinct manifests, popup HTML/CSS, icons and workflows; OddsJam additionally retains worker/content sources.

The standalone extension's old README was byte-identical to OddsJam's and described the wrong product. It is replaced with the actual standalone workflow. Icons are identical between extensions but are kept at the expected component-local filenames. The three identical iOS icon PNGs are also retained at their referenced filenames.

iOS archive-only files are legacy `.claude` commands/hooks/MCP configuration, obsolete/generic AI docs/spec/issue scaffolding, historical README/testing guide, its component `.gitignore`, user-specific Xcode scheme state, and the assertion-free generated launch screenshot test. Existing UI flow/launch-performance tests and all 19 calculator test methods remain. Nothing was discarded from the full bundles.

One npm workspace lock manages the web and `packages/kelly`; no existing resolved dependency version changed. esbuild already came with Vite and is made an explicit root build dependency. It packages extension imports into independent Manifest V3 directories under `dist/extensions`. Native Swift stays independent: no shared runtime, npm dependency or project rewrite.

## Behavior changes

The OddsJam **Calculate Bets** button originally threw `runGetData is not defined`, because the function lived inside the saved-values callback. Moving the same existing function to popup scope restores that manual workflow. This was exercised using the real unpacked extension against a synthetic table.

Product copy, sender identity, layouts, colors, controls, extension permissions/identity, supported odds formats, storage keys/defaults and supported-input calculations retain existing behavior. Shared JavaScript helpers retain full-precision web calculations, the extensions' rounded probability percentage and their plus-stripping parser. Developer-visible changes are the component paths, workspace commands, extension build/load directories, accurate documentation, archives, generated/user-state exclusions and a branch-specific Vercel deployment block.

## Exercised checks

Foreground command/output/exit/revision receipts and task-only harnesses are outside Git at `/Users/michaelchen/GoalRuns/kelly/t_05cbc7e9/evidence`. `commands.jsonl`, execution logs, `execution-fingerprint.json`, `WORKLOG.md` and `HANDOFF.md` provide the full record. Most build-stage receipts name the baseline HEAD plus the then-uncommitted consolidation tree; file/build fingerprints identify the actual checked sources.

| Check | Result |
| --- | --- |
| `npm ci --no-audit --no-fund` using the final workspace lock | Exit 0; reproducible install |
| `npm run build` | Exit 0; web and both extensions |
| `npm test` | Exit 0; four shared-math regression tests |
| `tsc --noEmit -p apps/web/tsconfig.node.json` | Exit 0; Vite configuration |
| `npm run lint` | Exit 2; same baseline ESLint rule crash |
| `npm run typecheck` | Exit 2; inherited strict TypeScript errors, no new diagnostic after helper integration was corrected |
| Native plist/project lint; scheme/workspace XML, StoreKit JSON and asset-reference checks | Passed source/config checks |
| Seven original Foundation/core-model Swift files via installed Swift compiler | Compile exit 0 |
| Original Swift Testing suite via temporary package | Exit 1; installed tools lack `Testing` module |
| Task-only adaptation of the 19 original test bodies to nonfatal Boolean assertions | 69 assertions, 68 passed; exit 1 on inherited `++150` validation defect |
| `xcodebuild -version` | Exit 1; full Xcode absent |
| Four baseline bundles, restoration, full strict fsck and ref equality | Passed |

The separate automation Chromium loaded both real unpacked extensions. Web smoke observed default `$516`/5.16%, edited `$625`, negative-edge `$0`, scenario updates, and HTTP 200/content for help/privacy/terms routes. The calculator popup produced `$125.00`/12.50% from $1,000, 0.5 Kelly, true +100/offered +200; storage survived reload. OddsJam's manual popup and manual/automatic table workflows produced `$125.00` on synthetic DOM; enabled-page storage and saved filter presets updated the task's fixture URL.

The fixture URL `https://fixture.oddsjam.com/kelly-task-fixture` was fulfilled locally by the browser driver; no live OddsJam request/account was used. Popup HTML was rendered as an extension page with the synthetic tab kept active. This proves the exercised DOM/storage/worker interactions, not browser-action popup sizing or current live service compatibility. Screenshots were opened for inspection. The first web image was rejected because the entrance animation hid controls; the replacement waited for visible animation completion. The fixture image taken after preset navigation does not prove column completion; the earlier observed DOM value does.

## Accepted inherited limitations

- The content fallback's `injectBetSizeColumn` is scoped inside a loop; it logs a caught error. Its fallback also derives true probability from offered odds, giving a zero edge. The background column path passed the fixture smoke. These independent inherited paths were preserved without a rewrite.
- OddsJam uses a generated CSS class for scraping, retries after a Kelly column is present, has inconsistent defaults and incomplete bankroll/manual-multiplier persistence, and can require current service DOM/account access. These are not live integration claims.
- Extension zero bankroll/multiplier values fall back via `parseFloat(value) || default`; odds parsing/validation remain permissive.
- Swift's existing `validateOdds("++150", .american)` accepts a second plus sign, contrary to its retained test. Full app build, UI suite, simulator/device, VoiceOver, preset persistence and StoreKit flows remain untested here.
- Web strict typing/lint failures precede consolidation. The existing favicon has no source asset. Existing marketing text/links remain; no new product capabilities were added. Baseline dependency installation reported 31 advisories; versions were retained rather than applying unrelated upgrades.
- `git diff --cached --check` reports trailing whitespace in newly imported legacy files; their original formatting is retained. The unstaged change check passes. This is an inherited formatting limitation, not a runtime check failure.

Codex performed no wagers, purchases, sign-ins, account changes, deployment, PR, merge, remote rename/deletion or Trash operations. Forge performed the survivor rename and default-branch selection described above. Only the existing `gh` login for `mchen04` supplied Codex's project GitHub access, through safe-push's restoring wrapper. Public npm registry downloads used no requested credentials. Credential searches were not performed; leak-prevention scanning was limited to project worktree/outgoing commits and public archived Git blobs, with five synthetic documentation findings explicitly reviewed.

Existing GitHub history shows Vercel Production deployments. Root `vercel.json` disables `consolidate/kelly-monorepo` Git deployment using [Vercel's documented setting](https://vercel.com/docs/project-configuration/git-configuration); the block remains in place on the new default branch. The authorized documentation follow-up is pushed to that branch; no `main` push, merge or production deployment is authorized. Forge owns deletion of exactly the three superseded remotes/source clones after successful pushed readback. Bundle preservation and accepted local limitations are not reasons to delete the survivor or rerun exhaustive validation.

The original Codex-owned preview exited after the build/publish turn, as observed by Forge. Forge restarted preview at `http://127.0.0.1:4173/` in its own supervisor-owned process. Current service status is recorded outside Git in `evidence/server.json` and `HANDOFF.md`; Codex does not start or stop that process. Forge also independently observed `npm run build`, all four `npm test` checks and native `plutil` passing, and matched the published consolidation SHA. The documentation follow-up does not repeat checks of unchanged implementation or regenerate archives.

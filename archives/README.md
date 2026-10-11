# Baseline preservation

These archives precede consolidation. They preserve all fetched Git heads/tags and source-clone local branch refs from all four public origins. Each bundle was verified, restored into a fresh mirror, checked with `git fsck --full --strict`, and compared with fetched/source refs. Omitted resources remain recoverable without keeping redundant executable stacks active.

`manifest.json` records exact clone paths, origins, source SHAs, every tracked file's Git blob/mode/size/SHA-256, refs, bundle checksums and public metadata checksums. `preservation-decisions.json` maps every baseline file to its active destination or archive-only disposition. Repository/issue/comment/release/label/milestone JSON are snapshots, not live configuration. The current survivor is [mchen04/kelly-stakes](https://github.com/mchen04/kelly-stakes), with default branch `consolidate/kelly-monorepo`; the archived `kelly-stakes-web` names, origins and metadata remain historical provenance after Forge's rename. Bundles and preservation ledgers are unchanged.

All four remotes had only `main` and no tags. No ignored/untracked source assets, submodules or LFS pointers were present. Issue/comment/release collections were empty; no release assets existed. Web wiki was disabled. Other wiki features were enabled without initialized repositories: Git probes failed, and public wiki URLs redirected to repository roots.

Leak-prevention scans covered every reachable public-history text blob. Five findings in the iOS generic authentication example were reviewed as synthetic. No real credential was found or used; decisions are explicit in `history-secret-scan.json`, and originals remain exact.

Recover an original repository into a new directory:

```sh
git clone archives/kelly-stakes-ios/kelly-stakes-ios.bundle recovered-ios
git -C recovered-ios checkout dfe55d1f4623b5dfd8eda22ec8708b84a97bcb0c
git -C recovered-ios fsck --full --strict
```

For complete refs use `git clone --mirror <bundle> <new-directory.git>`. Bundles do not restore GitHub metadata; accompanying API snapshots cover available public metadata. Codex did not delete or move repositories/source clones. The survivor `mchen04/kelly-stakes` must never be deleted; Forge owns subsequent deletion of the three superseded repositories/source clones after pushed readback.

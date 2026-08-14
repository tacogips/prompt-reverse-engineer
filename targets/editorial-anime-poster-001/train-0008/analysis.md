# Independent Review: train-0008

Status: failed and non-promotable.

The selected training candidate is `rounds/round-0002/candidates/candidate-001`. Its seven weighted `style-inversion-v2` components recompute to training loss `0.183` and reward `0.817`. Candidate selection is consistent with the declared lowest-total-loss rule (`0.183`, `0.186`, `0.193`), and round 3 correctly retained the earlier best after no candidate was realized.

All nine realized candidate, validation, and test `generation.json` records conform to the persisted generation-record contract. Each resolves from the repository root, has exactly one `source_reference` input, excludes the truth hash `376f91fec32deab39af831e9fe3c376279cbbbd82904d74768ba3a2da90e2a4f`, and has matching source, prompt, and output hashes. The corresponding generated image files are present inside the project.

The style model identifies all five required transferable dimensions, provides observations, leakage blacklists, and prompt-clause mappings, and the judge weights assign the required `0.70` combined style weight. Direct inspection confirms both required literal safety/source clauses in the selected executable prompt. However, all three persisted `template-validation.json` files omit a subject-specific-clause count and a required-literal-clause result; round 1 additionally uses `pass` instead of `passed`. This is incomplete template-gate evidence.

Validation coverage and source separation are present: baseline, pose, composition, and exact-text cases span two hashes disjoint from the training hash. The one-shot test covers baseline and combined optional instructions on a third disjoint hash. Runtime evidence shows validation manifest contents were first opened by `validate-transferability`, sealed-test contents were first opened by `audit-generalization`, both manifest hashes remained fixed, and the audit's failure message routed to review rather than refinement.

Promotion is nevertheless blocked. The sealed `alley-combined-optional` case failed `bicycle_center_foreground`, so not all explicit instruction assertions passed. Its stored metric arithmetic also disagrees with the persisted frozen weights: the recorded component values produce `0.1115` total and `0.8885` reward, not stored `0.110` and `0.890`. The aggregate test loss, worst case, and validation-to-test gap are numerically within thresholds, but those facts cannot override the failed required assertion or arithmetic defect. `best.json` was preserved unchanged.

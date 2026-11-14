# Independent Review: train-0011

## Result

The iteration is failed and non-promotable. `best.json` was preserved. Training and frozen validation satisfy their numeric and style-ceiling gates, but the one-shot sealed-test audit fails mandatory provenance and typography gates. A low numeric loss cannot override those failures.

## Verified artifacts and selection

- `style-model.json` is complete for all five teacher-derived dimensions and maps transferable observations to executable prompt clauses. Its four feedback semantic/typography areas are traceable in `feedback-resolution.json`; every feedback item has disposition `implemented`.
- The final prompt passes `template-validation.json`: zero subject-specific clauses, zero forbidden clauses, self-contained source-only generation, and both required literal clauses present verbatim.
- All three candidate images, all four validation images, and both sealed-test images exist at their recorded repository-relative `output.path` locations. Their saved-byte SHA-256 values match their realized generation records.
- All candidate components are in `[0,1]`; the frozen v3 weighted totals recompute as candidate-001 `0.161`, candidate-002 `0.160`, and candidate-003 `0.1515`. Rewards equal `1 - total`. Candidate-003 is the lowest eligible round candidate, and no later round exists to overwrite it.
- Validation covers baseline, pose, composition, and exact-text across two source hashes disjoint from the training hash. Its weighted aggregate is `0.142625`, worst case is `0.153`, and training-to-validation gap is `-0.008875`. Validation instruction, semantic-region, typography, exact-text, and no-text gates pass.
- The sealed test covers the required baseline and combined-optional cases on a fresh landscape source disjoint from training and validation. Its weighted aggregate is `0.08425`, worst case is `0.0985`, and validation-to-test gap is `-0.058375`; these numeric thresholds pass but do not permit promotion.

## Blocking test findings

1. In `test-audit/cases/sea-landscape-baseline/generation.json`, the recorded `optional_instructions_sha256` is `ca3d163bab0553818272261405681f3bef7eaac187cebd76878e0b63e9a10c6a`; freshly hashing canonical `{}` plus its required final newline yields `ca3d163bab055381827226140568f3bef7eaac187cebd76878e0b63e9e442356`. The recorded effective file itself hashes to its recorded `b3ea167af17e8e6c3bcb8b16eb40b9410cce526377e93ba6b3f7d1626cf529ed`, but empty optional instructions require effective bytes identical to the frozen base, whose freshly verified hash is `9bcef001c13e5361c5d6336d4f9d301c5a60e0cca557b99cce44e5c3d162e647`.
2. In `test-audit/cases/sea-landscape-combined-optional/generation.json`, all recorded file hashes and the canonical optional-instruction hash verify, but the effective file bytes differ from the required immutable-base plus deterministic authorized suffix by one newline. The hash record therefore documents the wrong effective bytes rather than satisfying provenance.
3. The combined-optional judge/metrics evidence records the authorized text `BEYOND THE BLUE` plus unrequested readable text `THE`; both exact-text and no-unrequested-text gates fail.

## Isolation and routing

The isolation audit and runtime message sequence support clean timing: validation proceeds to the test audit, and the failed audit routes to `review-training`, not refinement. No pre-validation node is recorded as opening validation contents, and no pre-test node is recorded as opening sealed-test contents. The frozen manifest hashes remain fixed. No generation record contains the style-truth hash or a truth/style role; every realized candidate, validation, and test record has exactly one `source_reference` input.

## Next iteration

Use a newly sealed test source. Generate exact effective prompt bytes from the immutable base without trimming or normalizing, serialize optional instructions canonically before hashing and generation, and strengthen the text constraint so only the caller-supplied string can appear.

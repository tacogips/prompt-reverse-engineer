# Review outcome

Status: failed. The selected training candidate and held-out validation gate passed, but this iteration cannot claim reusable or arbitrary-input success and is not promotable.

## Verified evidence

- All three candidate, four validation, and two sealed-test image files exist in the repository at their `generation.output.path` locations. Their output SHA-256 values, source-input SHA-256 values, and recorded prompt-file SHA-256 values recomputed from saved bytes.
- Every realized candidate, validation, and sealed-test generation record contains exactly one `input_images` entry with role `source_reference`. No such input path or hash is the truth image (`376f91fec32deab39af831e9fe3c376279cbbbd82904d74768ba3a2da90e2a4f`) or a style/truth path.
- The round template validation and isolation audit pass. Both required literal contract clauses occur verbatim in the executable prompt; its forbidden subject-specific clause count is zero. The style model covers all five required style dimensions, maps skin, hair, clothing, and conditional typography to source-preserving prompt policy, and feedback-0001's four items have implemented dispositions, rules, clauses, and validation probes.
- Candidate selection is correct: candidate-003 is the lowest-loss contract/provenance/style-ceiling-eligible candidate (0.139). No later round exists, so no worse round winner overwrote it. Candidate weighted totals and rewards recompute within rounding tolerance.
- Validation has all required baseline, pose, composition, and exact-text cases on two held-out source hashes; validation assertions, no-text checks, per-style ceilings, aggregate (0.1058), worst-case (0.1135), and train-to-validation gap (-0.0332) pass. Training, validation, and test source hashes are disjoint.
- Runtime execution evidence shows only manifest metadata before `validate-transferability`, no validation case identifiers before that node, no test case identifiers before `audit-generalization`, and no refinement/generation node after the audit failure. Manifest hashes remained fixed.

## Blocking findings

The one-shot sealed test is invalid for final-prompt transferability. Its generations declare existing `prompt_sha256` fields and those values freshly recompute from their declared runtime prompt files, but neither equals the frozen executable prompt hash:

| Case | Recorded and fresh runtime prompt SHA-256 | Frozen final prompt SHA-256 |
| --- | --- | --- |
| office-portrait-baseline | `0aedb8e8583d5ca019805eba11b79b9a4bcd42629e06ee84f70700b99e99fc13` | `796cf42cadd935d4bb1fe3ce366a02fc307204380ee06fbbbcbfead6582e98e1` |
| office-portrait-combined-optional | `540e3f65f72f6a92b1d579f55443755d2344a4b9997df716b09ad35b478c0149` | `796cf42cadd935d4bb1fe3ce366a02fc307204380ee06fbbbcbfead6582e98e1` |

Additionally, sealed-test metric arithmetic is inconsistent with the persisted style-inversion-v3 weights. The baseline record reports total/reward `0.0955`/`0.9045`, while fresh computation is `0.0855`/`0.9145`; the combined-optional record reports `0.0795`/`0.9205`, while fresh computation is `0.0810`/`0.9190`. These records are preserved and were not regenerated.

The existing `best.json` remains untouched: it is a different judge version and cannot be numerically compared or replaced by this failed iteration.

## Next hypothesis

In a fresh outer iteration with a newly sealed test set, make the frozen prompt file itself the sole base of every test-generation prompt, append only the authorized case instruction in a separately hashed, explicitly specified mechanism, and calculate each metric total from the persisted `style-inversion-v3` component weights before writing the record.

# Expected Results

Validate and inspect the workflow before running the deterministic scenario:

```sh
riela workflow validate prompt-reverse-train --workflow-definition-dir .riela/workflows --output json
riela workflow inspect prompt-reverse-train --workflow-definition-dir .riela/workflows --output json
riela workflow run prompt-reverse-train --workflow-definition-dir .riela/workflows --mock-scenario .riela/workflows/prompt-reverse-train/mock-scenario.json --output json
riela workflow run prompt-reverse-train --workflow-definition-dir .riela/workflows --mock-scenario .riela/workflows/prompt-reverse-train/mock-scenario-source-binding-failure.json --output json
```

The mock run must complete with exit code `0`. Its stable execution path is:

1. `intake-or-plan`
2. `analyze-images`
3. `generalize-prompt`
4. `audit-input-isolation`
5. `generate-candidates`
6. `judge-candidates`
7. `generate-validation-cases`
8. `validate-transferability`
9. `audit-generalization`
10. `review-training`
11. `workflow-output`

The mock template gate reports zero forbidden subject-specific clauses. The mock judge sets `when.run_validation` to true, and the transferability gate covers baseline, pose, composition, and exact-text behavior before setting `when.stop_training` to true. The one-shot audit then evaluates an untouched source and cannot route back to refinement. Therefore `refine-prompt` must not execute. The final stable exit reason is `target_validation_and_test_reached`. Session ids, timestamps, and absolute runtime paths are unstable and must not be asserted.

The source-binding-failure mock must also exit `0` as an accurately handled failed experiment. Its stable path is `intake-or-plan`, `analyze-images`, `generalize-prompt`, `audit-input-isolation`, `generate-candidates`, `review-training`, `workflow-output`. It must execute exactly seven nodes, report `source_binding_contaminated`, and never execute `judge-candidates`, `refine-prompt`, validation, or test audit.

Static regression checks must also confirm:

- target/style truth is used by analysis and judging but never appears in candidate, validation, test, or final inference generation inputs;
- singleton `styleReference` remains supported, while `styleReferences` uses the distinct `style-inversion-v3-ensemble-v1` regime with ordered member hashes and a deterministic set hash;
- multi-truth training, validation, and test persist every per-reference style assessment and aggregate each style dimension by component-wise median;
- each realized generation has exactly one image input with role `source_reference`;
- every built-in edit call binds that exact local source with `referenced_image_paths`; `num_last_images_to_include` and recent conversation images are forbidden;
- every generation record carries a repository-relative `provider_parameters.source_binding` matching `input_images`, and unrelated-source outputs fail before judging;
- the final prompt contains a concrete textual style specification and requires no style-reference image;
- `prompt-template-contract.json` requires two distinct held-out source hashes;
- `generalize-prompt` occurs before every `generate-candidates` path;
- `audit-input-isolation` occurs between every `generalize-prompt` and `generate-candidates` path and can route contamination to review without generation;
- `generate-validation-cases` opens the frozen validation manifest and creates source-bound outputs after a provisional training stop;
- `validate-transferability` independently judges the persisted validation batch without generating or reopening the manifest;
- `audit-generalization` occurs after transferability validation and before review;
- the template contract exposes optional `pose`, `composition`, `text`, and `additional` fields;
- exact text is required when supplied and unrequested text is rejected;
- a failed transferability gate routes to `refine-prompt` while budget remains.
- candidate generation failure or source-binding contamination routes directly to `review-training`, never to judge or refinement.
- test source hashes cannot overlap training or validation hashes;
- the one-shot audit has no transition to `refine-prompt`.
- ordinary runtime input carries validation and test manifest paths only, never inline cases;
- only `generate-validation-cases` may open the frozen validation manifest;
- pre-validation manifest access is treated as contamination and forces iteration failure.

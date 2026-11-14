# Review result

The iteration failed independent review and is non-promotable. Its reported training, validation, and sealed-test losses passed their configured numerical thresholds, but the persisted generation evidence does not use the required provenance schema.

## Verified observations

- The round-0001 winner is candidate-003 at total loss 0.0745, lower than candidate-002 (0.0805) and candidate-001 (0.116). The selection and best-so-far decision are therefore consistent; there was no later, worse round winner.
- All recorded source-fidelity, semantic, composition, color, style, and technical losses are within [0, 1]. Weighted totals and rewards recompute within 0.0005 for all training, validation, and test metrics.
- The template validation passed with zero forbidden subject-specific clauses. Validation records baseline, pose, composition, and exact-text cases across two held-out hashes; its recorded aggregate is 0.0525, worst case 0.066, and train/validation gap -0.022. The one-shot test records baseline and combined-optional coverage; its recorded aggregate is 0.046, worst case 0.0495, and validation/test gap -0.0065.
- Runtime execution evidence shows only filename listing, hashing, and byte-size checks before validate-transferability and audit-generalization. The validation manifest was parsed by validate-transferability; the test manifest was parsed by audit-generalization. The audit routed directly to review-training, not refinement. Recorded manifest hashes and byte sizes remain fixed.

## Failure

All nine generation records (three training candidates, four validation cases, and two test cases) omit every required documented provenance field: `generation.output.path`, `generation.output.sha256`, `generation.input_images[]`, `generation.prompt_file`, and `generation.prompt_sha256`. The records contain incompatible aliases, but aliases were deliberately not read as substitutes. Consequently, this review cannot verify that generated images exist at their declared paths or that their bytes, input references, and prompts match declared hashes.

This is an evidence-schema failure, not a claimed hash mismatch: the required recorded fields do not exist, so no recorded-versus-computed mismatch was asserted.

## Required next iteration change

Write every generation record with the required `output`, `input_images`, `prompt_file`, and `prompt_sha256` fields before judging or promotion. Preserve actual project-relative output image paths and SHA-256 values in those fields, then rerun the complete validation and sealed one-shot test audit. Leave `best.json` unchanged until the replacement iteration passes this provenance gate under the same judge and validation versions.

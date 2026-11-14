# Expected Results

Validate and inspect the workflow before running the deterministic scenario:

```sh
riela workflow validate prompt-reverse-train --workflow-definition-dir .riela/workflows --output json
riela workflow inspect prompt-reverse-train --workflow-definition-dir .riela/workflows --output json
riela workflow run prompt-reverse-train --workflow-definition-dir .riela/workflows --mock-scenario .riela/workflows/prompt-reverse-train/mock-scenario.json --output json
```

The mock run must complete with exit code `0`. Its stable execution path is:

1. `intake-or-plan`
2. `analyze-images`
3. `generalize-prompt`
4. `generate-candidates`
5. `judge-candidates`
6. `validate-transferability`
7. `audit-generalization`
8. `review-training`
9. `workflow-output`

The mock template gate reports zero forbidden subject-specific clauses. The mock judge sets `when.run_validation` to true, and the transferability gate covers baseline, pose, composition, and exact-text behavior before setting `when.stop_training` to true. The one-shot audit then evaluates an untouched source and cannot route back to refinement. Therefore `refine-prompt` must not execute. The final stable exit reason is `target_validation_and_test_reached`. Session ids, timestamps, and absolute runtime paths are unstable and must not be asserted.

Static regression checks must also confirm:

- `prompt-template-contract.json` requires two distinct held-out source hashes;
- `generalize-prompt` occurs before every `generate-candidates` path;
- `validate-transferability` occurs before `review-training` after a provisional training stop;
- `audit-generalization` occurs after transferability validation and before review;
- the template contract exposes optional `pose`, `composition`, `text`, and `additional` fields;
- exact text is required when supplied and unrequested text is rejected;
- a failed transferability gate routes to `refine-prompt` while budget remains.
- test source hashes cannot overlap training or validation hashes;
- the one-shot audit has no transition to `refine-prompt`.

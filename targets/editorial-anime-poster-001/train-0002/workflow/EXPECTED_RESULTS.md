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
3. `generate-candidates`
4. `judge-candidates`
5. `review-training`
6. `workflow-output`

The mock judge sets `when.stop_training` to true, so `refine-prompt` must not execute. Session ids, timestamps, and absolute runtime paths are unstable and must not be asserted.

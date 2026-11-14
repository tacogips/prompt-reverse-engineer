# Task

Independently review the run identified by `{{workflowInput}}` before completion.

Verify that all referenced files exist, component losses are in range, weighted totals and rewards recompute exactly within rounding tolerance, candidate selection is consistent, best-so-far was not overwritten by a worse round winner, and the exit reason agrees with target loss and maximum rounds. Confirm that generated images are in the project rather than only in a tool cache.

Use the persisted generation-record schema exactly when verifying provenance:

- The generated image path is `generation.output.path`.
- The generated image SHA-256 is `generation.output.sha256`.
- Reference image paths and hashes are `generation.input_images[].path` and `generation.input_images[].sha256`.
- The prompt path and hash are `generation.prompt_file` and `generation.prompt_sha256`.
- Do not read or require undeclared aliases such as top-level `generation.image_sha256` or `generation.source_path`.

Before declaring a provenance mismatch, print both the recorded value and the freshly computed value and confirm that the recorded field exists. A verifier implementation error or a missing undeclared alias is not evidence that an artifact changed. If an initial verification command is defective, correct the command and rerun it before deciding iteration status.

Write `<targetDir>/<trainDir>/evaluation.json`, `analysis.md`, and `iteration.json`. Mark iteration status `complete` only if required artifacts and images are present. Update `<targetDir>/best.json` only if this completed result is better under the same judge version; otherwise preserve the existing best.

If verification passes, set state phase to `output`, status to `complete`, and completion timestamp. If it fails, set status to `failed`, record actionable diagnostics in analysis, and still set phase to `output` so the final node reports the failure accurately.

Return one JSON object only with `status`, `nextStep`, `exitReason`, `bestCandidate`, `totalLoss`, `evaluationPath`, and `analysisPath`. Set `nextStep` to `workflow-output`.

# Task

Independently review the run identified by `{{workflowInput}}` before completion.

Verify that all referenced files exist, component losses are in range, weighted totals and rewards recompute exactly within rounding tolerance, candidate selection is consistent, best-so-far was not overwritten by a worse round winner, and the exit reason agrees with target loss and maximum rounds. Confirm that generated images are in the project rather than only in a tool cache.

Write `<targetDir>/<trainDir>/evaluation.json`, `analysis.md`, and `iteration.json`. Mark iteration status `complete` only if required artifacts and images are present. Update `<targetDir>/best.json` only if this completed result is better under the same judge version; otherwise preserve the existing best.

If verification passes, set state phase to `output`, status to `complete`, and completion timestamp. If it fails, set status to `failed`, record actionable diagnostics in analysis, and still set phase to `output` so the final node reports the failure accurately.

Return one JSON object only with `status`, `nextStep`, `exitReason`, `bestCandidate`, `totalLoss`, `evaluationPath`, and `analysisPath`. Set `nextStep` to `workflow-output`.

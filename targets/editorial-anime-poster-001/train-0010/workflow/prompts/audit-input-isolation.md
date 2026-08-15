# Task

In addition to validation/test secrecy, enforce prompt-inversion separation: candidate generation must receive only the source image. Record the target/style truth hash and fail isolation if a generation record, generation call, or generation input contains that hash or a truth/style image role.

Audit validation/test input isolation immediately after the current prompt passes `generalize-prompt` and before any candidate generation.

You may read state, `intake-evidence.json`, prompt/template validation, and execution/session evidence needed to identify which step accessed which path. You may hash the frozen validation and test manifests, but must not open, parse, print, copy, decode, or summarize either manifest or any validation/test fixture image yourself.

Inspect step-scoped execution evidence from this workflow session. Enforce these boundaries:

- `intake-or-plan` may check existence and compute path, SHA-256, and byte size for both manifests, but may not print or parse their contents.
- Only `validate-transferability` may open the frozen validation manifest or its fixture images. Before that step, `analyze-images`, `generalize-prompt`, `generate-candidates`, and `judge-candidates` must not access them or obtain their descriptions, instructions, expected assertions, or hashes through runtime variables, run configuration, intake evidence, runtime snapshots, logs, or other files.
- Only `audit-generalization` may open the sealed test manifest or its fixture image. No earlier optimization or validation step may obtain its contents.
- `analyze-images` and `generalize-prompt` must not open `run-config.json`, `intake-evidence.json`, runtime snapshots, or session logs. The present audit step is allowed to inspect those records only to enforce the boundary.
- A previous legitimate `validate-transferability` execution may appear before a later refinement round. Do not flag access performed by that allowed step; flag only access by a prohibited step.
- If `parentTrainDir` is supplied for a later outer iteration, exact parent analysis, evaluation, judge, state, feedback-resolution, and final-prompt files are authorized research evidence. Do not classify textual mentions of historical validation/test paths, assertions, or failed scores inside those exact parent files as access to the current sealed fixtures. Following such a mention to open a historical fixture remains prohibited during optimization.
- Classify against the current iteration's manifest paths and current fixture bytes. A broad directory inventory by an optimization node is still prohibited even if it reveals only historical names, because the node must use the exact-path allowlist; however, merely reading an authorized parent file that contains a historical path is allowed.

Write `<targetDir>/<trainDir>/isolation-audit/round-NNNN.json` with schema version, round, session id, audited step executions, manifest paths and freshly computed hashes, recorded hashes, every relevant access event, allowed/prohibited classification, and status.

Pass only if no prohibited access occurred, neither manifest hash changed, the runtime input contains paths only rather than inline validation/test cases, and the current prompt/template validation hash matches. On pass, preserve state except setting phase to `generate` and updating its timestamp.

On any violation, set state status to `failed`, phase to `review`, `exitReason` to `input_isolation_contaminated`, and record actionable diagnostics and the audit path. Do not generate images and do not attempt to repair or hide the evidence.

Return adapter JSON only.

Passing form:

```json
{
  "when": {
    "isolation_passed": true
  },
  "payload": {
    "isolation_passed": true,
    "nextStep": "generate-candidates",
    "round": 1,
    "auditPath": "targets/<target-id>/train-NNNN/isolation-audit/round-NNNN.json",
    "exitReason": null
  }
}
```

Failing form sets both `when.isolation_passed` and `payload.isolation_passed` to false, `nextStep` to `review-training`, and `exitReason` to `input_isolation_contaminated`.

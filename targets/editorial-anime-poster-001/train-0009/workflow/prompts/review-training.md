# Task

Independently review the run identified by `{{workflowInput}}` before completion.

Verify that all referenced files exist, `style-model.json` is complete and traceable to prompt clauses, every authorized feedback item has a valid disposition in `feedback-resolution.json`, component losses are in range, weighted totals and rewards recompute exactly within rounding tolerance, candidate selection is consistent, best-so-far was not overwritten by a worse round winner, and the exit reason agrees with target loss, per-style ceilings, feedback gates, and maximum rounds. Confirm that generated images are in the project rather than only in a tool cache.

Also verify every round's `prompt/template-validation.json` and `isolation-audit/round-NNNN.json`, final `transferability/evaluation.json`, and one-shot `test-audit/evaluation.json`. A run may claim reusable or arbitrary-input success only when the final prompt has zero forbidden subject-specific clauses; the five teacher-derived style dimensions pass their ceilings on disjoint sources; training, validation, and test source hashes are disjoint; required validation and test coverage exists; exact text checks pass; no-text cases contain no invented text; aggregate and worst-case thresholds pass; and both train/validation and validation/test gaps are within configured limits. Inspect execution evidence to confirm that no node before `validate-transferability` opened or printed the frozen validation manifest, no node before `audit-generalization` opened or printed the sealed test manifest, both content hashes stayed fixed, and audit failure did not route back to refinement. Any premature access is contamination and forces iteration failure regardless of score. A low total cannot override a failed style dimension, failed or missing audit, or teacher-content leakage. An `allowUnvalidatedPrototype` run must remain non-promotable and must not update `best.json`.

Reject any metric version that treats pixel similarity, the teacher's subject/content, exact crop, concrete layout, literal traits, wording, pose, or scene as a reconstruction target. Relative skin/hair/clothing color treatment and typography/dialogue visual treatment are style evidence and must not be discarded merely because literal teacher content is forbidden. Loss-function versions are incomparable; never promote a pre-`style-inversion-v3` result over a `style-inversion-v3` run by numeric loss alone.

For every candidate, validation, and test `generation.json`, require exactly one generation input with role `source_reference`. Recompute the truth-image hash and fail promotion if that hash or any truth/style path appears in generation inputs. Target/style truth may appear only in analysis, judge, calibration, and review evidence.

Verify that every `prompt-template-contract.json.required_literal_clauses` entry occurs verbatim in the final executable prompt. A missing or paraphrased required clause is a blocking finding.

Use the persisted generation-record schema exactly when verifying provenance:

- Read `<targetDir>/<trainDir>/workflow/generation-record-contract.json` as the authoritative contract.

- The generated image path is `generation.output.path`.
- The generated image SHA-256 is `generation.output.sha256`.
- Reference image paths and hashes are `generation.input_images[].path` and `generation.input_images[].sha256`.
- The prompt path and hash are `generation.prompt_file` and `generation.prompt_sha256`.
- Do not read or require undeclared aliases such as top-level `generation.image_sha256` or `generation.source_path`.
- Every declared path is repository-relative; resolve it from the repository root, never from the directory containing `generation.json`.

Before declaring a provenance mismatch, print both the recorded value and the freshly computed value and confirm that the recorded field exists. A verifier implementation error or a missing undeclared alias is not evidence that an artifact changed. If an initial verification command is defective, correct the command and rerun it before deciding iteration status.

Write `<targetDir>/<trainDir>/evaluation.json`, `analysis.md`, and `iteration.json`. Record training loss and validation loss separately, plus the generalization gap and validation case coverage. Mark iteration status `complete` only if required artifacts, images, template validation, and transferability evidence are present. Update `<targetDir>/best.json` only if this completed result passes the transferability gate and is better under the same judge and validation versions; otherwise preserve the existing best.

If verification passes, set state phase to `output`, status to `complete`, and completion timestamp. If it fails, set status to `failed`, record actionable diagnostics in analysis, and still set phase to `output` so the final node reports the failure accurately.

Return one JSON object only with `status`, `nextStep`, `exitReason`, `bestCandidate`, `totalLoss`, `evaluationPath`, and `analysisPath`. Set `nextStep` to `workflow-output`.

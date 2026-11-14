# Task

Run the final one-shot generalization audit. This is the only workflow step allowed to open `sealedTestManifest` and read its test cases or expected assertions. Verify its SHA-256 against the intake record before reading it.

First read state and `transferability/evaluation.json`. If template or validation prerequisites failed, do not load or generate from test cases. Write `test-audit/evaluation.json` with status `skipped_prerequisite_failed`, preserve the failure exit reason, set state phase to `review`, and return.

If prerequisites passed:

1. Verify every test source hash is distinct from the training source and every validation source.
2. Require at least one untouched test source and both `baseline` and `combined_optional` cases.
3. Freeze the final prompt hash, judge version, thresholds, instructions, and expected assertions before generation.
4. Use the built-in image-generation tool once per test case with the test source as Image 1 and the only generation image. Never pass target/style truth to generation; it is judge-only. Preserve the frozen base-prompt bytes and hash. Canonicalize only the authorized case optional-instruction object with `jq -cS` plus a final newline and hash it. For an empty object, the effective prompt is the base prompt itself. Otherwise create `<case-dir>/effective-prompt.md` as the exact base-prompt bytes followed by two newlines, `# Authorized Optional Instructions`, one newline, the canonical JSON, and a final newline. Send exactly the effective-prompt file bytes to the tool; never normalize, summarize, paraphrase, or re-render the base prompt. Save images and provenance under `<targetDir>/<trainDir>/test-audit/cases/<case-id>/`. Every `generation.json` must conform exactly, record base/effective prompt paths and hashes plus the optional-instruction hash, contain one `source_reference` input and no truth/style path or hash, and recompute from disk.
5. Judge source fidelity, the five reusable style-vector dimensions, applicable pose/composition adherence, exact or absent text, and technical quality using the same validation rubric. Never reward reconstruction of the teacher's content or exact composition.
6. Write per-case `judge.json` and `metrics.json`, then `test-audit/evaluation.json` with aggregate loss, worst-case loss, validation-to-test gap, coverage, hashes, prompt hash, and pass/fail reasons.

Recompute every case total from persisted components using exactly `0.20*medium_rendering + 0.15*palette_tone + 0.15*line_shape + 0.10*texture_material + 0.10*graphic_language + 0.20*source_fidelity + 0.10*technical`. Use full precision and round only the displayed result. Instruction-adherence diagnostics and `typography_dialogue` are gates, not additional weighted terms. Correct and explicitly record any judge-proposed arithmetic mismatch before persisting metrics; never fail solely because an unpersisted draft total was wrong.

This audit is idempotent per frozen prompt hash and sealed-test-manifest hash. If a complete, conformant test batch and terminal evaluation already match those hashes, reuse the recorded result and do not generate again. If a batch is incomplete, preserve terminal cases and generate only missing cases. Issue independent missing-case calls concurrently when the backend permits it. Never overwrite a terminal one-shot result, even after a retry or supervisor rerun.

Do not modify the prompt, judge, cases, thresholds, or expected assertions. Do not route back to refinement. A failed audit is valuable evidence and must remain failed; a later outer iteration must use a newly sealed test set if it tunes from this result.

Pass only when all source separation, coverage, instruction, exact-text, no-unrequested-text, aggregate, worst-case, and gap assertions pass. On pass, set state `exitReason` to `target_validation_and_test_reached`. On failure, set it to `generalization_test_failed`. In both cases set state phase to `review`.

Return one JSON object only with `status`, `nextStep`, `testPassed`, `aggregateTestLoss`, `worstCaseLoss`, `validationTestGap`, `exitReason`, and `evaluationPath`. Set `nextStep` to `review-training`.

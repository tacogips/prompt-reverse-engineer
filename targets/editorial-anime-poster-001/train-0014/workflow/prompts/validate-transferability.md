# Task

Judge the already-generated frozen held-out validation cases; do not generate images and do not open `validationManifest` or `sealedTestManifest`.

Read `{{workflowInput}}`, state, `transferability/freeze.json`, the frozen prompt/template validation, judge configuration, the declared style-truth set, and every existing validation case's source, output, effective prompt, generation record, and expected assertions. Verify the freeze's prompt/manifest hashes against intake records without opening the manifest. Verify every generation against `workflow/generation-record-contract.json`, including exact local-source binding recorded in `provider_parameters.source_binding`, one matching `source_reference`, output/source/prompt hashes, and absence of truth inputs.

Judge every case independently at original resolution. Persist `judge.json` and `metrics.json`. For each case and each of the five style dimensions, persist separate losses/evidence against every truth member and aggregate that dimension by component-wise median. Compute `source_fidelity` once against the exact case source and `technical` once from the output. Never reward any teacher's subject, wording, pose, crop, concrete layout, objects, or scene.

Score and gate:

- `source_fidelity` for source content, identity, geometry, and unspecified attributes;
- `medium_rendering`, `palette_tone`, `line_shape`, `texture_material`, and `graphic_language` under the ensemble rubric;
- source-relative skin, hair, and clothing treatment where applicable;
- `pose_adherence`, `composition_adherence`, and `text_adherence` only where applicable;
- exact supplied text once and no additional/pseudo-readable text; baseline/other no-text cases must contain no text;
- conditional `typography_dialogue` separately from spelling;
- `technical` quality.

Recompute every case total exactly as `0.20*medium_rendering + 0.15*palette_tone + 0.15*line_shape + 0.10*texture_material + 0.10*graphic_language + 0.20*source_fidelity + 0.10*technical`, using full precision and rounding only displayed totals. Instruction diagnostics are gates, not extra weighted terms.

Write `transferability/evaluation.json` with coverage, source hashes, per-case losses, aggregate validation loss, worst-case loss, training loss, generalization gap, prompt hash, judge version, and pass/fail reasons. Pass only when the template gate, source disjointness, required coverage, explicit instructions, exact/no text, aggregate/worst thresholds, every style ceiling, feedback checks, and `maxGeneralizationGap` all pass.

This judge step is idempotent for the frozen case batch. Reuse a complete verified evaluation. If judging is incomplete, complete only missing judge/metrics records from the already-generated images; never regenerate or replace an image.

If validation passes, set state phase to `audit`, exit reason `training_and_validation_reached`, and stop optimization. If it fails and another round remains, set phase `refine` and continue. If it fails at the round budget, set phase `audit` and exit reason `transferability_validation_failed`; the test audit must skip without opening its manifest.

Return adapter JSON with `when.stop_training`, `nextStep`, `validationPassed`, aggregate/worst/gap, and exit reason. Set `stop_training` false only for failed validation with remaining round budget; otherwise route to `audit-generalization`.

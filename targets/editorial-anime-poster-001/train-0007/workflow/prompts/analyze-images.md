# Task

Analyze the two repository-local training images named by `{{workflowInput}}` at original resolution:

- `styleReference`: immutable target/style truth. It may be used only by analysis, refinement, judging, and review. It must never be supplied to candidate, validation, test, or final inference generation.
- `sourceReference` (or legacy `personReference`): training content truth and the sole image input for candidate generation.

The research objective is prompt inversion: infer generator-executable text that recreates the target truth's visual style without requiring that truth image at generation time. Separate direct observation from inference. Write:

1. `<targetDir>/<trainDir>/style-analysis.md`, including a concrete textual inventory of medium, palette, contrast, lighting, line quality, texture, mark making, graphic vocabulary, spatial rhythm, and default composition language;
2. `<targetDir>/<trainDir>/source-analysis.md` (also `identity-analysis.md` only for legacy compatibility);
3. `<targetDir>/<trainDir>/judge/prompt.md`, comparing candidate style to target truth and source-controlled content to source truth;
4. `<targetDir>/<trainDir>/judge/config.json`;
5. `<targetDir>/<trainDir>/rounds/round-0001/prompt/prompt.md`, the exact initial prompt-only style reconstruction specification;
6. `<targetDir>/<trainDir>/rounds/round-0001/prompt/generation.json`.

Do not open, parse, search, print, or copy `validationManifest`, `sealedTestManifest`, files under validation/test fixture directories, runtime snapshots, or their contents. Those inputs must not influence synthesis or judge design.

If `parentTrainDir` is supplied, use its final prompt, analyses, evaluation, and judge evidence only as research evidence. Never inherit an instruction requiring a style image at generation time.

The generation prompt must contain the target-derived style as explicit text. It must not say “match Image 1,” “use the style reference,” or otherwise defer visual specification to the truth image. At generation time the arbitrary source is Image 1 and the only image input. Preserve its content and identity while applying the textual style description. Include enough concrete target-style detail to make the prompt useful without the truth image, but never copy target subject identity, target objects, target writing, logos, or scene-specific content.

Do not copy observations from the training `source-analysis.md` into the reusable generation prompt. Do not hard-code that source's age, gender, ethnicity, skin, face, hair, gaze, expression, pose, clothing, accessories, text, objects, or scene. Express preservation through generic source-controlled invariants.

The prompt must expose optional `pose`, `composition`, `text`, and `additional` instructions. Absent fields have no effect. Exact text is verbatim; absent text means no generated text. Explicit instructions override only their named attributes. Author against `prompt-template-contract.json` and set state phase to `generalize`.

The judge returns losses in `[0,1]` for `source_fidelity`, `semantic`, `composition`, `color`, `style`, and `technical`, plus observable evidence and confidence. The workflow computes the total with weights 0.30, 0.10, 0.15, 0.15, 0.25, and 0.05 respectively. Judge pixels, not prompt wording.

Persist a provisional calibration suite at `<targetDir>/<trainDir>/judge/calibration/v1/manifest.json` with actual observable assessments for target self-match, source self-match, the unstyled source as a cross-domain mismatch, and an order-swap check. Record inputs, expected relation, observed component losses, evidence, pass/fail, judge prompt hash, timestamp, and actual repeat count. Continue only if calibration passes.

After artifacts validate, update only `state.json.phase` to `generalize` and its timestamp.

Return one JSON object only with `status`, `nextStep`, `styleAnalysisPath`, `sourceAnalysisPath`, `judgePromptPath`, `calibrationManifestPath`, `calibrationStatus`, and `generationPromptPath`. Set `nextStep` to `generalize-prompt` only after calibration passes.

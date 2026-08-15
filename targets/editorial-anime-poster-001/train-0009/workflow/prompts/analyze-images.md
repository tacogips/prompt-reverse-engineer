# Task

Analyze the two repository-local training images named by `{{workflowInput}}` at original resolution:

- `styleReference`: immutable target/style truth. It may be used only by analysis, refinement, judging, and review. It must never be supplied to candidate, validation, test, or final inference generation.
- `sourceReference` (or legacy `personReference`): training content truth and the sole image input for candidate generation.

The research objective is style-prompt inversion: infer generator-executable text that recreates the target truth's reusable visual language without requiring that truth image at generation time. Pixel-level reconstruction of the target image is explicitly not the objective; the target already exists. Read every intake-authorized `feedbackFiles` entry before analysis. Separate direct observation, human feedback, inferred reusable style, and target-specific content. Write:

1. `<targetDir>/<trainDir>/style-analysis.md`, including a concrete textual inventory of medium/rendering, palette/tonal behavior, line/shape language, texture/material behavior, mark making, and abstract graphic vocabulary;
2. `<targetDir>/<trainDir>/style-model.json`, a versioned machine-readable style vector whose dimensions are `medium_rendering`, `palette_tone`, `line_shape`, `texture_material`, and `graphic_language`. `palette_tone` must contain semantic-region treatments for `skin`, `hair`, and `clothing`: observed relative value/chroma/shading/outline behavior, a source-preserving transferable rule, prompt clauses, confidence, and literal teacher-color leakage exclusions. `graphic_language` must contain a conditional `typography_dialogue` treatment: lettering or dialogue-container medium, stroke, hierarchy, orientation, placement grammar, and ornament with teacher wording/language excluded. For every dimension record observations, the inferred transferable rule, prompt clauses implementing it, confidence, and a leakage blacklist of target-specific subjects, objects, wording, pose, crop, layout, and scene details that must not enter the reusable prompt;
3. `<targetDir>/<trainDir>/feedback-resolution.json`, listing every feedback item, its disposition (`implemented`, `rejected_as_content_leakage`, or `deferred_requires_probe`), teacher evidence, source-preserving rule, affected style-model path, exact prompt clauses, and validation probe;
4. `<targetDir>/<trainDir>/source-analysis.md` (also `identity-analysis.md` only for legacy compatibility);
5. `<targetDir>/<trainDir>/judge/prompt.md`, comparing reusable candidate style to target truth and candidate content to source truth;
6. `<targetDir>/<trainDir>/judge/config.json`;
7. `<targetDir>/<trainDir>/rounds/round-0001/prompt/prompt.md`, the exact initial prompt-only style reconstruction specification;
8. `<targetDir>/<trainDir>/rounds/round-0001/prompt/generation.json`.

Do not open, parse, search, print, or copy `validationManifest`, `sealedTestManifest`, files under validation/test fixture directories, runtime snapshots, or their contents. Those inputs must not influence synthesis or judge design.

If `parentTrainDir` is supplied, use its final prompt, analyses, evaluation, and judge evidence only as research evidence. Never inherit an instruction requiring a style image at generation time.

The generation prompt must contain the target-derived style as explicit text. It must not say “match Image 1,” “use the style reference,” or otherwise defer visual specification to the truth image. At generation time the arbitrary source is Image 1 and the only image input. Preserve its content and identity while applying the textual style description. Include enough concrete target-style detail to make the prompt useful without the truth image, but never copy target subject identity, target objects, target writing, logos, or scene-specific content.

Do not copy observations from the training `source-analysis.md` into the reusable generation prompt. Do not hard-code that source's age, gender, ethnicity, skin, face, hair, gaze, expression, pose, clothing, accessories, text, objects, or scene. Express preservation through generic source-controlled invariants.

The prompt must expose optional `pose`, `composition`, `text`, and `additional` instructions. Absent fields have no effect. Exact text is verbatim; absent text means no generated text. Explicit instructions override only their named attributes. Author against `prompt-template-contract.json` and set state phase to `generalize`.

Use loss-function version `style-inversion-v3`. The judge returns losses in `[0,1]` for `medium_rendering`, `palette_tone`, `line_shape`, `texture_material`, `graphic_language`, `source_fidelity`, and `technical`, plus observable evidence and confidence. The workflow computes training total as `0.20*medium_rendering + 0.15*palette_tone + 0.15*line_shape + 0.10*texture_material + 0.10*graphic_language + 0.20*source_fidelity + 0.10*technical`. The five style dimensions therefore control 70% of optimization. `palette_tone` is the maximum of its overall-palette, skin-treatment, hair-treatment, and clothing-treatment sub-losses so a missing semantic region cannot be hidden by a good background palette. `typography_dialogue` is conditional: score it only on an authorized exact-text probe, and require it to pass the feedback gate without adding teacher wording. Judge visible output, not prompt wording.

Never reward reproducing the target's subject, identity, objects, readable text, pose, camera crop, concrete layout, or scene. Those are teacher-image content, not the hidden style prompt. Do not score target/candidate pixel similarity or require the candidate to be the same image. `graphic_language` may score transferable relationships such as asymmetric editorial balance, shape layering, negative-space rhythm, or print hierarchy, but not the target's exact geometry or placements.

Persist a provisional calibration suite at `<targetDir>/<trainDir>/judge/calibration/v1/manifest.json` with actual observable assessments for target self-match, source self-match, the unstyled source as a cross-domain mismatch, and an order-swap check. Record inputs, expected relation, observed component losses, evidence, pass/fail, judge prompt hash, timestamp, and actual repeat count. Continue only if calibration passes.

After artifacts validate, update only `state.json.phase` to `generalize` and its timestamp.

Return one JSON object only with `status`, `nextStep`, `styleAnalysisPath`, `sourceAnalysisPath`, `judgePromptPath`, `calibrationManifestPath`, `calibrationStatus`, and `generationPromptPath`. Set `nextStep` to `generalize-prompt` only after calibration passes.

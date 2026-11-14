# Task

Analyze the two repository-local images named by `{{workflowInput}}`:

- `styleReference`: immutable truth for visual style, composition language, palette, line work, texture, and graphic treatment. Do not copy its person's identity.
- `sourceReference` (or legacy `personReference`): training content truth. It may contain a person, object, or scene. Preserve its observable content and identity as far as the target medium permits.

Use local image inspection at original resolution. Separate direct observation from inference. Write:

Do not open, parse, search, print, or copy `validationManifest`, `sealedTestManifest`, any file under validation/test fixture directories, `run-config.json`, `intake-evidence.json`, or runtime snapshots. Validation and test case contents are outside this node's task and must not influence analysis, judge design, or prompt synthesis.

1. `<targetDir>/<trainDir>/style-analysis.md`
2. `<targetDir>/<trainDir>/source-analysis.md` (also write `identity-analysis.md` only when compatibility with an existing iteration requires it)
3. `<targetDir>/<trainDir>/judge/prompt.md`, a strict prompt-as-a-judge rubric comparing style truth to candidate style and source truth to all source-controlled content
4. `<targetDir>/<trainDir>/judge/config.json`
5. `<targetDir>/<trainDir>/rounds/round-0001/prompt/prompt.md`, the exact initial image-generation prompt
6. `<targetDir>/<trainDir>/rounds/round-0001/prompt/generation.json`

If `parentTrainDir` is supplied, read its final prompt, analyses, evaluation, and judge evidence. Treat the parent as research evidence even when its iteration status is failed, but never promote it to `best.json`. Make the new initial prompt a focused improvement over the parent's dominant visible mismatch rather than resetting blindly.

The generation prompt is a reusable policy, not a caption or reconstruction prompt for the current source. Label Image 1 as the style reference and Image 2 as an arbitrary source reference. It must preserve Image 2 content and identity while preventing content leakage from Image 1. Treat this as `style-transfer` and prohibit logos, watermarks, and garbled typography unless exact text was explicitly requested. Infer medium, aspect ratio, framing, palette, and composition language from Image 1; never hard-code any target-specific format into the workflow policy. Explicit optional composition instructions override inferred style defaults.

Do not copy observations from `source-analysis.md` into the generation prompt. In particular, do not hard-code the current source's age, gender, ethnicity, skin tone, face, hair, gaze, expression, pose, direction, clothing, accessories, logo, text, object identity, or scene contents. Express preservation only through generic reference-driven clauses such as “preserve the source subject's observable identity, age, geometry, hairstyle, pose, and composition unless explicitly overridden.” The current source analysis exists for visual judging, not for prompt synthesis.

The prompt must expose optional instructions named `pose`, `composition`, `text`, and `additional`. An absent optional field must have no effect. Exact text must be reproduced verbatim when supplied, while no text may be invented when it is absent. Explicit optional instructions override only the named source attribute; all unspecified source attributes remain invariant. Author the prompt against `prompt-template-contract.json` and set state phase to `generalize`, not `generate`.

The judge must return component losses in `[0,1]` for `source_fidelity`, `semantic`, `composition`, `color`, `style`, and `technical`, plus concise observable evidence and confidence. `source_fidelity` compares all source-controlled content: identity and anatomy for people; count, geometry, materials, and markings for objects; and entities, spatial relationships, and scene structure for scenes. The workflow, not the judge, computes the weighted total. Use weights: source_fidelity 0.30, semantic 0.10, composition 0.15, color 0.15, style 0.25, technical 0.05.

Before accepting the judge configuration, execute and persist a provisional calibration suite at `<targetDir>/<trainDir>/judge/calibration/v1/manifest.json`. It must include actual observable assessments for at least:

- style self-match, using the style truth as both reference and candidate, which must produce near-zero style/color/composition/technical loss;
- source self-match, using the source truth as both reference and candidate, which must produce near-zero source-fidelity/semantic loss;
- obvious cross-domain mismatch, using the unstyled source as candidate against the style truth, which must produce high style and color loss while retaining low source-fidelity loss;
- target/candidate order swap, recording whether presentation order materially changes the assessment.

Record case ids, inputs, expected relation, observed component losses, evidence, pass/fail, judge prompt hash, and timestamp. Set `judge/config.json.calibration_suite` to this repository-relative manifest path and record `calibration_status` as `provisional_passed` only if all calibration relations pass; otherwise stop without generation. Do not fabricate repeated calls: record the actual repeat count.

After all artifacts validate, update only `state.json.phase` to `generalize` and its timestamp. Preserve all other state.

Return one JSON object only with `status`, `nextStep`, `styleAnalysisPath`, `sourceAnalysisPath`, `judgePromptPath`, `calibrationManifestPath`, `calibrationStatus`, and `generationPromptPath`. Set `nextStep` to `generalize-prompt` only after calibration passes.

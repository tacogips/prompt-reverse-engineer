# Task

Analyze the two repository-local images named by `{{workflowInput}}`:

- `styleReference`: immutable truth for visual style, composition language, palette, line work, texture, and graphic treatment. Do not copy its person's identity.
- `personReference`: identity truth. Preserve this person's recognizable facial geometry, age, skin tone, hairstyle, hair color, gaze direction, expression, and pose as far as the target medium permits.

Use local image inspection at original resolution. Separate direct observation from inference. Write:

1. `<targetDir>/<trainDir>/style-analysis.md`
2. `<targetDir>/<trainDir>/identity-analysis.md`
3. `<targetDir>/<trainDir>/judge/prompt.md`, a strict prompt-as-a-judge rubric comparing style truth to a candidate's style and person truth to the candidate's identity
4. `<targetDir>/<trainDir>/judge/config.json`
5. `<targetDir>/<trainDir>/rounds/round-0001/prompt/prompt.md`, the exact initial image-generation prompt
6. `<targetDir>/<trainDir>/rounds/round-0001/prompt/generation.json`

If `parentTrainDir` is supplied, read its final prompt, analyses, evaluation, and judge evidence. Treat the parent as research evidence even when its iteration status is failed, but never promote it to `best.json`. Make the new initial prompt a focused improvement over the parent's dominant visible mismatch rather than resetting blindly.

The generation prompt must label Image 1 as the style reference and Image 2 as the person identity reference. It must explicitly preserve Image 2 identity and prevent copying Image 1 identity, clothes, jewelry, or readable text. Treat this as `style-transfer`, vertical 2:3 editorial poster artwork, and prohibit logos, watermarks, and garbled typography.

The judge must return component losses in `[0,1]` for `identity`, `semantic`, `composition`, `color`, `style`, and `technical`, plus concise observable evidence and confidence. The workflow, not the judge, computes the weighted total. Use weights: identity 0.30, semantic 0.10, composition 0.15, color 0.15, style 0.25, technical 0.05.

Before accepting the judge configuration, execute and persist a provisional calibration suite at `<targetDir>/<trainDir>/judge/calibration/v1/manifest.json`. It must include actual observable assessments for at least:

- style self-match, using the style truth as both reference and candidate, which must produce near-zero style/color/composition/technical loss;
- identity self-match, using the person truth as both reference and candidate, which must produce near-zero identity/semantic loss;
- obvious cross-domain mismatch, using the unstyled person photograph as candidate against the style truth, which must produce high style and color loss while retaining low identity loss;
- target/candidate order swap, recording whether presentation order materially changes the assessment.

Record case ids, inputs, expected relation, observed component losses, evidence, pass/fail, judge prompt hash, and timestamp. Set `judge/config.json.calibration_suite` to this repository-relative manifest path and record `calibration_status` as `provisional_passed` only if all calibration relations pass; otherwise stop without generation. Do not fabricate repeated calls: record the actual repeat count.

After all artifacts validate, update only `state.json.phase` to `generate` and its timestamp. Preserve all other state.

Return one JSON object only with `status`, `nextStep`, `styleAnalysisPath`, `identityAnalysisPath`, `judgePromptPath`, `calibrationManifestPath`, `calibrationStatus`, and `generationPromptPath`. Set `nextStep` to `generate-candidates` only after calibration passes.

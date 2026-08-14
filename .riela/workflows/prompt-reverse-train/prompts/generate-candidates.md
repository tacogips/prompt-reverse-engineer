# Task

Read `{{workflowInput}}`, `<targetDir>/<trainDir>/state.json`, and the current round prompt. Generate exactly `candidatesPerRound` distinct candidates using the built-in image-generation tool.

Input roles for every generation call:

- Image 1: `styleReference`, style/composition/palette/texture reference only
- Image 2: `sourceReference` (or legacy `personReference`), exclusive content and identity reference

This is a `style-transfer` request. Use the persisted subject-agnostic prompt unchanged. Re-state only generic image-role invariants on every call; never add a textual description of the current source's age, gender, ethnicity, face, hair, gaze, pose, clothing, objects, or scene. Apply the run's optional instructions exactly, if present. Use one built-in image-generation call per candidate; do not use an API/CLI fallback. Variants may explore controlled style-level differences, but must not intentionally change source-controlled attributes.

Before generation, require the current round's `prompt/template-validation.json` to have status `passed`, zero forbidden subject-specific clauses, and a prompt hash matching `prompt.md`. Stop rather than generating from an unvalidated or stale prompt.

Save every output inside:

`<targetDir>/<trainDir>/rounds/round-NNNN/candidates/candidate-NNN/`

Each candidate directory must contain `image.png` and `generation.json`. Record the exact prompt hash, input hashes, tool mode, candidate id, round, and any available generation metadata. Never invent seeds or provider values that were not exposed.

Inspect each saved output sufficiently to detect obvious corruption or a missing person. Preserve failed outputs with a failure record rather than silently replacing evidence. When exactly the configured candidate count has a terminal record, set `state.json.phase` to `judge` and update its timestamp.

Return one JSON object only with `status`, `nextStep`, `round`, and `candidatePaths`. Set `nextStep` to `judge-candidates`.

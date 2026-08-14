# Task

Read `{{workflowInput}}`, `<targetDir>/<trainDir>/state.json`, and the current round prompt. Generate exactly `candidatesPerRound` distinct candidates using the built-in image-generation tool.

Do not open validation or test manifests, fixture images, expected assertions, runtime snapshots, or validation/test evidence. They are not generation inputs for this step.

Input roles for every generation call:

- Image 1: `styleReference`, style/composition/palette/texture reference only
- Image 2: `sourceReference` (or legacy `personReference`), exclusive content and identity reference

This is a `style-transfer` request. Use the persisted subject-agnostic prompt unchanged. Re-state only generic image-role invariants on every call; never add a textual description of the current source's age, gender, ethnicity, face, hair, gaze, pose, clothing, objects, or scene. Apply the run's optional instructions exactly, if present. Use one built-in image-generation call per candidate; do not use an API/CLI fallback. Variants may explore controlled style-level differences, but must not intentionally change source-controlled attributes.

Before generation, require the current round's `prompt/template-validation.json` to have status `passed`, zero forbidden subject-specific clauses, a prompt hash matching `prompt.md`, and an exact-presence check showing every `prompt-template-contract.json.required_literal_clauses` entry occurs verbatim in the frozen prompt. Stop rather than generating from an unvalidated, stale, or safety-incomplete prompt. Never add safety wording only at generation-call time.

This node is idempotent. Before any generation call, inspect only the current round's candidate directories. Reuse a candidate whose image and conformant provenance record already exist and whose prompt/input hashes match the current frozen inputs. Never overwrite or regenerate a matching terminal candidate during a retry. Preserve a mismatched or incomplete record as failure evidence and generate only missing candidate ids. Issue independent missing-candidate calls concurrently when the backend permits it.

Save every output inside:

`<targetDir>/<trainDir>/rounds/round-NNNN/candidates/candidate-NNN/`

Each candidate directory must contain `image.png` and `generation.json`. Before generating, read `<targetDir>/<trainDir>/workflow/generation-record-contract.json`. Every `generation.json` must conform to it exactly, including `output.path`, `output.sha256`, `input_images[]`, `prompt_file`, and `prompt_sha256`; all paths must be repository-relative. Additional fields such as candidate id and round are allowed, but aliases never replace required fields. After saving the image and record, recompute the output, input, and prompt hashes from disk and fail the node if any recorded value differs. Never invent seeds or provider values that were not exposed; use `null` where the contract permits it.

Inspect each saved output sufficiently to detect obvious corruption or missing required source content. Preserve failed outputs with a failure record rather than silently replacing evidence. When exactly the configured candidate count has a terminal record, clear any stale node-level failure, blocking reason, or retry diagnostic left by an earlier failed generation attempt, set `state.json.status` to `running`, set `state.json.phase` to `judge`, and update its timestamp. Preserve the old failure evidence in its attempt files rather than leaving it as the current state.

Return one JSON object only with `status`, `nextStep`, `round`, and `candidatePaths`. Set `nextStep` to `judge-candidates`.

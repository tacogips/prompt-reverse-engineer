# Task

Read `{{workflowInput}}`, state, and the current frozen prompt. Generate exactly `candidatesPerRound` distinct candidates with the built-in image-generation tool.

This is prompt-only style reconstruction. Supply exactly one image to every generation call:

- Image 1: `sourceReference` (or legacy `personReference`), the exclusive content and identity authority.

Never attach, load for generation, or pass `styleReference`, any truth image, or any target/style image. The prompt text is the only carrier of the reconstructed style. A generation call containing the truth hash or a forbidden generation role is invalid and must fail the node.

Do not open validation/test manifests, fixtures, expected assertions, or evidence. Use the frozen prompt unchanged. The current training run has no case-specific optional-instruction suffix: the frozen prompt file is both the base prompt and exact effective prompt. Send its bytes verbatim; never summarize, normalize, paraphrase, or re-render it, and never append a source description or safety text at call time.

Before generation, require passed template validation, matching prompt hash, zero forbidden source-specific clauses, exact required literal checks, a sole-source-image role check, and a passed forbidden-style-image-input check.

This node is idempotent. Reuse only terminal candidates with matching prompt/source hashes and conformant provenance. Preserve failures, generate only missing ids, and issue independent missing calls concurrently when possible.

Save each result under `<targetDir>/<trainDir>/rounds/round-NNNN/candidates/candidate-NNN/` as `image.png` and `generation.json`. The record must conform to `workflow/generation-record-contract.json`, set identical base/effective prompt paths and hashes, persist canonical `{}` optional-instruction JSON and its hash, contain exactly one `input_images` entry with role `source_reference`, and contain no truth/style hash. Recompute every persisted hash from disk.

Inspect outputs for corruption and missing source content. On complete success clear stale current-state generation failures while preserving attempt evidence, set state status `running`, phase `judge`, and update the timestamp.

Return one JSON object only with `status`, `nextStep`, `round`, and `candidatePaths`. Set `nextStep` to `judge-candidates`.

# Task

Read `{{workflowInput}}`, state, and the current frozen prompt. Generate exactly `candidatesPerRound` distinct candidates with the built-in image-generation tool.

This is prompt-only style reconstruction. Supply exactly one image to every generation call:

- Image 1: `sourceReference` (or legacy `personReference`), the exclusive content and identity authority.

Bind that exact repository-local file explicitly. Resolve its repository-relative path to a local absolute path only at the tool-call boundary and call the built-in image-edit tool with `referenced_image_paths` containing exactly that one resolved source path. Omit `num_last_images_to_include` entirely. Never use a recent conversation image, generated-image history, implicit attachment, or other context image. If the tool does not accept the explicit local path, fail the candidate; do not fall back.

Never attach, load for generation, or pass `styleReference`, any `styleReferences` member, any truth image, or any target/style image. The prompt text is the only carrier of the reconstructed style. A generation call containing any truth-set member path/hash, the truth-set hash, or a forbidden generation role is invalid and must fail the node.

Do not open validation/test manifests, fixtures, expected assertions, or evidence. Use the frozen prompt unchanged. The current training run has no case-specific optional-instruction suffix: the frozen prompt file is both the base prompt and exact effective prompt. Send its bytes verbatim; never summarize, normalize, paraphrase, or re-render it, and never append a source description or safety text at call time.

Before generation, require passed template validation, matching prompt hash, zero forbidden source-specific clauses, exact required literal checks, a sole-source-image role check, and a passed forbidden-style-image-input check.

This node is idempotent. Reuse only terminal candidates with matching prompt/source hashes and conformant provenance. Preserve failures, generate only missing ids, and issue independent missing calls concurrently when possible. A timeout may retry only missing ids with the same explicit `referenced_image_paths` binding. It must not resubmit a terminal candidate.

Save each result under `<targetDir>/<trainDir>/rounds/round-NNNN/candidates/candidate-NNN/` as `image.png` and `generation.json`. The record must conform to `workflow/generation-record-contract.json`, set identical base/effective prompt paths and hashes, persist canonical `{}` optional-instruction JSON and its hash, contain exactly one `input_images` entry with role `source_reference`, and contain no truth/style hash. In `provider_parameters.source_binding`, persist `mechanism: referenced_image_paths`, the one repository-relative requested source path and hash, and `recent_image_context_used: false`; never persist a machine-local absolute path. Recompute every persisted hash from disk.

Before accepting each output, inspect it against the exact source file. Require recognizable preservation of the source's subject/entities, object count, geometry, and spatial structure, allowing only the textual style transformation and authorized optional changes. If the output depicts a different source, especially any recent conversation or sealed validation/test image, record the tool attempt and observed mismatch under the candidate directory, do not write a successful `generation.json`, set state status `failed`, phase `review`, and `exitReason` to `source_binding_contaminated`. Do not judge, refine, or retry from the mismatched image.

Inspect outputs for corruption and missing source content. On complete success clear stale current-state generation failures while preserving attempt evidence, set state status `running`, phase `judge`, and update the timestamp.

Return adapter JSON only. On complete success:

```json
{
  "when": {
    "generation_succeeded": true
  },
  "payload": {
    "generation_succeeded": true,
    "status": "complete",
    "nextStep": "judge-candidates",
    "round": 1,
    "candidatePaths": []
  }
}
```

On any source-binding contamination or terminal batch failure, set both `when.generation_succeeded` and `payload.generation_succeeded` to false, set `nextStep` to `review-training`, preserve failure evidence, and return no successful candidate paths. Never return a failed generation in the success form.

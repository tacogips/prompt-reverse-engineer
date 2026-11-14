# Task

Normalize and validate the current round's `prompt/prompt.md` against `prompt-template-contract.json` before generation.

Copy every `required_literal_clauses` entry into the executable prompt body verbatim. A paraphrase does not pass. The learned artifact is a prompt-only style reconstruction template for an arbitrary source image. The source reference is Image 1 and the only generation image. The target/style truth is unavailable at generation time.

Read only `prompt-template-contract.json`, the current prompt and its metadata, any existing template validation, and minimal state. Do not open source images, target/style truth, analyses, manifests, fixtures, runtime snapshots, session logs, judge evidence, or earlier source-specific prompts.

Required behavior:

- Image 1 is the arbitrary source reference and exclusively controls depicted content and identity.
- The prompt itself explicitly describes the reconstructed visual style: medium, palette, contrast, lighting, line/mark quality, texture, abstract graphic vocabulary, and overrideable default composition language.
- No clause requires, mentions, or assumes a target/style reference image at generation time.
- Preserve observable source attributes unless an optional instruction overrides that exact attribute.
- Support optional `pose`, `composition`, `text`, and `additional` fields.
- Exact text is verbatim; absent text produces no text-like marks.
- Optional instructions outrank style defaults while unspecified attributes remain source-controlled.

Target-derived style clauses are required and are not overfitting. Source-specific content clauses are forbidden. Remove any literal or paraphrased description of a training or held-out source's identity, age, gender, ethnicity, face, hair, pose, clothing, objects, text, or scene. Also remove all style-image role instructions.

Rewrite minimally, recompute the prompt hash, and write `prompt/template-validation.json` with schema/contract versions, prompt path/hash, sole-source-role check, forbidden-generation-role check, optional fields, suspected source-specific clauses and dispositions, zero forbidden count, textual style-clause inventory, required literal exact checks, precedence check, complexity statistics, and status. Pass only when the prompt is self-contained as text, has zero source-specific clauses, and requires no style image.

Do not generate. On pass set state phase to `generate`; otherwise fail with an actionable diagnostic.

Return one JSON object only with `status`, `nextStep`, `round`, `promptPath`, `templateValidationPath`, `contractVersion`, and `forbiddenClauseCount`. Set `nextStep` to `generate-candidates` only on pass.

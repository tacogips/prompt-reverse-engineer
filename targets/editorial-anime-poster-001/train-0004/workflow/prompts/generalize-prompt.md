# Task

Normalize and validate the current round's `prompt/prompt.md` against `prompt-template-contract.json` before any image generation.

The learned artifact must be a reusable style-transfer template for an arbitrary source image. It must not describe the training source or any held-out source. Do not open the source image, source analysis, validation images, or sealed test manifest in this step. Detect concrete content clauses from the prompt itself and replace them with generic reference-driven invariants.

Required template behavior:

- Image 1 is the style reference only.
- Image 2 is the arbitrary source reference and exclusively controls depicted content and identity.
- Preserve all observable source attributes unless an explicit optional instruction overrides that exact attribute.
- Support optional `pose`, `composition`, `text`, and `additional` instructions.
- Exact text is verbatim and may affect only text/layout needed to place it.
- When optional text is absent, generate no text-like marks.
- Optional instructions have priority over style defaults, while unspecified attributes remain source-controlled.
- Describe only transferable style properties: medium, palette, contrast, line quality, texture, graphic vocabulary, and overrideable default composition language.

Forbidden content includes any literal or paraphrased description of a source's age, gender, ethnicity, skin, face, hair, gaze, expression, pose direction, clothing, accessories, logo, text, objects, or scene. Generic invariant names are allowed; observed values are not. Do not preserve a useful-looking specific clause merely because it lowered training loss.

Rewrite `prompt.md` minimally when necessary. Recompute its hash in `prompt/generation.json`. Write `prompt/template-validation.json` containing:

- schema and contract version;
- prompt path and SHA-256;
- required role and optional-field checks;
- every suspected subject-specific clause with classification and disposition;
- forbidden subject-specific clause count after normalization;
- style-clause inventory;
- optional-instruction precedence check;
- complexity statistics, including word count and style-clause count;
- status `passed` only when all checks pass and the forbidden count is zero.

Do not generate images. If safe normalization is impossible, set state status to `failed` with an actionable diagnostic. Otherwise set state phase to `generate`.

Return one JSON object only with `status`, `nextStep`, `round`, `promptPath`, `templateValidationPath`, `contractVersion`, and `forbiddenClauseCount`. Set `nextStep` to `generate-candidates` only when status is `passed`.

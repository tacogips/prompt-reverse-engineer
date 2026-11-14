# Task

Read `{{workflowInput}}`, state, the current generation prompt, `style-model.json`, `feedback-resolution.json`, current round winner, style truth, source truth, component losses, and judge evidence.

Create the next round directory. Write a revised `prompt/prompt.md` and `prompt/generation.json`. Make one evidence-driven reusable policy change focused on the dominant failed style-vector dimension, or on source/instruction preservation only when all style ceilings already pass. Explicitly preserve already-correct behavior. Do not optimize by changing the judge. Never paste current-source, teacher-content, or held-out-source descriptions into the prompt. Fix identity/content errors only through generic source-preservation instructions. Fix optional-instruction errors through generic precedence and adherence clauses. Fix style errors by improving the corresponding target-derived textual style clause. Never add a requirement for a style/target image at generation time.

Treat a proposal that improves similarity by adding the teacher's subject, pose, exact crop, object layout, text, or scene as overfitting and reject it. Record the affected `style-model.json` dimension and keep prompt clauses traceable to that model.

Human feedback remains an active acceptance gate across rounds. A missing skin, hair, clothing, or typography/dialogue treatment must be refined as a source-relative generator rule, not by copying the teacher person's literal attributes or wording.

Write `refinement.md` containing:

- observed dominant error;
- supporting judge evidence;
- exact prompt clauses added, removed, or changed;
- expected effect;
- regression risk.

Increment `state.json.round` by exactly one, set phase to `generalize`, and update its timestamp. Do not exceed `maxRefinementRounds`. The revised prompt must pass through `generalize-prompt` before another generation.

Return one JSON object only with `status`, `nextStep`, `round`, `promptPath`, `dominantError`, and `expectedEffect`. Set `nextStep` to `generalize-prompt`.

# Task

Read `{{workflowInput}}`, state, the current generation prompt, current round winner, style truth, person truth, component losses, and judge evidence.

Create the next round directory. Write a revised `prompt/prompt.md` and `prompt/generation.json`. Make one evidence-driven reusable policy change focused on the dominant training or transferability loss while explicitly preserving already-correct behavior. Do not optimize by changing the judge. Never paste current-source or held-out-source descriptions into the prompt. Fix identity/content errors only through generic source-preservation instructions. Fix optional-instruction errors through generic precedence and adherence clauses. Fix style errors by improving the target-derived textual style specification. Never add a requirement for a style/target image at generation time.

Write `refinement.md` containing:

- observed dominant error;
- supporting judge evidence;
- exact prompt clauses added, removed, or changed;
- expected effect;
- regression risk.

Increment `state.json.round` by exactly one, set phase to `generalize`, and update its timestamp. Do not exceed `maxRefinementRounds`. The revised prompt must pass through `generalize-prompt` before another generation.

Return one JSON object only with `status`, `nextStep`, `round`, `promptPath`, `dominantError`, and `expectedEffect`. Set `nextStep` to `generalize-prompt`.

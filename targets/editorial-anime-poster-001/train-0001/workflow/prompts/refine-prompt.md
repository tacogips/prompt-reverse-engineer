# Task

Read `{{workflowInput}}`, state, the current generation prompt, current round winner, style truth, person truth, component losses, and judge evidence.

Create the next round directory. Write a revised `prompt/prompt.md` and `prompt/generation.json`. Make one evidence-driven policy change focused on the dominant weighted loss while explicitly preserving already-correct attributes. Do not optimize by changing the judge. Do not paste unsupported identity descriptions into the prompt; continue to use the person image as identity truth.

Write `refinement.md` containing:

- observed dominant error;
- supporting judge evidence;
- exact prompt clauses added, removed, or changed;
- expected effect;
- regression risk.

Increment `state.json.round` by exactly one, set phase to `generate`, and update its timestamp. Do not exceed `maxRefinementRounds`.

Return one JSON object only with `status`, `nextStep`, `round`, `promptPath`, `dominantError`, and `expectedEffect`. Set `nextStep` to `generate-candidates`.

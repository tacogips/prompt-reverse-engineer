# Task

Act as the versioned multimodal loss function. Read `{{workflowInput}}`, state, judge prompt/config, the style truth, person truth, and every current-round candidate. Inspect images at original resolution.

Judge each candidate independently. Do not reward prompt wording or intent that is not visible. Do not compare candidates to each other until their absolute assessments are complete. For each candidate, persist all observations to `judge.json` and compute `metrics.json` deterministically with these weights:

- identity: 0.30
- semantic: 0.10
- composition: 0.15
- color: 0.15
- style: 0.25
- technical: 0.05

All component losses and total loss are in `[0,1]`; lower is better. Reward is `1 - total_loss`. Evidence must mention concrete visible matches or differences. Penalize copying the style-reference person's identity. Evaluate identity against the person reference and visual style against the style truth.

Write the round's `selection.json` with the deterministic lowest-loss winner and tie-break by candidate id. Compare it with the global best in state and retain the lower-loss candidate.

Then update state:

- If best loss <= `targetLoss`: set `exitReason` to `target_loss_reached` and phase to `review`.
- Else if current round >= `maxRefinementRounds`: set `exitReason` to `max_refinement_rounds` and phase to `review`.
- Otherwise: set phase to `refine`.

Never change judge instructions or weights during a run. Never lower a score to manufacture convergence.

Return adapter JSON only:

```json
{
  "when": {
    "stop_training": false
  },
  "payload": {
    "stop_training": false,
    "nextStep": "refine-prompt",
    "round": 1,
    "selectedCandidate": "repository-relative-path",
    "totalLoss": 0.5,
    "reward": 0.5,
    "exitReason": null
  }
}
```

Set both `when.stop_training` and `payload.stop_training` to true exactly when the target loss is reached or maximum refinement rounds are exhausted. In that case set `nextStep` to `review-training` and provide the exact exit reason.

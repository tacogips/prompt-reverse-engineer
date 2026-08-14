# Refinement: round 0002

## Observed dominant error

No style-vector loss can be measured for round 0001: generation was moderation-blocked before any candidate image was persisted. The affected refinement target is therefore the lowest-confidence transferable style-model dimension, `graphic_language` (confidence 0.88), rather than a fabricated candidate loss or source-specific diagnosis.

## Supporting judge and execution evidence

- No current round winner, component losses, or judge evidence exists because `selection.json` records `no_eligible_candidate`.
- `candidates/attempts/attempt-0001.json` records `moderation_blocked` at the output stage for all three attempted candidates and confirms that no output artifact was persisted.
- Direct style-truth inspection supports a reusable hierarchy of broad opaque fields, a source-controlled focal form, and sparse fine linear ornament. This evidence is used only as the `graphic_language` style model; no subject, pose, readable text, crop, concrete geometry, or scene is introduced.

## Exact prompt clauses changed

- Removed: "layered abstract circles, panels, and diagonal color bands around the source-controlled content, plus fine orbital line-and-dot ornament."
- Added: "a deliberate three-level print hierarchy: broad opaque color fields first, the source-controlled focal form second, then sparse fine orbital line-and-dot accents. Let abstract layers frame rather than replace the source-controlled content, with no copied geometry or fixed placement."
- Affected `style-model.json` dimension: `graphic_language`; its transferable rule and clause inventory now use the same three-level hierarchy.

## Expected effect

The prompt should more reliably produce the reusable editorial print hierarchy and negative-space rhythm while retaining all previously specified medium, palette, line, texture, source-preservation, and optional-instruction behavior.

## Regression risk

The added hierarchy may cause excessive background abstraction or reduced source prominence. The explicit framing and source-preservation clauses are retained to constrain that risk. No claim of improvement is made until a candidate is generated and judged.

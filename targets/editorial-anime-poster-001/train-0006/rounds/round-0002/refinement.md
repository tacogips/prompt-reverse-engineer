# Refinement Record

## Observed dominant error

Held-out baseline source-fidelity preservation failed: a source support structure was omitted even though the numerical validation thresholds passed.

## Supporting judge evidence

- `transferability/evaluation.json` records the failed `heldout-a-baseline` source-preservation assertion.
- The training winner's judge evidence shows that source markings and setting detail can be retained, while the other training evidence identifies loss of source garment detail and environmental specificity when stylization becomes too reductive.

## Exact prompt clauses changed

- Added: “Preserve every unspecified source-controlled attribute, including visible markings, material details, and scene or support structures that establish the source content.”
- Added: “Apply style by translating their visual treatment, never by deleting, simplifying, or replacing those source-controlled details.”
- Changed the negative prompt to explicitly preserve visible markings, material details, and scene or support structures unless an optional field requests the relevant change.

## Expected effect

The next generation should retain recognizability-critical source details and source scene structure while preserving the existing style-reference-only visual transfer and the already-passing pose, composition, and exact-text handling.

## Regression risk

More complete source-detail retention may compete with the style reference's simplified poster framing or add visual density. The explicit precedence and style-treatment wording are intended to retain stylization without allowing detail loss.

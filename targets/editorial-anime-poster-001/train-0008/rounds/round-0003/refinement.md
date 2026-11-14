# Refinement: Round 0003

## Affected style-model dimension

`palette_tone` in `targets/editorial-anime-poster-001/train-0008/style-model.json`.

## Observed dominant error

`palette_tone` is tied for the highest reusable-style loss at 0.22. The current background treatment reads too brushy and insufficiently like bounded opaque editorial print fields.

## Supporting judge evidence

- The judge found the required palette hues and restrained gold accents present, but judged the large coral and mustard areas to be less like opaque graphic color blocks.
- The judge's leading transferable difference was to use more clearly bounded opaque teal, coral, and mustard support fields instead of predominantly brushy background areas.

## Exact prompt changes

- Added to the positive prompt: “Render the teal, coral-pink, and mustard support fields as clearly bounded opaque print shapes with firm edges and only limited dry-brush interruption, rather than loose painterly background washes.”
- Added to the negative prompt: “loose painterly background washes”.
- Retained the existing medium/rendering, line/shape, texture/material, graphic-language, source-preservation, and optional-instruction clauses unchanged.

## Expected effect

This should increase the clarity of the limited-palette print system and make the large support fields read as opaque, bounded ink shapes while keeping the established paper texture and source-controlled content intact.

## Regression risk

Excessively rigid fields could suppress the already-correct restrained dry-brush texture or crowd source-controlled scene detail. The revision therefore permits limited dry-brush interruption and retains the clause requiring abstract layers to frame rather than replace source content.

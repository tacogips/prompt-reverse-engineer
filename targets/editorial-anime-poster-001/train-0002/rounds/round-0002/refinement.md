# Refinement: Round 0002

## Observed dominant error

Style is the dominant weighted error: 0.13 style loss at a 0.20 weight (weighted contribution 0.026), exceeding identity (0.12 at 0.20, 0.024), composition (0.06 at 0.20, 0.012), color (0.025 at 0.15, 0.00375), semantic (0.01 at 0.15, 0.0015), and technical (0.01 at 0.10, 0.001). The winner is too smoothly modeled and lacks enough fine variable contour and layered garment detail from the transferable style language.

## Supporting judge evidence

- Style evidence: “the face and hair are more smoothly modeled, with less delicate contour variation, fewer loose flyaway lines, and simpler layered garment detail.”
- Identity evidence to preserve: the candidate “closely retains” the referenced facial geometry and short close-sided quiff, but “the quiff is much larger and more windblown than the photo.”
- Preserved strengths: the judge found the man’s identity retained; the style-reference woman’s identity and accessories absent; the 2:3 poster composition, palette, and graphic field elements present; and no visible technical defects or pseudo-text.

## Exact prompt clauses changed

- Replaced `an airy crown of fine ink flyaways that follows Image 2’s short haircut` with `a sparse contour-following halo of fine loose ink flyaways that follows Image 2’s compact short haircut without adding hair mass`.
- Changed `crisp deep-navy variable-width ink contours` to emphasize `variable-width` in the style clause.
- Changed garment detail from `delicate abstract line accents` to `delicate layered seam panels, and fine navy-and-gold abstract line accents`.
- Added negative clause: `Avoid exaggerated hair volume, hair extending beyond a short swept-up quiff silhouette`.

## Expected effect

The candidate should gain the reference’s delicate variable-width ink energy and more layered editorial garment treatment, reducing style loss, while the bounded flyaway clause keeps the subject’s short compact quiff and already-strong identity recognition intact.

## Regression risk

Fine flyaways or garment layering can be overinterpreted as extra hair volume, ornate clothing, or copying the style reference’s accessories. The explicit compact-hair and no-accessory constraints are retained to contain that risk; if it occurs, identity loss may rise despite style improvement.

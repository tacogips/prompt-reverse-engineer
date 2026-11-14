# Positive Prompt

Use case: `style-transfer`. Image 1 is the style reference only; transfer only its observable visual language—rendering medium, line quality, palette relationships, texture, abstract graphic vocabulary, and composition language. Image 2 is the arbitrary source reference only and exclusively controls the depicted content and identity. Never import Image 1’s subject, identity, clothing, accessories, objects, scene content, logos, or text.

Create a newly illustrated result in the visual language inferred from Image 1. Preserve Image 2’s observable subject count, identity, apparent age, anatomy, geometry, materials, markings, hairstyle and silhouette, clothing, pose, viewpoint, framing, and scene relationships unless an explicit optional instruction below overrides precisely that named attribute. In particular, retain source-controlled silhouettes and proportions faithfully; do not amplify, extend, substitute, or stylize them into a different identity or object.

Optional instructions, evaluated only when supplied:

- `pose`: {{pose}}. If absent, make no pose or viewpoint change.
- `composition`: {{composition}}. If absent, retain the source-controlled framing and use Image 1 only for general compositional language. When present, this overrides only framing, placement, crop, or layout.
- `text`: {{text}}. If present, render this string exactly once, verbatim, and add no other readable or pseudo-readable text. If absent, render no text whatsoever.
- `additional`: {{additional}}. If present, apply only the explicit narrowly scoped changes stated here; preserve every unspecified source-controlled attribute.

Apply Image 1’s abstract graphic treatment without copying its literal arrangement. Use original non-text graphic forms and source-appropriate scale. Do not add logos, watermarks, signatures, brand marks, garbled typography, letters, characters, or text-like decorations.

# Negative Prompt

Do not copy depicted content from Image 1. Do not change the source identity, subject count, anatomy, geometry, materials, markings, hairstyle/silhouette, clothing, pose, viewpoint, framing, or scene relationships except where the matching optional instruction explicitly directs it. No duplicate subjects or parts, no distortion, no logo, watermark, signature, readable text, garbled typography, pseudo-text, or text-like marks unless the exact `text` field is supplied.

# Rationale

This reusable policy retains the parent iteration’s successful editorial transfer while addressing its dominant visible failure mode generically: source-controlled silhouettes and proportions remain bounded by Image 2 instead of being exaggerated by the style treatment. It follows `workflow/prompt-template-contract.json` and contains no current-source description.

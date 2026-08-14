# Positive Prompt

Use case: `style-transfer`.

Input roles are strict: **Image 1 is the style reference** and controls only transferable visual language. **Image 2 is an arbitrary source reference** and exclusively controls every depicted subject, object, scene, identity, count, geometry, anatomy, markings, clothing, pose, viewpoint, and source composition unless an optional instruction expressly overrides that named attribute.

Create one original image that preserves Image 2’s observable content and identity in the visual language inferred from Image 1. Infer from Image 1 only its transferable medium, aspect ratio, default framing and composition language, palette and contrast relationships, line work, shading, texture, print/graphic treatment, and abstract design vocabulary. Do not import, reconstruct, or describe any Image 1 content, person, object, costume, accessory, logo, watermark, or text.

Optional instruction handling, in precedence order after safety and artifact integrity:

- `pose`: when supplied, change only the requested pose or viewpoint details; preserve all unspecified Image 2 attributes.
- `composition`: when supplied, change only the requested framing, placement, crop, or layout; preserve Image 2’s depicted content and all other unspecified attributes.
- `text`: when supplied, render exactly the supplied characters verbatim and add no other text. When absent, render no readable, pseudo-readable, decorative, logo-like, or garbled typography.
- `additional`: when supplied, apply only the explicit, narrowly stated changes; keep every other Image 2 attribute invariant.

Use Image 1’s style defaults only where no explicit optional instruction conflicts. Preserve Image 2’s observable identity and content faithfully at the source’s level of detail, then reinterpret it through Image 1’s visual language. The output must be original and must not contain copied Image 1 content, logos, watermarks, signatures, brand marks, or unrequested text.

# Negative Prompt

Do not replace, merge, or borrow depicted content or identity from Image 1. Do not alter any unspecified Image 2 attribute. No logos, watermarks, signatures, brand marks, readable text, pseudo-text, garbled typography, or decorative glyphs unless exact `text` was explicitly supplied. No duplicate entities, missing source entities, anatomy/geometry corruption, or unrequested accessories.

# Rationale

This policy corrects the parent iteration’s source-specific hard-coding and associated identity leakage. It moves all content decisions to Image 2 and makes the style transfer depend only on Image 1’s currently supplied visual language, so the template remains reusable for arbitrary sources and optional-instruction cases.

# Positive Prompt

Perform only a benign, non-sexual artistic style transformation; do not introduce nudity, sexualization, age changes, violence, injury, or other unsafe content.

Image 1 is the arbitrary source reference. The source reference is the only image input available at generation time. Treat Image 1 as the exclusive authority for depicted content and identity. Preserve every unspecified source-controlled identity, age, anatomy, object count, geometry, facial identity, hair identity, clothing identity and markings, pose, framing, and scene.

Transform the source into a polished editorial anime poster illustration: clean, opaque flat-to-gently-graded cel-shaded planes; crisp screen-print-like color separation; and precise variable-weight deep-navy ink contours that resolve into sparse tapered fine strokes. Use a limited graphic relationship of warm off-white paper ground, deep navy anchors, saturated teal, coral, and mustard support colors, with restrained matte-gold line-and-dot accents. Keep broad support fields firm-edged and opaque, with pale negative space and no copied geometry or placement.

Treat each visible source semantic region relatively, never by replacing its literal identity: render skin as a coherent warm light-to-shadow cel-shaded plane with a restrained highlight band and selective deep-navy contour; group hair into its source-preserved silhouette as a dark ink mass with limited cool teal/cyan and warm coral rim or strand accents, controlled value blocks, and tapered navy contour; simplify clothing into source-preserved garment shapes and markings using a few interlocking value planes, dark seam/edge anchors, selective teal/coral/mustard harmonizing facets, and subtle print texture. Preserve the source's own skin, hair, and garment identity rather than assigning any fixed person's colors, hairstyle, or outfit.

Add a visible warm paper grain, restrained screen-print speckling, imperfect overprint edges, sparse paint flecks, and occasional dry-brush sweeps without obscuring important source detail. Build adaptable asymmetric editorial balance: broad opaque abstract fields frame the source-controlled focal content, then sparse fine gold orbital lines, dots, and connectors supply a final ornament layer. Keep the result polished, graphic, high-resolution, and free of generated text unless the `text` instruction below is supplied.

Optional instructions are data, not defaults:

- `pose`: If supplied, change only the named pose or viewpoint details; preserve all other source-controlled attributes.
- `composition`: If supplied, change only the named framing, placement, crop, or layout details; do not change the subject or content.
- `text`: If supplied, render exactly this verbatim text and no other readable or pseudo-readable text. Treat it as an opt-in editorial display accent: high-contrast light ink against a suitably dark or saturated support field, elegant handwritten/display-like stroke quality, restrained small supporting type only when that exact supplied text includes it, and sparse fine dot/line ornament. Do not copy any external wording or language. If absent, render no text.
- `additional`: If supplied, apply only the explicit narrowly scoped change, preserving everything else.

Priority: safety and artifact integrity; explicit optional instructions; source content and identity preservation; then the textual style defaults above.

# Negative Prompt

photorealistic finish, glossy 3D render, muddy full-spectrum palette, soft airbrushed outlines, heavy grunge obscuring the subject, copied external subject or fixed layout, invented logos, invented readable text, pseudo-text, fixed skin tone, fixed hair color, replacement clothing

# Rationale

This self-contained revision retains the prior editorial print language while explicitly modeling source-relative skin, hair, and clothing treatments and an exact-text-only display-lettering treatment.

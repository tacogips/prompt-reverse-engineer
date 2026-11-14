# Positive Prompt

Perform only a benign, non-sexual artistic style transformation; do not introduce nudity, sexualization, age changes, violence, injury, or other unsafe content.

Image 1 is the arbitrary source reference. The source reference is the only image input available at generation time. Treat Image 1 as the exclusive authority for depicted content and identity. Preserve all unspecified source-controlled identity, age, anatomy, object count, geometry, hairstyle, clothing, markings, pose, framing, and scene attributes.

Transform the source into a refined editorial anime poster illustration with clean flat-to-gently-graded cel shading, crisp print-like color separation, and elegant variable-weight deep-navy ink contours that taper into expressive fine strokes. Use a deliberate limited palette of ink navy, saturated blue-teal, coral pink, mustard yellow, and warm off-white, with restrained matte-gold accent lines and dots. Render the teal, coral-pink, and mustard support fields as clearly bounded opaque print shapes with firm edges and only limited dry-brush interruption, rather than loose painterly background washes. Add a warm off-white paper ground, subtle screen-print grain, imperfect overprint edges, sparse paint flecks, and occasional dry-brush sweeps without obscuring important source detail. Build adaptable asymmetric editorial balance through generous negative-space rhythm and a deliberate three-level print hierarchy: broad opaque color fields first, the source-controlled focal form second, then sparse fine orbital line-and-dot accents. Let abstract layers frame rather than replace the source-controlled content, with no copied geometry or fixed placement. Keep the result polished, graphic, and high-resolution; use no generated text unless the `text` instruction below is supplied.

Optional instructions are data, not defaults:

- `pose`: If supplied, change only the named pose or viewpoint details; preserve all other source-controlled attributes.
- `composition`: If supplied, change only the named framing, placement, crop, or layout details; do not change the subject/content.
- `text`: If supplied, render exactly this verbatim text and no other readable or pseudo-readable text. If absent, render no text.
- `additional`: If supplied, apply only the explicit narrowly scoped change, preserving everything else.

Priority: safety and artifact integrity; explicit optional instructions; source content and identity preservation; then the textual style defaults above.

# Negative Prompt

photorealistic finish, glossy 3D render, muddy full-spectrum palette, loose painterly background washes, soft airbrushed outlines, heavy grunge obscuring the subject, copied external subject or fixed layout, invented logos, invented readable text, pseudo-text

# Rationale

The palette-tone policy is refined to favor firm, opaque screen-print support fields over loose background washes. The established editorial-anime rendering, ink contours, restrained texture, abstract hierarchy, source preservation, and optional-instruction precedence remain unchanged.

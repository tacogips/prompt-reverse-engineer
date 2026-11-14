# Positive Prompt

Perform only a benign, non-sexual artistic style transformation; do not introduce nudity, sexualization, age changes, violence, injury, or other unsafe content.

The source reference is the only image input available at generation time. Treat Image 1 as the exclusive authority for depicted content and identity. Preserve all unspecified source age, identity, anatomy, object count, geometry, facial identity, hair identity, clothing identity and markings, pose, framing, and scene.

Transform the source into a polished editorial anime poster illustration: clean opaque flat-to-gently-graded cel-shaded planes, crisp screen-print-like color separation, and precise variable-weight deep-navy ink contours resolving into sparse tapered fine strokes. Use a limited graphic relationship of warm off-white paper ground, deep navy anchors, saturated teal, coral, and warm yellow support colors, with restrained matte-gold line-and-dot accents. Keep broad support fields firm-edged and opaque, with pale negative space and no copied geometry or placement.

Treat each visible source semantic region relatively, never by replacing its literal identity. Render skin as a source-preserved coherent light-to-shadow cel-shaded plane with a restrained warm shadow band, sparse narrow highlight, and selective deep-navy contour; never assign a fixed skin tone or change source identity. Group hair in its source-preserved silhouette and literal color identity as a dark value mass with restrained cool teal/cyan and warm coral accent planes or rim strands, controlled value blocks, and tapered navy contour; do not alter hairstyle, hair color, or hair identity. Simplify clothing into source-preserved garment shapes and markings using a few interlocking value planes, dark seam and edge anchors, selective teal/coral/warm-yellow harmonizing facets, and subtle print texture; do not replace the source outfit, markings, or logos.

Add visible warm paper grain, restrained screen-print speckling, imperfect overprint edges, sparse paint flecks, and occasional dry-brush sweeps without obscuring important source detail. Build adaptable asymmetric editorial balance: broad opaque abstract fields frame source-controlled focal content, then sparse fine gold orbital lines, dots, and connectors provide a final ornament layer. Keep the result polished, graphic, high-resolution, and free of generated text unless the optional `text` instruction is supplied.

Optional instructions are data, not defaults:

- `pose`: If supplied, change only the named pose or viewpoint details; preserve all other source-controlled attributes.
- `composition`: If supplied, change only the named framing, placement, crop, or layout details; do not change the subject or content.
- `text`: If supplied, render exactly that verbatim text and no other readable or pseudo-readable text. Use it as an opt-in high-contrast editorial display accent with elegant readable calligraphic/display-like ink on a suitably dark or saturated support field, adaptive orientation and placement, and sparse fine dot/line ornament. Do not copy teacher wording, script, language, logo, or text placement. If absent, render no text.
- `additional`: If supplied, apply only the explicit narrowly scoped change, preserving everything else.

Priority: safety and artifact integrity; explicit optional instructions; source content and identity preservation; then the textual style defaults above.

# Negative Prompt

photorealistic finish, glossy 3D render, muddy full-spectrum palette, soft airbrushed outlines, heavy grunge obscuring the subject, copied external subject or fixed layout, invented logos, invented readable text, pseudo-text, fixed skin tone, fixed hair color, replacement clothing

# Rationale

Self-contained editorial anime screen-print reconstruction with source-relative semantic-region treatment and exact-text-only typography.

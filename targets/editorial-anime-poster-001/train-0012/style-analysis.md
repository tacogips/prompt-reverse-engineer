# Ensemble style analysis — train-0012

## Evidence boundary

The five immutable reference images were inspected at original resolution only as analysis and future judge evidence. The training source was inspected only to set the content-preservation boundary. Neither the reference set nor any reference member can be an input to generation. This analysis deliberately separates recurrent visual language from the individual people, props, wording, poses, crops, and layouts shown by the references.

## Per-reference observations

| Reference | Direct observation | Recurrent-style evidence | Excluded per-image content |
| --- | --- | --- | --- |
| `truth/style-reference.png` | Crisp anime portrait rendering; large warm-paper field, saturated color masses, fine dark ink, dry-brush and speckle. | Supports cel planes, navy containment, paper/overprint texture, abstract discs/rules, and restrained display lettering. | Person, jewelry, garment, words, language, portrait crop, and exact colored-field geometry. |
| `style-sample-01.jpg` | Full-figure editorial poster with bright teal/coral fields, broad brush sweep, open negative space, small display type. | Supports source-preserving garment facets, limited print palette, asymmetric hierarchy, and conditional typography. | Person, outfit, walking pose, interior setting, wording, and placement. |
| `style-sample-02.jpg` | Portrait poster with teal, magenta, yellow, black ink/brush accents, dots, arcs, and both display and informational text. | Strengthens the adaptable support-form, line/dot ornament, and hierarchy vocabulary across a different garment and crop. | Person, cap, shirt, all words/languages, pose, and exact diagram-like shapes. |
| `style-sample-03.jpg` | Bright orange/magenta/teal poster; portrait rendering integrated with graphic swashes, dots, open paper field, and expressive lettering. | Confirms energetic but controlled print overmarking, dark tapered contours, paper ground, and conditional display text. | Person, headwear, accessories, wording, symbols, crop, and swash positions. |
| `style-sample-04.jpg` | Full-figure editorial illustration with deeper navy/green/orange relationship, circular forms, fine orbit lines, plant/animal motifs, and display text. | Confirms the style works with a darker palette variant and that illustration, paper grain, layered forms, and fine ornament recur beyond the portrait examples. | Person, objects, animal/plant motifs, room-like scene, wording, pose, crop, and layout. |

## Recurrent transferable visual language

### Medium and rendering

Polished editorial anime illustration recurs in all five references: source forms are reconstructed as clear, deliberately graphic shapes with crisp opaque print separation, dark precise ink, and bounded cel-shaded value planes rather than photographic gradients or 3D rendering. Fine detail is concentrated at focal forms while support fields remain bold and flat.

### Palette and tonal behavior

All references use a warm off-white, paper-like ground and a deliberately limited high-contrast poster palette. Deep navy or near-black provides anchoring; teal/cyan, coral/magenta or orange/red, and yellow/ochre act as saturated supports. Individual literal palette selections vary, so the reusable rule is relational: preserve the source's literal regional identity while organizing it into clear light/mid/shadow planes, with restrained high-chroma accent relationships and small muted-gold/ochre line or dot accents.

### Line and shape language

Deep-navy/near-black variable-weight contours, tapered loose ink extensions, clean internal construction lines, cropped discs, blocks, rules, arcs, brush sweeps, dots, halftone clusters, and fine connector/orbit lines recur. They form an adaptable vocabulary around source-controlled content; no reference's exact silhouette, coordinate, or geometry is a style requirement.

### Texture, material, and mark making

Warm paper grain remains visible beneath opaque regions. Screen-print speckling, occasional halftone, broken overprint edges, dry-brush interruptions, and sparse flecks make the work tactile. The behavior is controlled and legibility-preserving, not global dirt, aging, or arbitrary noise.

### Abstract graphic vocabulary and conditional lettering

The shared hierarchy is asymmetrical and editorial: broad opaque support masses establish rhythm; source content remains the primary focal element; sparse ink/gold lines, dots, arcs, and brush accents complete the frame. Several references contain lettering, but its language, wording, location, angle, amount, and script vary. The inferred transferable rule is therefore conditional: if and only if exact caller text is supplied, treat that one string as a readable editorial display accent, placed in available negative space with restrained line/dot ornament. Otherwise render no readable or pseudo-readable text.

## Semantic-region treatment

- Skin: recurrent rendering behavior is luminous source-relative light planes, restrained warmer shadow bands, narrow highlights, and selective dark containment—not a fixed complexion.
- Hair: preserve the source's hair identity and silhouette; group it into coherent value masses with limited relative cool/warm accent planes and tapered ink containment—not the references' particular hair colors or arrangements.
- Clothing: preserve the source garment, construction, markings, logos, and literal color identity; use only fold-following value facets, dark seam/edge anchors, restrained accent edges, and mild overprint grain—not a replacement costume or reference palette.

## Inference strength and exclusions

The recurrent observations above occur across distinct people, poses, crops, color variants, props, and text systems, so they are strong hidden-prompt candidates. Per-image subject identity, anatomy, hair arrangement, clothing, accessories, objects, written language, exact wording, pose, crop, concrete layout, scene, brushstroke trajectory, and stochastic fleck placement are excluded. The training source's observed identity and content are also excluded from the reusable prompt; it is preserved only through generic source-authority instructions.

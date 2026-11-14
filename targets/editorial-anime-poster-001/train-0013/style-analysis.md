# Ensemble style analysis — five immutable references

## Evidence boundary

The five named style references were inspected at original resolution as analysis-and-judge evidence only. The training source was inspected separately only to define content-preservation requirements. No current validation or sealed-test manifest, fixture, or image was opened. Teacher subjects, objects, readable wording, languages, pose, crop, concrete geometry, and scenes are excluded from the reusable prompt.

## Per-reference observations

| Reference | Direct observable rendering and material | Palette / line / graphic observations | Content or stochastic variation excluded from the style prompt |
| --- | --- | --- | --- |
| `style-reference.png` | Highly finished anime portrait; bounded cel planes, fine dark contours, warm paper, scuffs and flecks. | Navy with teal, coral, yellow, and gold; large discs and blocks; delicate orbit lines; display word plus smaller Japanese copy. | Portrait identity, accessories, garment construction, text, profile pose, oversized head crop, exact discs and blocks. |
| `style-sample-01.jpg` | Full-figure editorial illustration with opaque garment facets, paper ground, halftone field, and dry-brush streak. | Teal/coral/cream/yellow relationship; thin ochre lines and sparse calligraphic lettering in open space. | Walking figure, garment, doorway-like drawing, word, Japanese copy, figure scale and layout. |
| `style-sample-02.jpg` | Anime figure with smooth bounded face planes and more aggressive ink/brush interruption. | Cream, teal, black, magenta, yellow; collage wedges, halftone dots, loops, angular rules, multiple text blocks. | Cap, sleeveless garment, individual slogans/language, exact diagram-like shapes and placements. |
| `style-sample-03.jpg` | Fine anime portrait rendering over tactile paper with colored brush overlays and ink arcs. | Cream with hot pink, orange, teal, yellow and black; cropped circles, dots, curved rules and handwritten/display lettering. | Headwrap, jewelry, garment decoration, words, language, pose, exact color choice and field coordinates. |
| `style-sample-04.jpg` | Full-figure editorial rendering, controlled cel facets, printed grain, rough arc, and fine outlined botanical accents. | More muted cream, deep teal/navy, green and orange proves the palette is a relationship rather than fixed swatches; circles, rectangles, orbital connectors. | Male subject, cat, plants, books, clothing, word, scene objects, pose, and exact geometry. |

## Direct observations repeated across the truth set

### Medium and rendering

- Polished editorial anime illustration, midway between fashion-poster illustration and graphic print; not photorealism, 3D, or generic flat iconography.
- Opaque, deliberately bounded color planes with concise cel-style light and shadow grouping; localized fine rendering is reserved for focal anatomy and key object edges.
- A single source-controlled focal subject or object sits within a designed poster field. This is a hierarchy, not a requirement to copy any teacher crop or subject scale.

### Palette and tonal behavior

- A light warm-paper ground is recurrent. Dark navy, near-black, or deep teal provides structural anchoring; saturated coral/magenta, teal/cyan, yellow/orange, and occasional muted metallic/ochre accents create controlled contrast.
- The exact palette varies materially, especially in sample 04, so the transferable rule is limited warm-paper print relationships, strong dark anchors, and a small coordinated accent set—not literal teacher swatches or coordinates.
- Skin-like planes are luminous but restrained, with clean shadow bands, small highlights, and selective dark containment. Hair-like regions retain a coherent dark or source-relative mass with a few differentiated value planes. Garments are simplified into fold-led facets and seam anchors rather than redesigned.

### Line, shape, and mark making

- Confident variable-weight dark ink contours alternate with very fine tapered lines; loose arcs, connectors, and edge extensions lend energy without becoming sketch clutter.
- Recurrent abstract vocabulary: cropped discs, broad blocks/wedges, vertical or angled rules, halftone fields, thin orbital curves, dots, brush sweeps, and occasional outlined decorative motifs. These are adaptable building blocks, never fixed geometry.
- Mark making is mixed: restrained overprint wear, halftone or stipple, paint flecks, broken brush passes, and dry-brush edges. It remains subordinate to source legibility.

### Texture and material

- Warm off-white paper visibility, light screen-print grain, small speckles, broken printed edges, and sparse painterly abrasion repeat in all five images.
- Texture density varies, with samples 02–03 more energetic; therefore use restrained, selectively placed texture rather than mandatory heavy splatter or a copied brush trajectory.

### Abstract graphic vocabulary and conditional typography/dialogue

- Recurrent hierarchy: a paper field, broad opaque support shapes, source-controlled focal content, then fine line/dot/halftone or brush ornament. Balance is asymmetric, with usable negative space.
- Multiple references contain readable display lettering plus smaller copy, but wording, language, amount, orientation, and exact location vary. The reusable treatment is conditional: when caller text exists, render only that exact text once as a readable editorial display accent; without caller text, render no text or pseudo-text.

## Inferred transferable style specification

Use a source-only polished editorial anime poster treatment: warm paper, limited coordinated print palette, opaque cel facets, precise variable dark ink, tactful screen-print wear, and adaptable collage-like abstract fields. Preserve source content and literal identity; translate skin, hair, and clothing only through relative value grouping, bounded shading, selective contours, fold-following facets, and print material. Let caller-supplied optional instructions narrowly override pose, composition, text, or additional requested attributes. Never invent lettering when exact text is absent.

## Deliberately excluded evidence

The following are per-image content or non-transferable variation: every depicted person and identity, hairstyle, apparel, accessory, object, animal, plant, scene, logo, readable word/language, pose, viewpoint, crop, exact field coordinate, individual circle/block/wedge, brush trajectory, and individual color assignment. The training-source person's appearance, clothing, visible logo, pose, interface marks, and setting are likewise source-fidelity evidence only and never reusable prompt content.

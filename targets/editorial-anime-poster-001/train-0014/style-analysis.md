# Five-reference style analysis

## Evidence boundary

The five immutable references were inspected as style evidence only. The training source was inspected only to define what must remain source-controlled. The canonical ordered style-reference set was recomputed with `workflow/scripts/compute-style-reference-set-hash.sh`; its canonical JSON hash is `805f0db0aec28aa2f7a74819d572c501a8a2406106de0f159b82ba929cabfc39`.

| Reference | Direct observations | Content excluded from prompt |
| --- | --- | --- |
| `truth/style-reference.png` | Close editorial portrait; warm paper, navy ink, saturated cyan/coral/yellow fields, gold orbital ornament, faceted apparel and a single display-word treatment. | Person, jewelry, garment, word, script, head angle, portrait crop, circle coordinates. |
| `style-sample-01.jpg` | Full-figure fashion image with teal/coral garment planes; large color discs, dry brush swath, fine gold line work, ample paper negative space. | Figure, outfit, footwear, doorway, phrase, exact pose and placement. |
| `style-sample-02.jpg` | Portrait with broad geometric panels, halftone/brush textures, navy contour and diverse text hierarchy. | Cap, vest, watch, wording/language, exact collage arrangement. |
| `style-sample-03.jpg` | Portrait with vivid pink/orange/teal support fields, ornamental clothing facets, dots, thin loops, and display lettering. | Headwrap, jewelry, wording/language, figure, crop, positions. |
| `style-sample-04.jpg` | Full figure with restrained dark-green/navy/orange print palette, paper texture, circular fields, botanical and orbit-like line motifs. | Man, animals, plants, props, wording, room scene, walking pose. |

## Recurring reusable visual language

- **Medium/rendering:** polished anime/editorial illustration with observed forms rebuilt in opaque, crisply separated color planes; controlled two-to-three-value cel shading; detailed focal linework rather than photographic continuous shading.
- **Palette/tonal behavior:** warm off-white paper ground, deep navy structural ink, and a high-chroma print accent family spanning teal/cyan, coral/pink or orange, and yellow/gold. Individual references choose different dominant accents, so the reusable rule is the limited relational system, not an exact swatch assignment. Light planes and dark navy anchors create contrast; gradients are limited.
- **Line/shape language:** confident tapered navy contours, fine loose ink hairs at selected edges, large cropped discs/arcs/blocks, thin rules, brush swaths, dots, halftone clusters, and orbit-like connectors. These components recur but their geometry and locations do not.
- **Texture/material and mark making:** visible lightly fibrous paper; restrained screen-print grain, stipple, occasional broken overprint, dry-brush sweeps, and sparse paint flecks. Texture is graphic and deliberate, never a blanket degradation of focal source details.
- **Graphic vocabulary:** asymmetric editorial layering—large abstract support masses, source-controlled focal content, then fine gold or ink ornament. Negative space is active and adaptable. Typography, when present, is a mixed editorial system: one readable calligraphic/display accent plus smaller clean type or linework; exact language, wording, scale, placement, and number of text blocks vary and therefore are not hidden-prompt constants.

## Per-image variation and explicit exclusions

No fixed subject, age, identity, skin tone, hairstyle, clothes, objects, animal, plant, architecture, narrative, readable wording, language, script, pose, crop, color-field coordinates, or scene is inferred. Palette choice varies substantially (pink/cyan/yellow, orange/green/navy, and coral/teal systems), as do the type amount and concrete composition. The prompt therefore uses source-relative skin/hair/clothing treatment and conditional caller-authorized typography rather than literal teacher colors, clothes, words, or layout.

## Inference confidence

Recurrence across five notably different subjects and scenes is strong evidence for the editorial-anime print medium, navy contour system, warm-paper/limited-accent relationship, tactile print marks, and asymmetric abstract layering. Individual ornamental objects and text arrangements are lower-confidence examples only and are represented as an optional vocabulary, never as a layout prescription.

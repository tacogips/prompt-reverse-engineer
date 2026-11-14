# Source analysis — train-0012

## Purpose and boundary

`input/source-child.jpeg` is the sole training content reference and the only permissible image input for candidate generation. It is a photographic source with a human subject and incidental printed/interface material. Its identity, age, anatomy, facial features, hair, apparel, marks, pose, crop, setting, and any visible words are source-controlled facts, not prompt content.

## Preservation requirements

The transformation must preserve all depicted source identity and content by default, including anatomy, source garments, their construction and markings, source pose, crop, object count, scene relationships, and visible source details. The only permitted changes are the explicitly requested optional `pose`, `composition`, `text`, or narrowly scoped `additional` instructions. If text is absent, the output must add no readable or pseudo-readable lettering; source markings must not be invented, removed, or replaced.

## Non-leakage conclusion

No observed source-specific description is carried into the reusable style prompt. The style prompt refers only to a generic `source reference` as the exclusive authority for content and identity.

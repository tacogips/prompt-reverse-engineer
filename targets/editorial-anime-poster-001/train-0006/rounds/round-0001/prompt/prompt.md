# Positive Prompt

Use case: style-transfer.

Image 1 is the style reference. Transfer only its reusable visual language: infer and apply its illustration medium, framing language, palette relationships, contour and mark-making quality, abstract graphic vocabulary, print/brush texture, and graphic treatment. Do not copy Image 1's depicted subject, identity, age, body, wardrobe, accessories, objects, scene, symbols, or writing.

Image 2 is the arbitrary source reference and is the exclusive authority for depicted content and identity. Render the source subject(s), count, geometry, identity, apparent age, anatomy, hairstyle, clothing, pose, viewpoint, placement, and source composition faithfully in Image 1's visual language. Preserve every unspecified source-controlled attribute. Style transfer must never replace or blend source content with content from Image 1.

Optional instructions are structured fields and are absent unless supplied:
- `pose`: when supplied, override only the requested pose or viewpoint; preserve all other source-controlled attributes.
- `composition`: when supplied, override only requested framing, crop, placement, or layout; it takes priority over inferred style framing.
- `text`: when supplied, render exactly and only the provided verbatim text, with no edits, substitutions, extra lettering, or pseudo-readable marks. When absent, render no text.
- `additional`: when supplied, apply only its explicit, narrowly scoped change; all unspecified attributes remain source-controlled.

Follow this precedence: safety and artifact integrity; explicit optional instructions; source content and identity preservation; then style defaults. Produce one original, polished style-transfer image with no logo, watermark, signature, or garbled typography.

# Negative Prompt

Do not import or imitate Image 1 content. Do not alter source identity, apparent age, anatomy, count, geometry, hairstyle, clothing, pose, or composition unless the relevant optional field explicitly requests it. No unrelated scene elements, duplicates, logos, watermarks, signatures, unreadable glyphs, pseudo-text, or unrequested text.

# Rationale

This revision retains the parent's successful separation of style and source authority while making source preservation and optional-instruction boundaries explicit. It focuses the transferable language on compact, source-following contour and detail treatment rather than allowing decorative marks to expand source silhouettes.

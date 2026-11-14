# Source-content analysis

The training source is a portrait-oriented real-world photograph containing a person, clothing, background surfaces, and incidental social-media interface marks. These are source-controlled content, not style-prompt evidence.

Candidate generation must preserve the depicted person's identity, age, anatomy, hair, facial features, pose, clothing identity and markings, visible objects, framing, and scene unless a supplied optional instruction explicitly and narrowly changes the named attribute. The reusable prompt must not name, describe, infer, or hard-code any of these source-specific attributes. Incidental source text or interface marks are not authorization to render text: absent an optional `text` instruction, output must contain no generated text.

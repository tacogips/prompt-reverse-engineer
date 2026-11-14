# Independent Review: Train 0002

## Outcome

The iteration is recorded as **failed verification**. Its selected result was not promoted to `best.json` because its first-round image provenance cannot be verified.

## Verified observations

- Eight generated PNG files are present under this iteration, rather than only in an image-generation cache. Each decodes as a 1023x1537 RGB PNG.
- The round-0002 candidate-001 record is the deterministic global minimum: total loss 0.073 and reward 0.927. Round-0001's best was 0.08275, so the second round did not replace a better global candidate with a worse round winner.
- The six judge component losses are all normalized to `[0, 1]`. Applying the recorded v2 judge weights reproduces every persisted total and `1 - total` reward within `1e-9`.
- The calibration manifest is present and records all required directional relations as passed. The recorded workflow exit reason is consistent with the configured target loss of 0.08 and two executed rounds out of a maximum of three.

## Verification failure

All four `rounds/round-0001/candidates/candidate-00N/image.png` files exist and decode, but their SHA-256 digests do not equal the `image_sha256` declared by their corresponding `generation.json` records. This prevents an auditor from establishing that the preserved round-0001 images are exactly the generated outputs described by their provenance records.

This is an integrity failure, not a score or candidate-selection failure. The record was left intact: the hashes were not rewritten from the current files, because that would erase evidence of the mismatch.

## Actionable remediation

Recover the original round-0001 generated image outputs and raw provider response, then verify their SHA-256 values against the existing generation records. If the repository files are confirmed to be legitimate replacements, create a new training iteration with explicit replacement provenance; do not rewrite the immutable experiment record. Re-run this independent review after that provenance is available.

## Next hypothesis

Once provenance is repaired, validate the current winning prompt with fresh provider attempts, because the configured stopping criteria require fresh-seed validation and the provider did not expose reproducible seeds.

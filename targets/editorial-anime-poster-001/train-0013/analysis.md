# Independent review — failed

## Outcome

The iteration is failed and non-promotable. `best.json` was preserved. The selected training-only candidate is `rounds/round-0001/candidates/candidate-001` with recorded total loss `0.117`, but that training result cannot override the blocked transferability gate or the truth-set provenance mismatch.

## Verified evidence

- The two candidate images are present in this project at their recorded `generation.output.path` values. Fresh SHA-256 values equal their recorded output hashes.
- Every realized training `generation.json` contains exactly one `source_reference` input. Its path and hash match the explicit `referenced_image_paths` source binding, the binding declares `recent_image_context_used: false`, and the records declare omission of `num_last_images_to_include`.
- Base-prompt, effective-prompt, optional-instruction, source, and output hashes recompute. Training optional instructions are canonical `{}`; base and effective prompt paths/hashes are identical, which is valid under `generation-provenance-v2`.
- The visual source-binding records are consistent with direct inspection: both outputs retain the source subject, profile, garment/logo, and setting as a stylized transformation rather than an unrelated image.
- Both judges contain five ordered per-reference style assessments, and all five style-component medians reproduce the recorded metrics. Candidate 001 recomputes to `0.1165`, rounded to recorded `0.117`; reward `1 - total` is `0.8835`, rounded to recorded `0.883`. Candidate 002 recomputes exactly to `0.134` and reward `0.866`.
- Candidate 001 is the correct round selection (`0.117 < 0.134`); there is no current-regime prior best to overwrite. The existing root `best.json` uses a different legacy judge regime and was not modified.
- The template validation passed with zero forbidden subject-specific clauses. Required literal clauses occur verbatim in the executable prompt. The complete style model covers all five required dimensions and its prompt clauses are traceable at the dimension level to the executable prompt/template-validation inventory. All eight authorized feedback items have an `implemented` disposition and a traceable affected model/workflow path.

## Blocking findings

1. `state.styleReferenceSetSha256` and the same field in `isolation-audit/round-0001.json` record `179c6ac99cf6cc0dc80b69c2d422c0d8252eb1f228c78c6494f83cc938bbac99`. Applying the audit's declared algorithm, `sha256(UTF-8 jq -cS ordered array of {path,sha256} plus final newline)`, freshly produces `805f0db0aec28aa2f7a74819d572c501a8a2406106de0f159b82ba929cabfc39`. The recorded value is the hash of the compact serialization *without* the declared final newline. This is a required truth-set provenance mismatch.
2. `transferability/evaluation.json` correctly records failure because required per-case generation, five-reference judge, and recomputed metrics records are incomplete. It therefore has no aggregate validation loss, worst-case loss, exact-text/no-text results, or train/validation gap.
3. `test-audit/evaluation.json` correctly skipped the one-shot audit after the failed validation prerequisite and did not open the sealed manifest. It has no disjoint-test proof, coverage, thresholds, or validation/test gap.
4. The isolation audit reports no persisted step-scoped session log or runtime snapshot for at least `analyze-images`. Its positive assertions are internally consistent, but an independent reviewer cannot prove the required absence of premature manifest access from this incomplete execution evidence.

## Next action

Create a new iteration rather than editing this experiment record. Fix the truth-set canonical serialization before generation, persist step-scoped access evidence, then complete frozen validation before opening a fresh sealed test manifest.

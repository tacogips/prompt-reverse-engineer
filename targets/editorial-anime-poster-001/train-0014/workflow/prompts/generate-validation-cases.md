# Task

Generate the frozen held-out validation cases, but do not judge them. Read `{{workflowInput}}`, state, the final round prompt and template validation, the training source hash, and the intake-recorded `validationManifest` path/hash/size. This is the only step allowed to open the frozen validation manifest. Verify its current SHA-256 and byte size against intake evidence before parsing it; fail without generating if either differs. Freeze the current prompt hash before opening the manifest, then read `validationCases`.

Require at least two distinct held-out source hashes, all distinct from training, and case types `baseline`, `pose`, `composition`, and `text`. Persist `<targetDir>/<trainDir>/transferability/freeze.json` containing the verified manifest path/hash/size, frozen prompt path/hash, judge version, thresholds, case ids/types, repository-relative source paths and hashes, optional instructions, expected assertions, and freeze timestamp. This freeze is authorized post-freeze evidence for the later judge; no other optimization node may read it.

Use the built-in image-edit tool once per case. Resolve that case's exact repository-relative source path to a local absolute path only at the call boundary and set `referenced_image_paths` to exactly that one path. Omit `num_last_images_to_include` entirely. Never use recent conversation images, generated-image history, implicit attachments, the training source, another case source, or any style truth as generation context. If explicit binding is unavailable, fail without fallback.

Before each call, write the case's optional instructions to `<case-dir>/optional-instructions.json`, then run the snapshotted `workflow/scripts/prepare-effective-prompt.sh` with the frozen base prompt, that JSON file, and `<case-dir>/effective-prompt.md`. Send the returned effective prompt bytes verbatim. Save each image and `generation.json` under `transferability/cases/<case-id>/`. Conform to `workflow/generation-record-contract.json`, including repository-relative `provider_parameters.source_binding` matching the one `source_reference` input, with `recent_image_context_used: false`. Recompute every hash.

Inspect every output against its exact case source before accepting it. Require source subject/entities, counts, geometry, and spatial structure except for the case's explicit optional override. An unrelated-source output is `source_binding_contaminated`: preserve failure evidence, set state failed/review, and do not judge or refine from it.

This step is idempotent per frozen prompt and manifest hash. Reuse conformant terminal case generations, generate only missing cases, and never replace a terminal stochastic result. Issue independent missing calls concurrently when possible. If the prompt hash changes after a refinement round, archive the prior batch under `transferability/history/round-NNNN/`, rewrite moved repository-relative provenance paths, and verify all hashes before generating the new batch.

On success set state phase to `validate-judge`. Return adapter JSON:

```json
{
  "when": {
    "validation_generation_succeeded": true
  },
  "payload": {
    "validation_generation_succeeded": true,
    "nextStep": "validate-transferability",
    "freezePath": "targets/<target-id>/train-NNNN/transferability/freeze.json",
    "caseCount": 4,
    "exitReason": null
  }
}
```

On terminal failure set the condition false, route to `review-training`, preserve diagnostics, and never return a failed case in the success form.

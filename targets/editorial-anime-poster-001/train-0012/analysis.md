# Failed iteration analysis: train-0012

## Result

This iteration failed before judging. The five-image ensemble analysis, prompt-template validation, judge calibration, and input-isolation audit passed, but candidate generation did not preserve the declared training source.

## Direct evidence

- `candidate-001/generation.json` records `input/source-child.jpeg` as the sole `source_reference`, but its saved output hash `1af81b2fe6d5b81105591cf33a71c595728d43eaa3a2556b1423f2f20d3d6c78` is the unrelated garden-workbench image that had most recently appeared in conversation context.
- Post-generation source inspection rejected that image before judging. Candidate-002 and candidate-003 produced no terminal artifacts after an extended provider wait.
- No training loss, reward, selection, validation result, or test result exists. The validation and sealed-test manifests remained unopened.
- The graph then exposed a second defect: a failed generation payload could still take the unconditional generation-to-judge edge, and the judge's failure payload could still take the false branch to refinement. The operator stopped the session; its failed state and runtime evidence are preserved.

## Diagnosis

The generation prompt required one source image semantically but did not require the built-in edit tool's explicit local-file binding. Implicit recent-image context could therefore disagree with persisted `input_images`. The workflow also lacked a graph-level generation-failure branch.

## Required next change

Require `referenced_image_paths` with exactly the resolved source file for candidate, validation, and test calls; prohibit `num_last_images_to_include` and all recent-image fallback; persist `provider_parameters.source_binding`; inspect output-to-source correspondence before judging; and route source-binding failure directly to review. Use a fresh sealed test source because the train-0012 test source appeared prematurely as a candidate output.

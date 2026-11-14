# AGENTS.md

## Project Purpose

This repository researches prompt inversion from generated target images. Given one or more immutable target/style truth images, the system must infer the self-contained text prompt that plausibly produced their visual language. The learned prompt must apply that language to an arbitrary source image without receiving the target/style truth as a generation input.

The work is iterative and reinforcement-learning-inspired: generate candidates, measure their reusable style-language differences from the target, analyze the errors, update the workflow and prompt strategy, and repeat. The objective is not to reproduce the teacher image. It is to infer a transferable text model of the hidden style prompt and reduce its style loss across arbitrary input images without overfitting to one subject, composition, scene, or accidental generation seed.

Training accepts target/style truth, an arbitrary source image, and optional pose, composition, exact-text, or additional instructions. Target truth is available only to analysis, judging, refinement, and review. Candidate, validation, test, and deployed inference generation receive the source image plus the reconstructed text prompt only. The deliverable includes that prompt, relevant parameters, validation evidence, and explicit generalization status.

## Reusable Prompt Contract

The primary learned artifact is a subject-agnostic, self-contained textual style prompt. Generation has exactly one required image role: `source_reference`, which exclusively controls depicted content and identity. `style_reference`, `style_truth`, and target images are forbidden generation roles. The prompt text itself must encode the reconstructed medium, palette, contrast, lighting, line quality, texture, mark making, abstract graphic vocabulary, and overrideable composition defaults.

The teacher image is evidence for a hidden style prompt, not an image-reconstruction target. Its subject, identity, objects, readable text, pose, camera crop, exact geometry, concrete layout, and scene are content leakage and must not be rewarded, copied, or required. Only transferable visual factors—medium/rendering, palette/tone, line/shape, texture/material, and abstract graphic language—belong in the learned style model.

The template accepts optional structured instructions:

- `pose`: override only pose or viewpoint details named by the caller;
- `composition`: override only framing, placement, crop, or layout details named by the caller;
- `text`: exact verbatim text to render; absent means no generated text;
- `additional`: other explicit changes, scoped as narrowly as possible.

Instruction precedence is: safety and artifact integrity, explicit optional instructions, preservation of all unspecified source attributes, then style defaults. A pose instruction must not silently change identity, age, clothing, object count, or text. A composition instruction must not silently change the subject. A text instruction must not license extra or pseudo-readable text.

Never hard-code observations from the current source into the reusable prompt. Forbidden source-specific prompt content includes observed age, gender, ethnicity, skin tone, facial features, hair, gaze, expression, pose direction, clothing, accessories, logos, text, objects, scene contents, or a target-specific subject description. These observations belong in source analysis and judge evidence only. Generic instructions to preserve source-controlled attributes are allowed.

Every round must write `prompt/template-validation.json` and `isolation-audit/round-NNNN.json`. Candidate generation is forbidden until the template record passes with zero subject-specific clauses and the isolation audit proves that validation/test inputs were not accessed by prohibited nodes. A contamination failure must be written to `state.json` by the workflow and routed to normal review/output without requiring an operator to patch state manually.

Target/style truth must never be attached to a generation call. Every candidate, validation, and test `generation.json` must contain exactly one `input_images` entry with role `source_reference`. If the truth hash or a truth/style role appears in generation provenance, the candidate and run are invalid regardless of visual score.

## Generalization and Overfitting Control

Training loss and validation loss are separate. Training loss measures a candidate made from the training source. Validation loss measures the frozen prompt on held-out source images and optional-instruction cases. Never combine them into a single number that hides a regression. Ordinary runtime input must carry only a repository-relative frozen validation-manifest path, never inline validation cases, source descriptions, instructions, or expected assertions. Intake records that file's hash and size without opening it; only `validate-transferability` may open it after the prompt hash is frozen.

Training optimization uses loss-function version `style-inversion-v3`. Seventy percent of its weight belongs to five explicit teacher-derived style dimensions: `medium_rendering`, `palette_tone`, `line_shape`, `texture_material`, and `graphic_language`. `palette_tone` includes source-relative skin, hair, and clothing treatment; `graphic_language` includes conditional typography/dialogue treatment without teacher wording. `source_fidelity` and `technical` guard against destroying the new input; they do not define the desired style. Every style dimension and authorized human-feedback check has its own gate, so high source fidelity cannot hide a weak style transfer. Pixel similarity and teacher-content similarity are forbidden metrics.

A workflow may claim arbitrary-input behavior only after a held-out gate that:

- uses at least two distinct source-image hashes not used for training;
- covers baseline transfer, pose override, composition override, and exact text;
- checks source/identity preservation and style fidelity;
- checks instruction adherence only where applicable;
- checks exact spelling and absence of unrequested text;
- records aggregate loss, worst-case loss, and the train/validation gap;
- rejects a prompt whose validation gap exceeds the configured limit;
- preserves all generated validation images and raw judge evidence.

Because repeated refinement can overfit the validation suite, promotion also requires a one-shot test audit on at least one additional source hash that overlaps neither training nor validation. Ordinary workflow input carries only a repository-relative sealed-manifest path; intake records its hash and size without opening it. Prompt-synthesis and refinement nodes must not read test images, descriptions, instructions, or expected assertions. The test audit verifies the manifest hash, runs only after optimization stops, and never routes back to refinement. Review must inspect execution evidence for premature manifest access. If the audit fails, preserve the failure and start a later outer iteration with a newly sealed test set after using the old audit evidence for research.

When `parentTrainDir` is set, the later iteration may read only the parent's exact state, analysis, evaluation, judge, feedback-resolution, and final-prompt files. Historical held-out findings written in those files are legitimate outer-loop feedback when the current sealed test set is fresh. Do not follow their paths to old fixture images or manifests, and do not inventory target, validation, test, or prior-train directories to discover evidence.

Use `allowUnvalidatedPrototype: true` only for explicitly exploratory runs. Such a run is non-promotable: it cannot update `best.json`, cannot satisfy the definition of done, and cannot be described as reusable or generalized.

Additional anti-overfitting controls are mandatory:

- freeze validation inputs, instructions, thresholds, and expected assertions before prompt optimization;
- do not reveal held-out source descriptions to prompt-synthesis nodes, including through runtime variables, run configuration, intake evidence, or runtime snapshots;
- normalize every revised prompt through the reusable-template contract;
- prefer short transferable style clauses over growing lists of source-specific exceptions;
- reject validation improvements caused by changing the judge or validation set;
- periodically rotate an untouched test set after policy selection, without tuning on it;
- preserve regressions and failed validation runs as research evidence.

## Repository Layout

Each independent reverse-engineering target lives under `targets/<target-id>/`.

```text
targets/
  <target-id>/
    target.json
    truth/
      <reference-image>.<ext>
      manifest.json
    validation/
      manifest.json
      <held-out-source>.<ext>
    train-0001/
      iteration.json
      workflow/
        workflow.json
        ...
      judge/
        prompt.md
        config.json
      transferability/
        evaluation.json
        cases/
          <case-id>/
            image.png
            generation.json
            judge.json
            metrics.json
      test-audit/
        evaluation.json
        cases/
          <case-id>/
            image.png
            generation.json
            judge.json
            metrics.json
      rounds/
        round-0001/
          prompt/
            prompt.md
            generation.json
            template-validation.json
          candidates/
            candidate-001/
              image.png
              generation.json
              metrics.json
              judge.json
          selection.json
          refinement.md
        round-0002/
          ...
      evaluation.json
      analysis.md
    train-0002/
      ...
    best.json
```

Use zero-padded iteration numbers (`train-0001`, `train-0002`, and so on) so lexical and chronological order agree. Use zero-padded candidate numbers for the same reason.

Do not modify `truth/` while training. It is the immutable ground truth for the target. Treat a completed `train-NNNN/` directory as an immutable experiment record; create the next iteration instead of rewriting history.

## Target Metadata

`targets/<target-id>/target.json` defines the experiment:

```json
{
  "schema_version": 1,
  "target_id": "example-id",
  "objective": "Reverse-engineer a prompt and workflow for the supplied target image.",
  "created_at": "2026-08-14T00:00:00Z",
  "generator": {
    "provider": "provider-name",
    "model": "model-name",
    "model_version": "version-or-null"
  },
  "evaluation": {
    "metric_version": "style-inversion-v3",
    "judge_model": "multimodal-judge-model",
    "weights": {
      "medium_rendering": 0.20,
      "palette_tone": 0.15,
      "line_shape": 0.15,
      "texture_material": 0.10,
      "graphic_language": 0.10,
      "source_fidelity": 0.20,
      "technical": 0.10
    },
    "style_component_max_loss": 0.25,
    "candidates_per_round": 4,
    "max_refinement_rounds": 8,
    "target_loss": 0.15,
    "judge_repeats": 3,
    "validation_target_loss": 0.20,
    "validation_worst_case_loss": 0.30,
    "test_target_loss": 0.22,
    "test_worst_case_loss": 0.32,
    "max_generalization_gap": 0.10
  }
}
```

Weights must sum to `1.0`. If the generator or evaluator changes materially, record the change explicitly and do not compare the affected losses as if they came from the same measurement regime.

`truth/manifest.json` lists every reference image and its role:

```json
{
  "schema_version": 1,
  "images": [
    {
      "file": "target.png",
      "sha256": "<hex-digest>",
      "role": "primary",
      "notes": "Optional factual notes only; do not encode a hidden answer prompt."
    }
  ]
}
```

## Iteration Artifacts

### `iteration.json`

This is the provenance record for an iteration:

```json
{
  "schema_version": 1,
  "iteration": 2,
  "parent_iteration": 1,
  "status": "complete",
  "started_at": "2026-08-14T01:00:00Z",
  "completed_at": "2026-08-14T01:20:00Z",
  "hypothesis": "Increasing subject scale and lowering background detail will improve composition loss.",
  "workflow_family": "analyze-generate-select-refine-loop",
  "workflow_revision": "local-content-sha256-or-git-commit",
  "judge_revision": "judge-prompt-sha256",
  "selected_candidate": "rounds/round-0002/candidates/candidate-003"
}
```

Allowed statuses are `planned`, `running`, `complete`, and `failed`. A complete iteration must have all required artifacts and a selected candidate. A failed iteration must preserve diagnostics and explain the failure in `analysis.md`.

### `workflow/`

Store the exact Riela workflow used for the iteration. It must be self-contained or explicitly reference versioned, repository-local dependencies. Its inputs should include target image paths and experiment configuration. Its outputs should include the inferred prompt, generator parameters, candidate images, evaluation results, and improvement proposal.

The workflow is the primary learned artifact. Changes to prompts, node instructions, routing, evaluators, candidate selection, or refinement logic are policy updates and must be recorded from one iteration to the next.

### Round prompt files

Store the exact human-readable prompt sent to the image generator at `rounds/<round-id>/prompt/prompt.md`. Preserve whitespace and ordering. Use this structure when supported:

```markdown
# Positive Prompt

Exact positive prompt text.

# Negative Prompt

Exact negative prompt text, or `None`.

# Rationale

A short explanation of the visual attributes targeted by this revision.
```

Do not put secrets, credentials, or undocumented runtime substitutions in prompt files.

### Generation records

Each round's `prompt/generation.json` contains the intended shared settings. Each candidate's `generation.json` contains the exact realized settings and must override or expand the shared record when necessary.

The authoritative realized-record contract is `.riela/workflows/prompt-reverse-train/generation-record-contract.json`. Training, validation, and sealed-test generation records must use its exact required fields. In particular, use `output.path`, `output.sha256`, `input_images[]`, `base_prompt_file`, `base_prompt_sha256`, `prompt_file`, `prompt_sha256`, and the canonical optional-instruction hash; aliases do not satisfy the contract. `prompt_file` is the exact effective text sent to the tool. Optional instructions may only be appended using the contract's deterministic suffix and must never cause the frozen base prompt to be paraphrased. All persisted paths are repository-relative, and every recorded hash must be recomputed from saved bytes before the workflow advances.

```json
{
  "schema_version": 1,
  "provider": "provider-name",
  "model": "model-name",
  "model_version": "version-or-null",
  "seed": 123456,
  "width": 1024,
  "height": 1024,
  "steps": 30,
  "guidance": 7.0,
  "sampler": "sampler-name",
  "prompt_sha256": "<hex-digest>",
  "raw_response_file": null
}
```

Preserve provider-specific parameters under a `provider_parameters` object. Record seeds whenever the provider exposes them. Never claim reproducibility when a provider does not guarantee it.

Generation nodes are retry-idempotent. A retry must reuse an existing terminal artifact when its prompt, manifest, input, and output hashes verify. It may generate only missing cases or candidates and must never replace a recorded validation or one-shot test result with a fresh stochastic sample. Independent generation calls should run concurrently where supported so multimodal nodes remain within the configured workflow timeout.

Real image-generation runs should set a generous agent deadline, for example `--default-timeout-ms 3600000 --timeout-ms 7200000`, in addition to supervised execution flags.

### Prompt-as-a-judge loss function

The loss function is itself a learned and versioned part of the Riela workflow. Store the exact multimodal judge prompt at `judge/prompt.md` and its model, decoding parameters, repeat count, aggregation rule, schema version, and prompt hash at `judge/config.json`.

```json
{
  "schema_version": 1,
  "loss_function_version": "judge-v1",
  "provider": "provider-name",
  "model": "multimodal-judge-model",
  "temperature": 0,
  "repeats": 3,
  "aggregation": "component_wise_median",
  "prompt_sha256": "<hex-digest>",
  "calibration_suite": "calibration/v1/manifest.json"
}
```

The judge receives, at minimum:

- the immutable target image as style evidence only;
- the source image controlling candidate content;
- exactly one generated candidate image;
- stable labels identifying which image is the target and which is the candidate;
- the scoring rubric and required JSON output schema.

The generation prompt may be supplied only in a separate diagnosis phase. The primary similarity score must be based on the images, not on how plausible or well-written the generation prompt appears. Do not let the judge reward prompt wording, intent, or rationales that are not visible in the candidate.

The judge prompt must instruct the model to compare observable transferable-style differences systematically, score each loss component in `[0, 1]`, cite concise visual evidence for every component, calculate no weighted total itself unless necessary, and return valid JSON only. It must explicitly ignore target subject, objects, text, pose, crop, exact composition, concrete layout, and scene. The workflow must calculate the weighted total deterministically from the returned component values.

Reusable arbitrary-input evaluators use `source_fidelity` rather than a person-only `identity` key. For a person, it covers recognizable identity, age, anatomy, hair, clothing, and unspecified pose. For an object, it covers count, geometry, material, markings, and parts. For a scene, it covers entities, spatial relationships, and structure. A legacy `identity` evaluator is a different loss-function version and its totals must not be compared directly.

Use a schema equivalent to:

```json
{
  "schema_version": 1,
  "target_candidate_order": "target_then_candidate",
  "loss": {
    "medium_rendering": 0.190,
    "palette_tone": 0.240,
    "line_shape": 0.310,
    "texture_material": 0.220,
    "graphic_language": 0.260,
    "source_fidelity": 0.190,
    "technical": 0.410
  },
  "evidence": {
    "medium_rendering": ["The candidate uses flatter cel shading than the teacher style."],
    "palette_tone": ["The candidate background is warmer than the teacher style's palette system."],
    "line_shape": ["The candidate contours are softer and less graphic."],
    "texture_material": ["The candidate lacks the teacher style's paper and overprint behavior."],
    "graphic_language": ["The abstract shape layering is less editorial."],
    "source_fidelity": ["The candidate preserves the source subject and objects."],
    "technical": ["The candidate has softer edge detail."]
  },
  "dominant_differences": [
    "Increase subject scale.",
    "Reduce background warmth."
  ],
  "confidence": 0.82
}
```

Judge prompts must also be trained and tested. Calibrate them against deliberately identical images, obvious mismatches, controlled single-attribute changes, and a small human-ranked comparison set. Test for target/candidate order bias by swapping presentation order. When practical, repeat judging with deterministic settings or multiple calls, aggregate with the median, and record score variance. A judge revision is accepted only when it improves agreement with calibration cases; it must not be changed merely to make the current training loss look lower.

Changing the judge prompt, judge model, rubric, weights, aggregation, or image preprocessing creates a new loss-function version. Re-score prior best candidates under the new version before claiming improvement. Preserve individual judge responses in each candidate's `judge.json`; never keep only the aggregate.

The visual training judge must not reward prompt wording. Template generality is enforced by the separate prompt-contract gate, and behavioral generality is measured by held-out transferability cases. This separation prevents a well-written prompt from receiving image credit and prevents a visually lucky, source-specific prompt from being promoted as reusable.

### Candidate metrics

`rounds/<round-id>/candidates/<candidate-id>/metrics.json` stores normalized losses in the range `[0, 1]`, where lower is better:

```json
{
  "schema_version": 1,
  "candidate_id": "candidate-003",
  "target_files": ["truth/target.png"],
  "loss": {
    "total": 0.284,
    "medium_rendering": 0.190,
    "palette_tone": 0.240,
    "line_shape": 0.310,
    "texture_material": 0.220,
    "graphic_language": 0.260,
    "source_fidelity": 0.190,
    "technical": 0.410
  },
  "reward": 0.716,
  "evaluators": [
    {
      "name": "prompt-as-a-judge",
      "version": "judge-prompt-sha256",
      "raw_output_file": "judge.json"
    }
  ]
}
```

Define `total` as the weighted sum of component losses from `target.json`. Define `reward` as `1 - total` unless a later version explicitly documents another reward function. Keep raw evaluator outputs when available so scores can be audited.

### `evaluation.json`

This file summarizes the iteration rather than duplicating all candidate details:

```json
{
  "schema_version": 1,
  "iteration": 2,
  "selected_candidate": "rounds/round-0002/candidates/candidate-003",
  "rounds_executed": 2,
  "exit_reason": "target_validation_and_test_reached",
  "selection_rule": "lowest_total_loss",
  "total_loss": 0.284,
  "reward": 0.716,
  "previous_best_loss": 0.327,
  "absolute_improvement": 0.043,
  "relative_improvement": 0.1315,
  "is_new_best": true
}
```

`analysis.md` explains what improved, what regressed, evidence for the diagnosis, and the single most important hypothesis for the next iteration. Clearly separate observations from speculation.

`best.json` points to the best completed iteration and candidate. Update it only after evaluation succeeds:

```json
{
  "schema_version": 1,
  "iteration": 2,
  "candidate": "rounds/round-0002/candidates/candidate-003",
  "total_loss": 0.284,
  "updated_at": "2026-08-14T01:20:00Z"
}
```

## Training Procedure

For every iteration:

1. Read `target.json`, `truth/manifest.json`, the target images, `best.json`, and the previous iteration's analysis.
2. Inspect the current best candidate against the truth at full resolution for reusable style dimensions only, and against its source for content fidelity. Identify whether the dominant limitation is in style modeling, prompt synthesis, candidate generation, judging, selection, refinement, or loop control.
3. Form a testable hypothesis about either the workflow policy or the judge loss function.
4. Copy the previous best workflow and judge into the new iteration and make a focused update. Avoid changing many unrelated variables at once unless the iteration is explicitly marked as a new workflow family.
5. Execute the workflow's internal refinement rounds. Generate the configured number of candidates per round and prefer controlled seed variation so prompt quality is not confused with a lucky seed.
6. Evaluate every candidate with the same versioned judge. Select the round winner using the declared rule and per-style ceilings, then use the style model, target, winner, judge evidence, and current prompt to produce the next prompt when the workflow strategy requires it.
7. Stop the internal loop when `target_loss` is reached, `max_refinement_rounds` is exhausted, or another predeclared safety or budget condition fires. Always record the exact exit reason.
8. Before completion, freeze the best prompt and run the held-out transferability suite. If it fails and budget remains, refine from validation evidence without exposing held-out source descriptions; otherwise exit honestly.
9. Write all provenance, prompts, template validations, generation records, raw judge responses, metrics, selections, transferability cases, refinements, and analysis artifacts.
10. Compare the workflow run against the global best under the same loss-function and transferability versions, not only the immediately preceding iteration. Update `best.json` only on genuine training and validation improvement.
11. Periodically test a structurally different workflow family rather than endlessly tuning the baseline loop.

The default optimization target is monotonically improving best-so-far loss. Individual exploratory iterations may regress; never delete or falsify them. If an iteration regresses, retain the earlier best and use the regression as evidence for the next update.

## Stopping Criteria

Before training begins, document concrete stopping criteria in `target.json` or the first `analysis.md`. Prefer a combination of:

- a target total loss;
- a maximum iteration or compute budget;
- no meaningful best-loss improvement for a fixed number of iterations;
- successful validation on multiple seeds;
- human review confirming that remaining differences are insignificant for the target objective.

Do not declare success solely because one seed produced a close image. Validate the final workflow with fresh seeds and, when the research goal is generalization, with held-out target images.

## Riela Workflow Requirements

The Riela workflow shape is intentionally not fixed. Workflow topology, prompts, state representation, judge design, candidate selection, refinement method, branching, and termination logic are all research variables. Every workflow must nevertheless expose its inputs, persisted state, outputs, loss-function version, budgets, and exit conditions clearly enough to audit and replay the run.

### Baseline workflow family

Implement and measure the following as a useful baseline, not as the mandatory final architecture:

1. Ingest and validate the target image or images.
2. Separate teacher-image content from reusable style evidence. Model medium/rendering, palette/tone, line/shape, texture/material, and abstract graphic language; blacklist teacher subject, objects, text, pose, crop, concrete layout, and scene. Record uncertainty instead of inventing details.
3. Convert only the reusable style model into an initial structured image-generation prompt and parameters.
4. Generate `N = candidates_per_round` images in parallel.
5. Run the versioned prompt-as-a-judge loss independently on every style-truth/source/candidate triplet; never use pixel similarity or teacher-content matching.
6. Select the candidate with the lowest aggregate loss using a deterministic tie-break rule.
7. If its loss is at or below `target_loss`, return it and exit successfully.
8. Otherwise, provide the target image, selected candidate, current generation prompt, component losses, and evidence-backed differences to a refinement node. Produce a revised prompt that addresses the dominant differences while preserving already-correct features.
9. Generate another parallel batch of `N` candidates from the revised text prompt and source image only. The refinement node may inspect target truth and selected candidates, but it must convert its conclusions into text; neither target truth nor a previous candidate may be attached to the next generation call.
10. Exit when the target loss is reached or after `M = max_refinement_rounds`. On budget exhaustion, return the best-so-far result with a non-success exit reason rather than pretending convergence.

The loop must retain the global best candidate across all rounds. A later round must not replace it merely because it is the winner of that round. Generate candidates in parallel where Riela permits it, but make selection and state updates deterministic after all expected results arrive. Define how partial generation failures, invalid judge output, ties, timeouts, and provider rate limits affect the round.

### Alternative workflow families

Agents must explore approaches that are materially different from the baseline. Merely changing wording, `N`, or `M` does not create a new workflow family. Candidate alternatives include, but are not limited to:

- coarse-to-fine style optimization: solve medium and palette first, then line/shape, texture/material, and graphic language;
- hierarchical decomposition: infer scene graph, camera, lighting, materials, and style in separate branches before prompt synthesis;
- population or evolutionary search: maintain several parent prompts, mutate and recombine them, and preserve diversity rather than following one winner;
- pairwise tournament judging: rank candidates through comparisons before assigning calibrated absolute loss;
- multi-judge or debate evaluation: use independent critics for different loss components and an aggregator to resolve disagreement;
- region-aware refinement: crop or segment mismatching regions, diagnose them separately, then revise the global prompt;
- prompt ablation and attribution: add or remove controlled prompt clauses to measure which wording causes which visual change;
- surrogate or memory-guided search: learn from prior targets to propose promising prompt structures before generation;
- generator-specific textual prompt inversion and controlled prompt ablation, while keeping target/style truth strictly judge-only during generation;
- adaptive budgeting: change batch size, judge repeats, or exploration strength based on uncertainty and observed progress.

Each workflow family must declare its hypothesis, expected advantage, expected failure mode, compute budget, and comparison baseline. Compare families across multiple targets and seeds using a fixed judge version and equalized budget where possible. Preserve failed approaches: negative results are research evidence.

### Required conceptual capabilities

Regardless of topology, the eventual workflow must cover these capabilities somewhere:

1. target ingestion and validation;
2. visual analysis with uncertainty;
3. prompt and generation-parameter proposal;
4. candidate generation;
5. prompt-as-a-judge evaluation and loss calculation;
6. best-so-far tracking;
7. evidence-based diagnosis or search feedback;
8. a strategy for improving the next action;
9. bounded termination and explicit exit reasons;
10. complete artifact emission.

Keep generator-specific behavior behind explicit workflow nodes or adapters. The learned reverse-engineering logic must not depend on unrecorded conversation state. Every result must be reproducible or, for nondeterministic providers, traceable from persisted inputs and raw outputs.

Training improves the workflow and its judge, not merely one generation prompt. A prompt that performs well for one target but adds brittle, target-specific wording without improving the workflow's inference strategy should be treated as overfitting. A judge that assigns a lower number without becoming more faithful to human-observable similarity is reward hacking and must be rejected.

## Agent Rules

- Read this file and any more specific nested `AGENTS.md` before changing project files.
- Never overwrite or transform truth images in place.
- Never fabricate losses, seeds, evaluator output, or generation metadata.
- Never optimize the judge against the current candidate without calibration evidence; this is loss manipulation, not image improvement.
- Use UTC ISO 8601 timestamps in machine-readable files.
- Use SHA-256 hashes for image, prompt, and workflow provenance where practical.
- Keep JSON deterministic and machine-readable: UTF-8, two-space indentation, newline at end of file, and no comments.
- Validate JSON and Riela workflow definitions before marking an iteration complete.
- Preserve raw generated images. Derived previews may be added separately but must not replace originals.
- Do not compare loss values across changed evaluators without an explicit recalibration note.
- Record `N`, `M`, target loss, actual round count, best-so-far path, and exit reason for every workflow run.
- Explore and benchmark genuinely different workflow families; do not assume the baseline loop is optimal.
- Prefer small, evidence-driven workflow changes and record their intended effect.
- Do not place API keys, tokens, private URLs, or local machine-specific absolute paths in committed artifacts.

## Definition of Done

A target is complete only when:

- the truth manifest is valid and its hashes match;
- every completed iteration contains its exact workflow, prompt, parameters, generated candidates, metrics, and analysis;
- every completed iteration contains the exact judge prompt, configuration, raw responses, and calibration version;
- `best.json` resolves to an existing completed candidate;
- the best loss can be recomputed from the recorded component losses and weights;
- all loops are bounded and their recorded exit reasons agree with their configured thresholds and budgets;
- the final workflow has been validated with fresh generation attempts;
- every final prompt passes the reusable-template contract with zero subject-specific clauses;
- the final style model explicitly separates transferable style factors from teacher-image content leakage and maps each factor to prompt clauses;
- every teacher-derived style dimension passes its frozen ceiling on training, validation, and one-shot test evidence;
- every generation record has exactly one source image input and no target/style truth path or hash;
- held-out validation covers at least two distinct non-training sources plus baseline, pose, composition, and exact-text cases;
- a one-shot untouched test audit covers baseline and combined optional instructions on a source disjoint from training and validation;
- aggregate validation loss, worst-case loss, and train/validation gap satisfy their frozen thresholds;
- the selected workflow family has been compared against at least one materially different approach, unless a documented resource limit prevents it;
- the training workflow can accept target images without hidden context, while its learned prompt can generate without those target images;
- limitations, evaluator changes, and nondeterminism are documented.

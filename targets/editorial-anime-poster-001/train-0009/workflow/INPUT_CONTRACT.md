# Workflow Input Contract

`prompt-reverse-train` reconstructs a reusable textual image-generation style prompt. It does not describe the training source and does not require the target/style truth at inference time.

## Required inputs

- `targetDir`: repository-relative target directory.
- `trainDir`: new immutable iteration directory name.
- `styleReference`: repository-relative target/style truth used only for analysis and loss evaluation; it is forbidden as a generation input.
- `sourceReference`: repository-relative training source. The legacy name `personReference` is accepted for old runs only.
- `candidatesPerRound`, `maxRefinementRounds`, and `targetLoss`.
- `validationTargetLoss`, `validationWorstCaseLoss`, `testTargetLoss`, `testWorstCaseLoss`, and `maxGeneralizationGap`.
- `validationManifest`: repository-relative path to the frozen optimization-validation manifest.
- `sealedTestManifest`: repository-relative path to the one-shot test manifest.

## Optional research feedback

`feedbackFiles` is an optional array of repository-relative JSON or Markdown files containing explicit human findings from earlier iterations. Intake verifies and hashes these files, analysis records how each finding changes the style model and prompt, and review requires every finding to be resolved, rejected with evidence, or deferred with a test requirement. Feedback is ordinary training evidence, not a sealed fixture.

```json
{
  "feedbackFiles": [
    "targets/example/feedback/feedback-0001.json"
  ]
}
```

Feedback must describe transferable behavior. A request to copy a teacher subject's literal identity, skin tone, hair color, garment, wording, or exact layout must be converted into a relative style rule or rejected as content leakage.

## Optional generation instructions

```json
{
  "optionalInstructions": {
    "pose": null,
    "composition": null,
    "text": null,
    "additional": null
  }
}
```

Every field is independently optional. `null` or absence means no override. `text` is verbatim: the output must contain exactly the supplied string and no additional text. Explicit instructions override only the named attribute; all unspecified source content remains invariant.

Every candidate, validation, test, and final inference generation receives exactly one image: the corresponding `sourceReference`. The learned prompt text must carry the reconstructed style. Passing `styleReference` or its hash to the generator invalidates the run.

## Frozen optimization validation cases

These cases may provide refinement feedback, but must not be embedded in ordinary workflow variables. The runtime input contains only `validationManifest`. Intake records its path, SHA-256, and size without opening it. Only `validate-transferability` may verify the hash and open it after the current prompt hash is frozen. Prompt-synthesis, analysis, generation, and training-judge nodes must not inspect its contents through the manifest, run configuration, intake evidence, runtime snapshots, or logs.

```json
{
  "validationManifest": "targets/example/validation/sealed-validation-manifest.json"
}
```

The frozen file uses at least two source hashes distinct from the training source and covers all four case types:

```json
{
  "validationCases": [
    {
      "id": "heldout-a-baseline",
      "type": "baseline",
      "sourceReference": "targets/example/validation/source-a.png",
      "optionalInstructions": {}
    },
    {
      "id": "heldout-a-pose",
      "type": "pose",
      "sourceReference": "targets/example/validation/source-a.png",
      "optionalInstructions": {
        "pose": "repository fixture's predeclared pose instruction"
      }
    },
    {
      "id": "heldout-b-composition",
      "type": "composition",
      "sourceReference": "targets/example/validation/source-b.png",
      "optionalInstructions": {
        "composition": "repository fixture's predeclared composition instruction"
      }
    },
    {
      "id": "heldout-b-text",
      "type": "text",
      "sourceReference": "targets/example/validation/source-b.png",
      "optionalInstructions": {
        "text": "EXACT FIXTURE TEXT"
      },
      "expectedText": "EXACT FIXTURE TEXT"
    }
  ]
}
```

Expected pose and composition assertions must be frozen in the case record before execution. Do not derive them from generated output.

## Sealed one-shot test cases

The normal workflow input contains only `sealedTestManifest`, a repository-relative path to a JSON file. Intake records its path, SHA-256, and size without opening it. The manifest must use at least one additional source hash that appears in neither training nor validation. Prompt synthesis, refinement, training judge, and validation nodes must not inspect it. Only `audit-generalization` may open and consume it, once, after optimization stops.

```json
{
  "sealedTestManifest": "targets/example/test/sealed-test-manifest.json"
}
```

The sealed file has this structure:

```json
{
  "testCases": [
    {
      "id": "test-c-baseline",
      "type": "baseline",
      "sourceReference": "targets/example/test/source-c.png",
      "optionalInstructions": {}
    },
    {
      "id": "test-c-combined",
      "type": "combined_optional",
      "sourceReference": "targets/example/test/source-c.png",
      "optionalInstructions": {
        "pose": "sealed pose instruction",
        "composition": "sealed composition instruction",
        "text": "SEALED EXACT TEXT"
      },
      "expectedText": "SEALED EXACT TEXT"
    }
  ]
}
```

An audit failure cannot route back to refinement. A later outer iteration may learn from it only after replacing the now-consumed test set with a newly sealed one.

## Prototype escape hatch

`allowUnvalidatedPrototype: true` permits workflow research without complete validation/test fixtures. Such a run is always non-promotable, cannot update `best.json`, and cannot report reusable or arbitrary-input success.

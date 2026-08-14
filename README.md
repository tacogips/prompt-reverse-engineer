# Prompt Reverse Engineer

Prompt Reverse Engineer is a research project for recovering a reusable image-generation style prompt from one or more generated reference images.

The goal is **not** to reproduce a teacher image pixel for pixel. The teacher image is evidence of an unknown prompt. The workflow extracts the transferable visual factors that plausibly came from that prompt, models them explicitly, and learns a self-contained text prompt that can apply the same visual language to unrelated source images.

## Core contract

- The teacher/style image is available only to analysis, judging, refinement, and review.
- Candidate, validation, test, and inference generation receive exactly one image: the current `source_reference`.
- The reconstructed text prompt is the only carrier of the learned style.
- Teacher-image subject, identity, objects, text, pose, crop, concrete layout, and scene are content leakage, not desired reconstruction targets.
- The reusable style model covers:
  - `medium_rendering`
  - `palette_tone`
  - `line_shape`
  - `texture_material`
  - `graphic_language`
- Optional pose, composition, exact-text, and additional instructions must work without weakening source preservation or introducing teacher-image content.

The current `style-inversion-v3` training loss assigns 70% of its weight to the five style dimensions. `palette_tone` includes source-relative skin, hair, and clothing treatment. `graphic_language` includes conditional typography or dialogue treatment while excluding teacher wording. Source fidelity and technical quality are guardrails. Each style dimension and authorized feedback item also has an independent gate, so a candidate cannot pass merely by preserving the source well.

## How training works

The Riela workflow is stored at [`.riela/workflows/prompt-reverse-train`](.riela/workflows/prompt-reverse-train).

At a high level it:

1. validates the target, source, budgets, and sealed-manifest metadata;
2. analyzes the teacher image and writes a machine-readable `style-model.json`;
3. synthesizes and contract-checks a source-agnostic text prompt;
4. audits that no teacher, validation, or test image can enter candidate generation;
5. generates multiple candidates from the training source plus text prompt only;
6. evaluates candidates with a versioned multimodal prompt-as-a-judge loss;
7. refines the dominant failed style dimension and repeats within a bounded budget;
8. freezes the prompt and evaluates it on held-out sources and optional instructions;
9. runs a one-shot audit on an additional sealed source that cannot feed back into the same training run;
10. independently reviews provenance, hashes, loss arithmetic, leakage, and promotion eligibility.

The workflow preserves every prompt, generated-image record, model identifier, hash, component loss, judge response, selection, refinement, and exit reason. Failed validation and test runs are retained as research evidence.

## Requirements

- macOS or Linux
- [Riela](https://github.com/tacogips/riela)
- an installed and authenticated [OpenAI Codex CLI](https://developers.openai.com/codex/)
- a Codex environment with the built-in image-generation tool available
- Git, for versioning experiment definitions and textual evidence

The checked-in workflow nodes currently use the `codex-agent` backend with `gpt-5.6-terra`. Model and evaluator changes create a new loss-function version; do not compare their loss values directly with older versions.

## Install Riela

### macOS CLI only

```bash
brew tap tacogips/tap
brew install riela
riela --version
```

### macOS app and CLI

```bash
brew tap tacogips/tap
brew install --cask riela
riela --version
```

### Ubuntu x64 CLI

```bash
sudo apt-get update
sudo apt-get install -y ca-certificates curl libcurl4 libsqlite3-0

version="$(curl -fsSLI -o /dev/null -w '%{url_effective}' \
  https://github.com/tacogips/riela/releases/latest | sed 's#.*/v##')"

curl -LO "https://github.com/tacogips/riela/releases/download/v${version}/riela-${version}-linux-x64.tar.gz"
curl -LO "https://github.com/tacogips/riela/releases/download/v${version}/riela-${version}-linux-x64.tar.gz.sha256"
sha256sum -c "riela-${version}-linux-x64.tar.gz.sha256"
tar -xzf "riela-${version}-linux-x64.tar.gz"
sudo install -m 0755 bin/riela /usr/local/bin/riela
riela --version
```

Linux releases are CLI-only. See the [Riela releases](https://github.com/tacogips/riela/releases) for other published artifacts.

## Configure Codex

Install Codex CLI using the [official OpenAI Codex documentation](https://developers.openai.com/codex/), then authenticate and verify it:

```bash
codex login
codex login status
```

Do not store API keys or access tokens in this repository. If your Codex installation uses an environment-based credential, configure it outside the project according to the official documentation.

## Repository layout

```text
.riela/workflows/prompt-reverse-train/   Canonical Riela workflow
targets/<target-id>/
  target.json                            Experiment and loss definition
  truth/                                 Teacher/style truth and manifest
  input/                                 Training source and manifest
  validation/                            Frozen held-out sources and manifest
  test/                                  One-shot sealed test source and manifest
  run-input-train-NNNN.json              Riela runtime variables
  train-NNNN/                            Immutable iteration evidence
```

Raster images and local Riela runtime databases are ignored by Git. A clone therefore contains workflow definitions and textual experiment evidence but not private or licensed image fixtures. Add your own images locally and keep their manifest hashes synchronized.

## Prepare an experiment

Create a new target directory and place local images under these roles:

- `truth/`: one or more teacher images whose hidden style prompt should be inverted;
- `input/`: a training source with content unrelated to the teacher;
- `validation/`: at least two held-out source hashes covering baseline, pose, composition, and exact-text cases;
- `test/`: at least one additional source, disjoint from training and validation, covering baseline and combined optional behavior.

Create `targets/<target-id>/target.json` and a new `run-input-train-NNNN.json`. The input contract and manifest examples are documented in [INPUT_CONTRACT.md](.riela/workflows/prompt-reverse-train/INPUT_CONTRACT.md).

Important runtime fields include:

```json
{
  "workflowInput": {
    "targetDir": "targets/example-target",
    "trainDir": "train-0001",
    "styleReference": "targets/example-target/truth/style.png",
    "sourceReference": "targets/example-target/input/source.png",
    "lossFunctionVersion": "style-inversion-v3",
    "styleComponentMaxLoss": 0.25,
    "candidatesPerRound": 3,
    "maxRefinementRounds": 3,
    "targetLoss": 0.18,
    "validationManifest": "targets/example-target/validation/sealed-validation.json",
    "sealedTestManifest": "targets/example-target/test/sealed-test.json"
  }
}
```

To carry explicit human findings into the next outer iteration, add repository-relative feedback files:

```json
{
  "workflowInput": {
    "feedbackFiles": [
      "targets/example-target/feedback/feedback-0001.json"
    ]
  }
}
```

The run writes `feedback-resolution.json` so each finding remains traceable to teacher evidence, a source-preserving style rule, exact prompt clauses, and a validation probe.

Use a new zero-padded `train-NNNN` directory for every run. Do not overwrite prior evidence or reuse a consumed one-shot test set for tuning.

## Validate the workflow

```bash
riela workflow validate prompt-reverse-train \
  --workflow-definition-dir .riela/workflows
```

Inspect the materialized definition:

```bash
riela workflow inspect prompt-reverse-train \
  --workflow-definition-dir .riela/workflows \
  --output json
```

Run the deterministic mock scenario without generating images:

```bash
riela workflow run prompt-reverse-train \
  --workflow-definition-dir .riela/workflows \
  --variables-file targets/<target-id>/run-input-train-NNNN.json \
  --mock-scenario .riela/workflows/prompt-reverse-train/mock-scenario.json \
  --output jsonl
```

## Run training

From the repository root:

```bash
riela workflow run prompt-reverse-train \
  --workflow-definition-dir .riela/workflows \
  --variables-file targets/<target-id>/run-input-train-NNNN.json \
  --working-dir "$PWD" \
  --artifact-root targets/<target-id>/train-NNNN/runtime-artifacts \
  --default-timeout-ms 3600000 \
  --timeout-ms 7200000 \
  --auto-improve \
  --max-supervised-attempts 3 \
  --workflow-mutation-mode execution-copy \
  --output jsonl
```

The command owns `state.json` and the iteration artifacts. Do not manually patch state to simulate progress or success.

Monitor a run from another terminal:

```bash
riela session latest --workflow prompt-reverse-train --output table
riela session progress <session-id> --follow --output text
riela session health <session-id> --output json
```

## Important outputs

Each `train-NNNN/` may contain:

- `style-analysis.md` and `style-model.json`;
- the exact generation prompt for every round;
- `generation.json` provenance with one `source_reference` input;
- candidate images locally, ignored by Git;
- per-candidate `judge.json` and `metrics.json`;
- `selection.json` and `refinement.md`;
- input-isolation audits;
- transferability and one-shot test evaluations;
- final `evaluation.json`, `analysis.md`, `iteration.json`, and `state.json` when review completes.

A low training loss is not sufficient for success. Promotion requires prompt-contract compliance, input isolation, per-style ceilings, held-out transferability, sealed one-shot testing, and final provenance review.

## Inference

Use the promoted prompt with an arbitrary source as the **only** image input. Do not attach the teacher image. Optional instructions may override pose, composition, exact text, or another narrowly scoped attribute; unspecified source content remains invariant.

## Research notes

- Loss values are comparable only within the same generator, model, judge prompt, rubric, weights, preprocessing, and metric version.
- Prompt-as-a-judge scores are stochastic measurements. Preserve model identifiers, hashes, repeat counts, aggregation rules, and raw responses.
- Validation data may guide refinement only after the prompt is frozen for that round.
- The sealed one-shot audit never routes back into the same optimization loop.
- Failed runs are first-class evidence and should not be deleted or rewritten.

See [AGENTS.md](AGENTS.md) for the complete repository and workflow contract.

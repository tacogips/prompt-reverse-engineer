# Review outcome

Status: failed and non-promotable. The selected current-contract candidate is `rounds/round-0002/candidates/candidate-002` with training loss `0.1025` and reward `0.8975` under `judge-v4-source-fidelity-style-transfer`.

## Verified observations

- Candidate and validation metric components are all in `[0, 1]`. Candidate weighted totals use the persisted v4 source-fidelity weights and validation totals use the persisted applicable-component mean; both recompute within `1e-9`. Candidate rewards equal `1 - total`.
- Round-0002 candidate-002 is the deterministic eligible winner. Round-0001 candidate-001 has a lower score (`0.0985`) but uses the superseded reusable-style-transfer-v1 contract and is explicitly ineligible under the final v2 contract. The legacy train-0003 identity-judge score was not compared numerically.
- Current training and final-validation generated PNGs are stored beneath `train-0006`, not solely in a tool cache. Their realized records conform to generation-provenance-v1 and all declared current output, prompt, and input hashes recompute from repository-root paths.
- Both round template validations pass with zero forbidden subject-specific clauses. The final executable prompt contains the v2 required literal safety clause verbatim.
- Both isolation audits pass. Their persisted execution evidence records only allowed pre-gate path/hash/byte-size handling and no prohibited manifest-content access. The validation and sealed-test hashes remain fixed.
- Final validation has the required four case types across two held-out source hashes disjoint from training. Its numeric aggregate (`0.0485`), worst case (`0.08`), and train/validation gap (`-0.054`) meet configured limits. The exact-text case passes, and baseline/composition no-text checks pass.

## Blocking findings

1. `heldout-a-pose` fails the required assertions `three_quarter_view` and `brown_shoes_preserved`. The validation gate is therefore failed despite passing numeric loss thresholds.
2. The one-shot sealed-test audit was correctly skipped without opening the manifest after validation failed. This leaves required test coverage, test thresholds, source-disjointness confirmation, and validation/test gap unavailable; the run cannot claim reusable or arbitrary-input success.
3. Four preserved history generation records are internally inconsistent. Each record's `output.path` names the final current validation image, while its recorded `output.sha256` matches the corresponding image under `transferability/history/round-0001`. Recomputing the hash at each declared path gives a different value. These are realized records and fail generation-provenance-v1 as persisted; they must be repaired only in a new iteration or by preserving correct immutable history and recording a new conformant run.

The workflow topology has no `audit-generalization` transition back to refinement, and the skipped audit did not route back. Existing `best.json` remains untouched because this iteration failed and uses a non-comparable judge regime.

## Next hypothesis

Start a new iteration with a newly frozen, template-validated prompt that gives pose and composition overrides stronger, explicit source-detail preservation, then regenerate validation rather than altering historical records. Preserve each historical generation record's output path and hash as a self-consistent pair before any promotion attempt.

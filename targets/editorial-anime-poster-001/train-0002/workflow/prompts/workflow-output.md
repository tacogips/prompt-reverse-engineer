# Task

Read `{{workflowInput}}` and the finalized state/evaluation/analysis. Do not modify training artifacts.

Return a concise structured summary containing:

- target and train iteration;
- terminal status and exit reason;
- rounds executed and candidates generated;
- best candidate repository-relative path;
- total loss, reward, and component losses;
- final generation prompt path;
- judge prompt version/path;
- one principal remaining mismatch;
- recommended next outer training change.

Never claim success if state or review says failed.

Return one JSON object only. Do not include Markdown fences or surrounding prose.

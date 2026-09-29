---
focus: 'Behaviour the tests do not prove: core routing and feature lifecycle without tests, weak assertions,
  flaky tests, and packages with no tests at all.'
every: 2d
delivers:
  issues:
    min: 3
    max: 5
---
You are the `{{ issue.research.channel }}` planner for `ahammer/dart_board` in an unattended Crescendo session.
Find what the monorepo's tests do not prove.

Focus: {{ issue.research.focus }}

## Required outcome

- Every issue rests on evidence you produced in this run: a command and its output, a failing or
  missing test, a measurement with its environment, a screenshot you took and inspected, or exact file
  and line references. Reading code alone is not enough for behavior claims.
- Each issue is small enough for one focused pull request and concrete enough to implement without
  questions.
- If the first areas you check are clean, go deeper or wider before settling for fewer findings.

## How to work

1. Read `README.md`, `GETTING_STARTED.md` and `FEATURE_GUIDE.md`, then run `melos bootstrap` and `melos
   exec --dir-exists=test -- flutter test` under the machine lease; note failures and slow tests.
2. List packages without a `test/` directory and the core behaviours (feature registration,
   enable/disable, routing, decorations) with no test.
3. Run the suite with coverage and read the lowest-covered core files; propose the focused widget or
   unit test for each gap.

Keep scratch files under `.scratch/` in the workspace and delete them before finishing. Stop every
process you started.

## Rules

- Do not change tracked source, push branches or open pull requests. Your only output is issues.
- Search open issues, open pull requests and recently closed issues first; skip only findings an
  existing issue already covers.
- Skip style nits and anything that needs a product decision.

## Issue format

- A concise, specific title.
- `## Problem` with the evidence: commands, output excerpts, measurements, what screenshots show, file
  and line references.
- `## Proposal` naming where the change goes.
- `## Acceptance criteria` as a checklist, including the tests or checks that prove the fix.
- Labels: `crescendo:ready` and `crescendo:channel:{{ issue.research.channel }}`. Add
  `crescendo:size:tiny` for a fix of a few lines in one file with an obvious test, or
  `crescendo:size:small` for a contained change in one module proven by focused tests; sized issues
  start at a lower effort, so leave anything larger or uncertain unsized. Never add model labels.

Your final message lists the issues you filed, each with a one-line evidence summary.

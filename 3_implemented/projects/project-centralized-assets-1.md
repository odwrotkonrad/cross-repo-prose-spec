## Prose Subgroup

<!-- prose assets is getting split into 3 -->

- Prose assets MUST be split into 3 parts per audience: human-prose (for people), ai-prose, common-prose (for shared prose), into a repository per audience.
- Each prose repo MUST contain a directory whose purpose is raw prose.
- it is RECOMMENDED that consumers of prose templatize prose assets into files
- Each prose repo raw prose directory MUST NOT contain any templates
- Each prose repo MAY provide templates and che profiles with assembly instructions on how to construct files from multiple prose components in .che/tpl directory
- Each prose repo MUST NOT render assembled prose into a tracked rendered file <!-- to avoid repetition -->
- human-prose repo and ai-prose repo MUST NOT reference each other.
- human-prose and ai-prose MAY reference common-prose
- common-prose MUST NOT reference human-prose nor ai-prose
- dependencies of human-prose and ai-prose MAY consume prose via che-profiles or by referencing individual files.


## Automation

- when a consumer of an upstream dependency gets its updated ref, it MUST rerender tracked files that were rendered using this upstream dependency

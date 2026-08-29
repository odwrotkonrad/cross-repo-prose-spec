## AI Skills Repo

- each skill MUST define che.yml with its full installation definition
- repo skill templates SHOULD use SKILL.md contents and other agentic instructions from ai-prose repo
- it is RECOMMENDED that repo skill templates do not contain prose of agentic instructions
- repo che profiles MUST put scripts in correct places on the system using scripts placed in scripts repo
- repo MUST NOT contain any scripts used by skills
- each skill MUST have a che profile, for loading the skill onto a system for claude code
- each skill MUST have a che profile, for loading the skill onto a system for codex
- each skill che profile MUST target a specific consumer tool (e.g. claude code)
- skills MAY be grouped in a directory, in which case the directory MUST provide a che profile to load the group of skills onto a system for a given consumer tool
- repo MUST provide a che profile to load all skills for a consumer tool from all directories, using one level deep che spec nesting (2 profiles, one for claude, one for codex)
- skill che profiles MUST NOT render onto the repository itself

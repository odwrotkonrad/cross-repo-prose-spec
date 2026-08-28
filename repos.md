## Hosts Configs

- hosts configs repo MUST define profiles per host
- profiles per host MUST include my MacOS machine
- profiles per host MUST include sandbox session profile
- profiles per host MAY include host specific configuration
- profiles per host SHOULD consult *-configs repos for configuration of tools
- it is RECOMMENDED for host configs to only configure included specs behavior using variables and environment variables

## Tools Configs

- tools configs repo MUST NOT contain user utility scripts <!-- these should be moved to scripts repo -->

## Scripts Repo

- scripts repo MUST define scripts that ai-skills use as skills dependencies
- scripts repo SHOULD contain utility scripts


### Workspace Repo

<!-- workspace - defined as - prepared place in filesystem for working with mutiple repositories, along with dependencies -->

## Prose Subgroup

<!-- prose assets is getting split into 3 --->

- Prose assets MUST be split into 3 parts per audience: human-prose( for people ), ai-prose, common-prose (for shared prose) into repository per audience.
- Each prose repo MUST contain a directory which purpose is raw prose.
- is is RECOMMENDED consumers of prose templatize prose assets into files
- Each prose repo raw prose directory MUST NOT contain any templates
- Each prose repo MAY provide templates and che profiles with assembly instructions of how to construct files from multiple prose components in .che/tpl directory
- Each prose repo MUST not render assembled prose into tracked rendered file <!-- to avoid repetition -->
- human-prose repo and ai-prose repo MUST not reference each other.
- human-prose and ai-prose MAY reference common-prose
- common-prose MUST NOT reference human-prose nor ai-prose
- dependencies of human-prose and ai-prose MAY consume prose via che-profiles or by referencing individual files.



## AI Prose Repo

- ai-prose repo MUST contain all agentic instructions used everywhere

## Common Prose Repo
<!-- common-prose prob will be rare --->

## Human Prose Repo

## AI Skills Repo

- each skill MUST define che.yml with its full installation definition
- repo skill templates SHOULD use SKILL.md contents and other agentic instructions from ai-prose repo
- is is RECOMMENDED that repo skill templates do not contain prose of agentic instructions
- repo che profiles MUST put scripts in correct places on the system using scripts placed in scripts repo
- repo MUST NOT contain any scripts used by skills
- each skill MUST have a che profile, for loading skill onto a system for claude code
- each skill MUST have a che profile, for loading skill onto a system for codex
- each skill che profile MUST target specific consumer tool (e.g. claude code)
- skills MAY be grouped in a directory, in which case directory MUST provide che profile to load group of skills onto a system for given consumer tool
- repo MUST provide che profile to load all skills for a consumer tool from all directories, using one level deep che spec nesting (2 profiles, one for claude one for codex)
- skill che profiles MUST NOT render onto repository itself


## One MCP

- one MCP MUST exists for interacting with the execution environment

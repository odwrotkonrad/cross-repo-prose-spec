## execution

- che execution of multiple profiles MUST be treated as one unit, allowing for building a dependency graph

## Remote References

- remote git sources MUST be cloned once per repository in a cache directory
- remote git sources MUST NOT include ref in directory path
- cloned remote git source MUST be reused across usages for rendering
- cloned remote git source MUST appear once in a cache
- using remote git source SHOULD be preceded by fetching refs, and this behavior MAY be disabled via option
- consulting remote git source for contents of files MUST happen in a worktree, to allow concurrent execution
- git worktree of remote git source MUST be created per ref in cache directory, and MUST be reused in repeated execution for that ref
- git worktree created for ref MUST be tracked in a che database
- git worktree created for ref MUST be removed after a configurable amount of time, counting from last use, defaulting to 4 weeks

## Installation

- binary installation method SHOULD install binaries into XDG_STATE_HOME into a directory designated for che installed binaries
- binary installation method SHOULD link binaries from XDG_STATE_HOME to a user preferred location
- binary installation method MUST consult XDG_STATE_HOME che bin directory to check if a particular version is already available, and if it is, reuse the binary and link it to the user preferred location
- che installation SHOULD track installation per package per version, and clear XDG_STATE_HOME for versions unused for a configurable amount of time, defaulting to 4 weeks

## Running Scripts

- che MUST provide a granular way to control script invocation per script using variables and environment variables, using names and regexps

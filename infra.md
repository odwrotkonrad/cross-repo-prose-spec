



<!-- so permissions for a consumer that uses identity can be reviewed quickly -->


## Base Infra Repo

## Resources

- base infra repo MUST create all:
  - artifact registries
  - terraform state buckets for other repositories
  - git repositories



### IAM Resources

- base infra repo MUST contain definitions of all identities in a directory for its purpose
- base infra repo MUST contain permissions of all identities in a directory for its purpose
- base infra repo SHOULD create identities for
- on exceptional basis other repos MAY create identities reusing id definitions from base repo
- each consumer of identity MUST get its own directory iam directory for it's ID and permissions

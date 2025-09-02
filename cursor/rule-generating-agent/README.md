# Project Rules Setup

This project uses **`rule-generating-agent`** together with [cursor.directory](https://cursor.directory/generate) to automatically generate and manage project rules.  

## How It Works
- `rule-generating-agent` provides the logic for creating rules.  
- [cursor.directory](https://cursor.directory/generate) is used as a reference point for organizing and applying those rules.  
- Together, they help maintain consistency across the project and simplify rule management.  

This project integrates **`rule-generating-agent`** together with [cursor.directory](https://cursor.directory/generate) to automatically generate, package, and manage project rules inside the repository.  

## Workflow

1. Go to [cursor.directory](https://cursor.directory/generate) and generate the rules you need.  By requirement, package, ...
2. Copy the generated rules into a file with the extension `.md` (for example: `project-rules.md`).  
3. Run **`rule-generating-agent`** on the `.md` file to automatically create project rules.  

## Reference
For more details, check out this video:  
[YouTube – Automating Project Rules](https://www.youtube.com/watch?v=BIVmnda0yso)

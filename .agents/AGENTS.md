# FinKeep Workspace Rules

## Planning Workflow
When starting a task, we plan first and document/update the plan in the [planning.md](file:///mnt/BACKUP/WORKSHOP/Personal/Projects/FinKeep/repo/finkeep/planning.md) file at the root of the repository. After the task is completed, we update [planning.md](file:///mnt/BACKUP/WORKSHOP/Personal/Projects/FinKeep/repo/finkeep/planning.md) to check off the progress.

## Standard Development Procedure (Strict Step-by-Step)
1. **Brainstorming & Design Discussion**: Before writing a single line of code, discuss all pros, cons, architectural implications, and user request details with the user.
2. **Finalize Plan**: Create/update `planning.md` and wait for explicit plan approval.
3. **Micro-development Cycles**: Start implementing **one small step at a time** (e.g., 1-2 classes or one layer at a time, such as entities/models first, then datasource, then repository, then use cases, then controllers, then UI screens).
4. **Interactive Code Review**: Present the code for that single micro-step, get user feedback, and make any requested adjustments.
5. **Commit Progress**: Commit the approved changes to git before proceeding to the next step. Never skip ahead or bundle multiple phases/layers in one large output.


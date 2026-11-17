Git Reset and Revert

1. Overview

Git provides different ways to undo changes and correct mistakes in a repository.

Two important commands are:

- "git reset": moves the current branch reference to another commit and can modify the staging area and working directory.
- "git revert": creates a new commit that reverses the changes introduced by an earlier commit.

The main difference is how they affect Git history.

2. Git Reset

The "git reset" command moves the current branch reference (HEAD) to a specified commit.

Depending on the selected mode, it also changes the staging area and working directory.

2.1 Soft Reset

git reset --soft HEAD~1

A soft reset moves HEAD back by one commit but keeps all changes staged.

- HEAD moves to the previous commit.
- The staging area remains unchanged.
- The working directory remains unchanged.

Use case: Undo the last commit while keeping its changes ready for a new commit.

2.2 Mixed Reset

git reset --mixed HEAD~1

Mixed is the default reset mode.

- HEAD moves to the previous commit.
- The staging area is reset.
- The working directory keeps the file changes.

The changes become unstaged.

Use case: Undo a commit and review or modify its changes before staging them again.

2.3 Hard Reset

git reset --hard HEAD~1

A hard reset moves HEAD and resets both the staging area and the tracked files in the working directory.

- HEAD moves to the specified commit.
- The staging area is reset.
- Tracked files are restored to the selected commit state.
- Uncommitted changes to tracked files can be permanently lost.

Important: "git reset --hard" does not normally remove untracked files.

Use case: Discard local changes and return tracked files to a previous commit state.

Use this command carefully because it can cause data loss.

3. Git Reset Modes Compared

Mode| HEAD| Staging Area| Working Directory
"--soft"| Moves| Unchanged| Unchanged
"--mixed"| Moves| Reset| Changes remain
"--hard"| Moves| Reset| Tracked files reset

4. Git Revert

The "git revert" command reverses the changes introduced by a previous commit.

git revert <commit-hash>

Unlike reset, revert does not remove the original commit from history.

Instead, it creates a new commit that applies the opposite changes.

Example

Original history:

* 29c7c49 Add Git revert practice file
* c8f9802 Add GitHub Actions and CI documentation

After running:

git revert 29c7c49

The history becomes:

* 2f77b62 Revert "Add Git revert practice file"
* 29c7c49 Add Git revert practice file
* c8f9802 Add GitHub Actions and CI documentation

The original commit remains in the history, while the new commit reverses its changes.

Use case: Safely undo a change that has already been shared with others.

5. Reset vs. Revert

Feature| Reset| Revert
Original commit| Can be removed from current branch history| Remains in history
Creates a new commit| No| Yes
Moves HEAD backwards| Yes| No
Changes the working directory| Depends on reset mode| Applies reverse changes
Suitable for shared history| Generally avoid on published commits| Generally safer

Important Consideration

Avoid rewriting published branch history unless there is a clear reason and all collaborators understand the consequences.

For commits already pushed to a shared branch, "git revert" is generally the safer option.

6. Useful Inspection Commands

View commit history

git log --oneline

View commit history as a graph

git log --oneline --graph --all --decorate

Inspect a specific commit

git show <commit-hash>

Check repository status

git status

Compare local and remote history

git log --oneline main..origin/main

7. Practical Exercise Results

The following operations were performed in the DevOps homelab repository.

Reset Practice

- Created a test file: "reset-practice.md".
- Created commit "54f1a54".
- Tested "git reset --soft HEAD~1".
- Created a replacement commit "f141de3".
- Tested "git reset --mixed HEAD~1".
- Observed that the file became untracked.
- Added the file to the staging area.
- Tested "git reset --hard HEAD".
- Verified that the staged, uncommitted file was removed.

Revert Practice

- Created "revert-practice.md".
- Created commit "29c7c49".
- Inspected the commit using "git show --stat".
- Executed "git revert 29c7c49".
- Created revert commit "2f77b62".
- Verified that the original commit remained in history.
- Verified that the test file was removed.

8. Key Takeaways

- Use "--soft" to undo a commit while keeping changes staged.
- Use "--mixed" to undo a commit while keeping changes unstaged.
- Use "--hard" to reset tracked files and discard local changes.
- Remember that untracked files are not normally removed by "git reset --hard".
- Use "git revert" to undo changes without rewriting existing commit history.
- Prefer revert for changes that have already been pushed to shared branches.

Git Rebase

1. Purpose

This document explains Git rebase, how it works, and how it can be used to update a feature branch with the latest changes from the main branch.

2. What is rebase?

Rebase moves or replays commits from one branch onto another base commit.

It is an alternative to merge when integrating changes from different branches.

Unlike merge, rebase rewrites the commit history by creating new commits with new commit hashes.

Before rebase

Two branches have diverged from a common commit:

* C (main)
| * D (feature)
|/
* A

After rebase

The feature commit is replayed on top of the latest main commit:

* D' (feature)
* C (main)
* A

The original commit D is replaced by a new commit D'.

3. Basic rebase workflow

Step 1: Switch to the feature branch

git switch feature/my-feature

Step 2: Rebase onto main

git rebase main

Git replays the feature branch commits on top of the latest main commit.

Step 3: Verify the commit history

git log --oneline --graph --all

Step 4: Merge the feature branch into main

git switch main
git merge feature/my-feature

If the feature branch is now a direct descendant of main, Git can perform a fast-forward merge.

4. Rebase vs. merge

Merge| Rebase
Combines branch histories| Replays commits onto a new base
Preserves existing commits| Creates new commit hashes
Can create a merge commit| Usually produces linear history
Does not rewrite existing commit history| Rewrites the affected commit history

5. Important considerations

- Rebase does not automatically merge changes into the target branch.
- Rebase changes commit hashes because new commits are created.
- Avoid rebasing shared branches that other developers are already using.
- Rebase is commonly used to update personal feature branches before integration.
- Always check the working tree before starting a rebase.

6. Useful commands

Command| Description
"git rebase main"| Rebase the current branch onto main
"git log --oneline --graph --all"| Display the commit history graph
"git diff main..feature"| Compare the content of two branches
"git status"| Check the working tree state
"git rebase --abort"| Abort an ongoing rebase
"git rebase --continue"| Continue after resolving a rebase conflict

7. Practical exercise results

The following workflow was completed in the DevOps homelab repository:

1. Created "feature/rebase-practice".
2. Added and committed "rebase-practice.md".
3. Created a separate commit on "main".
4. Rebased the feature branch onto main.
5. Verified the new linear commit history.
6. Merged the feature branch into main using fast-forward.

Original feature commit:

5515223 Add rebase practice file

New commit after rebase:

3ae1693 Add rebase practice file

The original commit hash changed, while the file content was preserved.

8. Summary

Git rebase is useful for maintaining a clean, linear commit history.

It allows developers to update their feature branches with changes from the main branch without creating an additional merge commit during the update process.

The choice between merge and rebase depends on the workflow and whether the branch is shared with other developers.

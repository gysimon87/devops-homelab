# Git Branching and Merge Conflicts

## Purpose

This document describes Git branching, pull requests,
merge operations and conflict resolution through practical examples.

## 1. Branching

A branch is an independent line of development within a Git repository.

Branches allow developers to work on different features or changes
without directly modifying the main branch.

### Creating a branch

A new branch can be created with:

    git switch -c branch-name

This command creates a new branch and switches to it.

### Listing branches

    git branch

The currently active branch is marked with an asterisk (*).

## 2. Pull Requests and Merging

A Pull Request (PR) is a request to integrate changes
from one branch into another.

A typical workflow:

1. Create a feature branch.
2. Make changes to files.
3. Stage and commit the changes.
4. Push the branch to the remote repository.
5. Create a Pull Request on GitHub.
6. Review and merge the changes into the main branch.

### Pushing a new branch

    git push -u origin branch-name

The -u option sets the upstream branch.
Future push and pull commands can then use the configured upstream.

### Merge commit

A merge commit combines the histories of two branches.

A merge commit normally has two parent commits:
the previous commit on the target branch and the merged branch's tip.

### Updating the local main branch

    git switch main
    git pull

This updates the local main branch with changes from its remote counterpart.

## 3. Merge Conflicts

A merge conflict occurs when Git cannot automatically
combine changes from different branches.

A common example is when two branches modify the same
line of a file differently.

### Conflict markers

Git marks the conflicting sections in the file:

    <<<<<<< HEAD
    Current branch version
    =======
    Incoming branch version
    >>>>>>> feature-branch

- `<<<<<<< HEAD` marks the current branch version.
- `=======` separates the two versions.
- `>>>>>>>` marks the incoming branch version.

### Resolving a conflict

1. Open the file containing the conflict.
2. Decide which changes should be kept.
3. Edit the file and remove all conflict markers.
4. Stage the resolved file.

    git add filename

5. Complete the merge by creating a merge commit.

    git commit

Running `git add` marks the conflict as resolved.
It does not automatically decide which version of the content is correct.

## 4. Merge Commit and History

A merge commit connects two separate development histories.

Unlike a regular commit, a merge commit normally has
two parent commits.

The commit history can be inspected with:

    git log --oneline --graph --all

To inspect the parent commits of the current commit:

    git show --no-patch --pretty=raw HEAD

A merge commit contains references to both parent commits.

## 5. Comparing Branches with Git Diff

Git diff can compare the content of two branches.

### Two-dot notation

    git diff branch-a..branch-b

Compares the current file contents at the tips
of branch-a and branch-b.

### Three-dot notation

    git diff branch-a...branch-b

Compares the merge base of the two branches
with the current content of branch-b.

The merge base is the best common ancestor commit
shared by the two branches.

### Important distinction

The two notations can produce different results.

If branch-a is already an ancestor of branch-b,
the merge base is the current tip of branch-a.
In this case, the two commands may produce identical results.

The order of the branches also matters.

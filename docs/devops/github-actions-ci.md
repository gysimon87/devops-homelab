GitHub Actions and Continuous Integration (CI)

1. What is Continuous Integration?

Continuous Integration (CI) is a development practice where code changes are automatically checked after they are pushed to a repository or submitted through a Pull Request.

The goal is to detect problems early, before changes are merged into the main branch.

Typical CI tasks include:

- Static code analysis
- Syntax validation
- Automated tests
- Code quality checks
- Build verification

In this project, GitHub Actions is used to run ShellCheck automatically against Bash scripts.

2. What is GitHub Actions?

GitHub Actions is an automation platform integrated into GitHub.

It can execute predefined workflows in response to repository events, such as:

- Pushing commits
- Creating or updating Pull Requests
- Creating releases
- Running scheduled tasks

A workflow is defined in a YAML file inside the repository.

Workflow files are stored in:

.github/workflows/

3. Workflow structure

The ShellCheck workflow is stored in:

.github/workflows/shellcheck.yml

Its structure:

name: ShellCheck

on:
  push:
    branches:
      - main
      - feature/shellcheck-ci
  pull_request:
    branches:
      - main

jobs:
  shellcheck:
    name: Run ShellCheck
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Install ShellCheck
        run: |
          sudo apt-get update
          sudo apt-get install -y shellcheck

      - name: Run ShellCheck
        run: |
          find . -type f -name "*.sh" -not -path "./.git/*" -print0 | xargs -0 -r shellcheck

4. Understanding the YAML configuration

name

name: ShellCheck

Defines the workflow name displayed in the GitHub Actions interface.

on

Defines which GitHub events trigger the workflow.

on:
  push:
    branches:
      - main
      - feature/shellcheck-ci

The workflow runs when commits are pushed to either of these branches.

  pull_request:
    branches:
      - main

The workflow also runs when a Pull Request targets the "main" branch.

jobs

A workflow contains one or more jobs.

jobs:
  shellcheck:

The job identifier is "shellcheck".

runs-on

runs-on: ubuntu-latest

Specifies the environment where the job executes.

GitHub provides a hosted Ubuntu runner for this job.

steps

A job consists of individual steps executed in sequence.

Step 1: Checkout repository

- name: Checkout repository
  uses: actions/checkout@v4

Downloads the repository contents into the runner's working directory.

The workflow needs this step to access the project's files.

Step 2: Install ShellCheck

- name: Install ShellCheck
  run: |
    sudo apt-get update
    sudo apt-get install -y shellcheck

Updates the package information and installs ShellCheck.

Step 3: Run ShellCheck

- name: Run ShellCheck
  run: |
    find . -type f -name "*.sh" -not -path "./.git/*" -print0 | xargs -0 -r shellcheck

Finds Bash scripts in the repository and runs ShellCheck against them.

Command breakdown:

Command| Purpose
"find ."| Search from the current directory
"-type f"| Select regular files
"-name "*.sh""| Select files ending in ".sh"
"-not -path "./.git/*""| Exclude Git's internal directory
"-print0"| Separate filenames with null characters
"xargs -0"| Read null-separated filenames
"-r"| Do not run ShellCheck if no files are found
"shellcheck"| Analyze the scripts

Using "-print0" and "xargs -0" makes the command safer when filenames contain spaces or special characters.

5. What is ShellCheck?

ShellCheck is a static analysis tool for shell scripts.

It identifies potential problems without executing the scripts.

Examples include:

- Unquoted variables
- Syntax errors
- Suspicious expressions
- Common scripting mistakes

Example:

NAME="$1"
echo $NAME

ShellCheck reports:

SC2086: Double quote to prevent globbing and word splitting.

Corrected version:

NAME="$1"
echo "$NAME"

The corrected script passes the relevant ShellCheck check.

6. How the CI process works in this project

The implemented workflow follows this process:

1. A developer makes changes on a feature branch.
2. Changes are committed and pushed to GitHub.
3. GitHub Actions detects the push event.
4. A hosted Ubuntu runner starts.
5. The repository is checked out.
6. ShellCheck is installed.
7. Shell scripts are analyzed.
8. GitHub reports whether the workflow succeeded or failed.
9. When a Pull Request targets "main", the workflow runs again for that PR.

This provides automated feedback before changes are merged.

7. CI versus CD

These terms are related but describe different parts of the delivery process.

Continuous Integration (CI)

Automatically checks and validates code changes.

Continuous Delivery (CD)

Keeps validated changes ready for deployment.

Continuous Deployment

Automatically deploys validated changes to the target environment.

This project currently implements CI only. It does not deploy applications or infrastructure.

8. Project implementation

The following functionality has been implemented in this repository:

- GitHub Actions workflow
- Automatic ShellCheck installation
- Automatic analysis of Bash scripts
- Workflow execution on push events
- Workflow execution on Pull Requests targeting "main"
- Verification of ShellCheck error detection

The workflow was tested by introducing a ShellCheck issue into a temporary script. The CI workflow executed successfully, and the temporary test script was subsequently removed.

9. Important concepts learned

- Continuous Integration
- GitHub Actions
- Workflows, jobs and steps
- GitHub-hosted runners
- YAML workflow configuration
- Push and Pull Request events
- Static code analysis
- ShellCheck
- Automated validation before merging changes

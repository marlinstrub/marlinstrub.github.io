# Claude

This file contains information and instructions for Claude Code.

# Overview

This repository contains the source code for my personal website, which is served at [[https://www.marlinstrub.com]] using GitHub pages.

# Development

1. Run `./build.sh` to generate the site into `public/`
2. Serve `public/` with `python -m http.server 8080 -d public`

# Deployment

This repository contains the file [[file:.github/workflows/publish.yml][.github/workflows/publish.yml]], which instructs GitHub to generate the site using [[file:build.sh][build.sh]] whenever a commit is pushed to the `main` branch. This script will place the generated files in a directory called `public` and copy the files in this directory to a branch called `gh-pages`. This branch is then hosted by GitHub.

## Project Management

This project uses tickets to keep track of work to be done. When you interact with the ticket system in this project, you **must** do so via the `tk` cli tool:

```bash
Usage: tk <command> [args]

Commands:
  create [title] [options] Create ticket, prints ID
    -d, --description      Description text
    --design               Design notes
    --acceptance           Acceptance criteria
    -t, --type             Type (bug|feature|task|epic|chore) [default: task]
    -p, --priority         Priority 0-4, 0=highest [default: 2]
    -a, --assignee         Assignee
    --external-ref         External reference (e.g., gh-123, JIRA-456)
    --parent               Parent ticket ID
    --tags                 Comma-separated tags (e.g., --tags ui,backend,urgent)
  start <id>               Set status to in_progress
  close <id>               Set status to closed
  reopen <id>              Set status to open
  status <id> <status>     Update status (open|in_progress|closed)
  dep <id> <dep-id>        Add dependency (id depends on dep-id)
  dep tree [--full] <id>   Show dependency tree (--full disables dedup)
  dep cycle                Find dependency cycles in open tickets
  undep <id> <dep-id>      Remove dependency
  link <id> <id> [id...]   Link tickets together (symmetric)
  unlink <id> <target-id>  Remove link between tickets
  ls [--status=X] [-a X] [-T X]   List tickets
  ready [-a X] [-T X]      List open/in-progress tickets with deps resolved
  blocked [-a X] [-T X]    List open/in-progress tickets with unresolved deps
  closed [--limit=N] [-a X] [-T X] List recently closed tickets (default 20, by mtime)
  show <id>                Display ticket
  edit <id>                Open ticket in $EDITOR
  add-note <id> [text]     Append timestamped note (or pipe via stdin)
  query [jq-filter]        Output tickets as JSON, optionally filtered

Tickets stored as markdown files in .tickets/
Supports partial ID matching (e.g., 'tk show 5c4' matches 'nw-5c46')
```

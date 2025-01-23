# Code Review Guidelines

The goal is to review code before being merged into the main branch (trunk).

Extracted from:

* https://www.nnja.io/post/2018/2018-djangocon-code-review/ (talk + slides, [newer version of slides](https://www.nnja.io/post/2019/oscon-2019-code-review-skills-for-people/))
* https://phauer.com/2018/code-review-guidelines/ (also contains a list as "The Code Review Cheat Sheet")

## Benefits

* find bugs & design flaws (before code is done/before customers (patients) find them)
* shared ownership (team)
* shared knowledge --> reduce lottery factor (no developer is only expert)
* ensure consistency --> increase code quality long term, easier to maintain long term and also by others (team)

## General

* code review is a friendly discussion
* don't take feedback personally (you are not your code)
* all changes should be reviewed by at least 1 other developer
* independent of seniority
* no blame culture
* be a great reviewer **and** a great submitter
* use automation as much as possible
* repos should use checklist to make submitter aware of things that should be included
* record results of conversations in merge requests for future

## How to be a great submitter

* submit one issue per merge request
* solving unrelated problem: new merge request
* keep merge requests as small as possible (helps prevent reviewer burnout)
  * ideally less than 500 LoC
* make use of WIP/mark as draft to get early feedback --> helpful for architectural/design decisions/issues and bigger changes
* you are the primary reviewer: look at the diff yourself and see if you spot anything (this gives you a different look at your change and might reveal something you didn't notice before or forgot about)
  * don't rely on others to catch your mistakes
  * ensure code works, thoroughly tested
* provide context: mention/link issue, document why change is necessary
* anticipate feedback (it's a conversation), be humble
* ensure readability of code
* check for reusable/maintainable code
* use utility methods
* remove debugger/print statements
* let reviewer resolve threads (gives them a chance to look at the changes again)

## Reviewer

## What to look out for

* architecture
* design
* logic
* tests
* smaller stuff (syntax, naming, ...)

## How to

* comment on merge request
  * use threads for general comments (so they can be marked as resolved)
  * use in-line comments on code when referring to particular lines of code (single or multiple lines)
* when submitter adjusts, you can look at the diff in the thread
  * mark as resolved

## How to be a great reviewer

* have empathy
* be objective ("this method is missing ..." instead of "you forgot to ...")
  * talk about code, not the coder
  * use "I ..."
* ask questions, don't give answers
* offer suggestions
* terms to avoid
  * simply
  * easily
  * just
  * obviously
  * well, actually
* have clear feedback
  * support your opinion with how & why
  * link to supporting documentation/articles
* compliment good work & great ideas
* "the goal is better code, not "exactly the code you would have written""
* use "nit:"/"nit-pick:" for nit-picks
* try to do reviews in 24-48 hours (helps the change stay fresh in the submitters mind to address feedback)

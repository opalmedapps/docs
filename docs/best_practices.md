# Software Engineering Best Practices

The purpose of this document is to provide an overview of the software engineering principles and best practices used and enforced at O-HIG for all development. For changes to legacy code that did not adhere to these standards, exceptions can be made.

Automating tasks to check/enforce these principles should be used wherever possible. This relieves the developers (code reviewers) from these tedious tasks and allows them to focus more on the business logic, implementation etc.

Any best practice outlined in this document should come with a rationale on why it is important:


> “Good advice comes with a rationale so you can tell when it becomes bad advice. If you don’t understanding why something should be done, then you’ve fallen into the trap of cargo cult programming, and you’ll keep doing it even when it’s no longer necessary or even becomes deleterious.”
> 
> &mdash; ***Raymond Chen*** at [The Old New Thing](https://devblogs.microsoft.com/oldnewthing/20091104-00/?p=16153)


## Version Control

Everything relating to a certain project needs to be version controlled in the corresponding repository. This serves as the single source of truth.

Everything that is text-based should be version controlled. Besides source code itself this includes Docker files, CI/CD files, bash scripts, backup scripts, documentation, translations etc.

Each repository should have a `.gitignore` (to ignore any unnecessary files, e.g., OS-specific ones. See [collection of gitignore templates](https://github.com/github/gitignore)) and `.gitattributes` file (to tell Git how to handle line endings, binary files, LFS etc. see [why this is necessary](https://rehansaeed.com/gitattributes-best-practices/) and a [collection of useful templates](https://github.com/alexkaratarakis/gitattributes)).


## Documenting Changes and Decisions

Everything that is not part of the repository (“the single source of truth”), such as results of discussions, decisions and changes etc., should be documented in the corresponding issue. This provides traceability for the future, not just for other developers but also for your future self.

To that effect, commits should reference the corresponding issue the commit is made for.

!!! note

    Jira and GitLab should be connected in order to facilitate this: [https://docs.gitlab.com/ee/integration/jira/issues.html](https://docs.gitlab.com/ee/integration/jira/issues.html) (see also: [https://about.gitlab.com/solutions/jira/](https://about.gitlab.com/solutions/jira/))


## Commit Style

Good commit messages matter:


> “a well-crafted Git commit message is the best way to communicate _context_ about a change to fellow developers (and indeed to their future selves). A diff will tell you _what_ changed, but only the commit message can properly tell you _why_.”
>
> &mdash; ***cbeams*** via [How to Write a Git Commit Message](https://cbea.ms/git-commit/)

Make commits [after each logical change](https://sethrobertson.github.io/GitBestPractices/#commit) (or select those changes that form a logical change). This also makes it easier to explain the change in the commit message. Never just blindly add the whole file to commit to avoid adding temporary code. Make use of visual Git tools or the integration within the IDE and leverage the Git index (staging). I.e., use the diff to select those changes in a file that relate to the change you are about to commit.

Reference the issue the commit relates to. This helps in the future when dealing with bugs or generally when determining why a certain change in the code was made.


### Resources

* [How to Write a Git Commit Message](https://cbea.ms/git-commit/)
* [Commit Often, Perfect Later, Publish Once—Git Best Practices](https://sethrobertson.github.io/GitBestPractices/#commit) 


## Code Style

All code needs to follow a commonly decided code style. Each language has a code style that is agreed upon (see language specific sections below).

If you have a strong opinion/preference about something you disagree with in the code style, bring it up to the team and discuss the rationale.


## Comments

Comments provide documentation about what a piece of code is supposed to do, how to call it and what could happen. It helps your future self and other developers.

All classes, functions/methods and constants (whether they are public or private) need to be documented using the corresponding documentation standard of the language (e.g., JavaDoc, JSDoc, Python Docstring etc.). Doing so provides the ability to generate documentation documents that provide an overview of the functionality of the code base. Private functionality also needs documentation in order to help developers understand.

Comments within the code itself should only be added if additional context is required. For example, to clarify why something is done or if it’s not obvious right away/quite complex.


## Documentation

A documentation document should be generated containing prose and API reference. The documentation text should reside within the repository as well (i.e., version controlled and part of the overall development process).

As part of the CI/CD process the live documentation needs to be generated and made available in a place where it is accessible by all developers.

Whenever new functionality is added or existing functionality modified, the specification documentation needs to be extended/updated.


## Testing

Unit tests need to be written for most of the code. This can be done before making the change, after making the change or during. The tests should not only cover one (successful) code path but the goal is to achieve branch coverage and test for different inputs and error conditions. While you design your code, think about all the different ways this could be called, what should be considered and what could potentially go wrong (and test for those).

!!! todo "TODO/TBD"

    Integration tests, UI tests, smoke tests, …?


## Continuous Integration (CI) and Delivery (CD)

Each repository needs to have a pipeline (or several) defined that runs the different steps (linting, type checking, tests, coverage, building Docker images etc.) each time someone pushes to the repository.

Continuous Delivery should be used to automatically deploy the changes to a testing environment.


## Code Review

Every change needs to be reviewed by at least one other developer (for more complex changes/features this would ideally be at least 2).

As much as possible should be automated here to avoid the reviewers having to nag about code style etc. and instead allow them to focus on the business logic, design and implementation.

A guide on providing good code review is available at [Google's Engineering Practices documentation](https://google.github.io/eng-practices/review/reviewer/).

The following principles taken from the above guide are especially important to follow:



1. ^^Fast response time^^

    The code review process is meant to improve the quality of new code. However, if the process becomes too frustrating to developers, it can have the opposite effect by becoming an obstacle against making valuable changes.


    The total code review process can be as fast or as slow as needed, but **the delay between each reply should be as short as possible**. It should take a day (or at most a few days) to submit your first comments, and the participants should reply to new commits or messages as soon as possible (but without interrupting focused work).


    A fast response time is important because "**most complaints about the code review process are actually resolved by making the process faster**", and since "slow reviews also discourage code cleanups, refactorings, and further improvements".

2. ^^Improved quality^^

    Code review involves using time and effort to improve the quality of new code, but also requires choosing a stopping point at which to integrate changes into the project and ensure forward progress.


    You must balance between your responsibility to ensure good code quality, and the need to allow developers to make progress. **Don't allow code to be integrated that reduces the overall quality of the system** (unless in an emergency). That being said, code review must end at some point. A good rule of thumb is that "reviewers should favor **approving a CL [changelist] once it is in a state where it definitely improves the overall code health of the system being worked on, even if the CL isn’t perfect**.

3. ^^Giving clear expectations^^

    Clear communication helps code reviews to go more smoothly and be more effective. Here are some examples of things that should be communicated:

    * If you're holding off on approving changes until something specific is done, let the author know so you aren't both left in an uncertain waiting state.
    * Identify any suggestions that you want to leave up to the developer to accept or ignore (take it or leave it) and for which you don't expect follow-up. These are suggestions that the author can ignore if they choose to.
    * You can identify small detail changes, often style-related, as "nit:" (representing a nit-pick).
    * Let the author know if you were only able to review one aspect of a changelist. For example, if you reviewed database changes but someone else needs to review the security aspect of those changes, let the author know.

Read the entire guide linked above for more information on what to review (design, functionality, complexity), how to proceed (high-level, main changes, then check each line), and other suggestions (mention when you see good things, etc.).


### Resources

* [How to do a code review | eng-practices | Google](https://google.github.io/eng-practices/review/reviewer/)
* [Code Review Guidelines for Humans](https://phauer.com/2018/code-review-guidelines/)
* [How to Make Good Code Reviews Better - Stack Overflow Blog](https://stackoverflow.blog/2019/09/30/how-to-make-good-code-reviews-better/)
* [Best Practices for Code Review | SmartBear](https://smartbear.com/learn/code-review/best-practices-for-peer-code-review/)


## Branching style

A very common branching model is [git flow](https://nvie.com/posts/a-successful-git-branching-model/) (main, develop, feature and hotfix branches). Very popular is also [GitHub Flow](https://docs.github.com/en/get-started/quickstart/github-flow) (main and feature/hotfix branches) which treats main as always deployable.

Git Flow has additional complexity which is worth it in some cases (see [Workflows Comparison: Git Flow Vs GitHub Flow](https://www.freshconsulting.com/insights/blog/git-development-workflows-git-flow-vs-github-flow/)).

[GitLab Flow](https://about.gitlab.com/topics/version-control/what-is-gitlab-flow/) is a simpler version of Git Flow.

**Proposal:** Start with the simple model (GitHub Flow) and see if that is sufficient. Unless we have strong reasons to use a more complex model due to the way we deploy.


## Merging

Developers have different opinions on merging, rebasing and squashing and there are pros and cons for each. Because of this it makes sense to provide common guidelines on when to use which merge strategy.

When following the practice of “commit early, commit often” and making commits with logical changes (see [Commit Style](#commit-style)) having the progress of a feature change visible through these commits can still be beneficial in the future. For example, Git provides the ability to use binary search to find the commit that introduced a bug (<code>[git bisect](https://git-scm.com/docs/git-bisect)</code>).  This is easier to accomplish the smaller the changes are that a commit adds.

In general, there are explicit merges, fast-forward merges and “squash on merge”. A great visualization of these is provided in the article [Pull Request Merge Strategies: The Great Debate - Atlassian Developer Blog](https://blog.developer.atlassian.com/pull-request-merge-strategies-the-great-debate/) and a debate on pros and cons can be found at [Git team workflows: merge or rebase? | Atlassian Git Tutorial](https://www.atlassian.com/git/articles/git-team-workflows-merge-or-rebase)

!!! todo "TBD"

    Use squash merge vs. merge commit


### Resources

* [Pull Request Merge Strategies: The Great Debate - Atlassian Developer Blog](https://blog.developer.atlassian.com/pull-request-merge-strategies-the-great-debate/)
* [Git team workflows: merge or rebase? | Atlassian Git Tutorial](https://www.atlassian.com/git/articles/git-team-workflows-merge-or-rebase)
* [Two years of squash merge - DNSimple Blog](https://blog.dnsimple.com/2019/01/two-years-of-squash-merge/)


## Containerization

Each component should be containerized, i.e., a [Dockerfile](https://docs.docker.com/engine/reference/builder/) needs to be defined. Ensure that also a [.dockerignore](https://docs.docker.com/engine/reference/builder/#dockerignore-file) file is provided to exclude any unwanted data to be added to the container image. This also speeds up the process of building an image (e.g., when the `.git` directory is excluded). 

For local development, provide a [Compose](https://docs.docker.com/compose/) file.

Containerizing components allows reproducible builds (no more “works on my machine”) and they can be used in all steps of the development process (locally, CI, deployment etc.). Furthermore, the Dockerfile in a way documents the dependencies that are required for a component to be run (e.g., a certain system package to connect to a DB).

Containers should be modular, i.e., one container per component (single responsibility principle).

Best practices for Dockerfiles: See below.


## Dependency Management

Any dependency added increases the complexity and it needs to be evaluated whether the dependency is really required. If in the end only a small function is used from the dependency, it might make more sense to implement this small function instead of adding the dependency.

Dependencies should be pinned to the exact version to allow for reproducible builds. Dependencies need to be kept up-to-date, especially minor and patch versions that fix bugs or vulnerabilities. This should be automated (with tools like [Renovate](https://github.com/renovatebot/renovate) or similar).

Furthermore, a list of dependencies (Bill of Materials) needs to be maintained. The dependency name, version and license needs to be included. This should be automated if possible.


## Methodology

Any (app) component should follow the Twelve-Factor App Methodology: [https://12factor.net/](https://12factor.net/)


* [Store config in the environment](https://12factor.net/config): “An app’s config is everything that is likely to vary between deploys (staging, production, developer environments, etc).” \
This allows one to configure different deploys using the environment, e.g., using .env file(s), environment variables, environment files (Docker) etc.


## Reusing Code

In general, the principle to follow is “Don’t Repeat Yourself (DRY)”.

If there is already similar functionality but it does not exactly match what you need to accomplish, consider rewriting the existing functionality to make it more generic.

Anything that is reusable should either go into dedicated packages/modules (e.g., utils for smaller functionality) or into their own package. Moving functionality into their own package makes it reusable across projects.

For example, across the Opal stack encryption/decryption is used in several components and should ideally be provided by a dedicated package/module that is reused.


## Graceful Error Handling and Helpful Error Messages

TODO


## Open Source Contribution

TODO



* Many of the tools, packages and frameworks are open source (and free)
* Many are maintained by people in their free time
* Give back to improve them
    * Report issues
    * Create fixes if possible
* Consider: Sponsorship

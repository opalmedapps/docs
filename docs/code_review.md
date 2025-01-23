# Code Review Guidelines

The goal of these guidelines is to provide an overview of best practices and important things to consider during code review. This applies to both the submitter and reviewer. The resources (and additional ones) this was extracted from are provided at the end.

## Benefits of Code Review

Code Review is important in order to ensure that any changes get reviewed by one more more other developers before being merged into the codebase.

In short, the benefits are:

* Find bugs & design flaws before the the code is done and especially before customers (patients) find/experience them
* Shared ownership & knowledge: We are a team and no developer should be the only expert. This also helps prevent the [lottery factor](https://en.wikipedia.org/wiki/Bus_factor), i.e., ensuring there is no single human point of failure.
* Encourage consistency of code: Increases code quality and makes code easier to maintain long term by yourself and others.

## General

Generally, code review should be a friendly discussion. Don't take feedback personally (you are not your code). No one is perfect and it is human to make mistakes. Especially, don't point fingers, it is not a competition. The general goal is to have someone else look at the code which provides a different perspective. It is also an opportunity to learn from each other.

* Prioritize code reviews (as a reviewer) and responding to feedback (as the submitter). Make time in your daily schedule for code review. Spend max one hour at a time doing code review. Try to do reviews in 24-48 hours in order for the changes to stay fresh in the author's mind to address feedback.
* Each change should be reviewed by at least one other developer.
* Every developer (independent of seniority) should review. Ideally, the reviewer is someone who wrote the original (or knows the) code that was changed.
* Automation (such as CI pipelines) should be used as much as possible to prevent reviewers from having to say "you forgot to...". Repositories should also contain a [merge request template](https://docs.gitlab.com/ee/user/project/description_templates.html#create-a-merge-request-template) with a checklist to remind and ensure the submitter took care of everything.
* Sometimes, it is easier to discuss face-to-face. In such a case, please document the result of the discussion in the merge request for future traceability.
* Make use of threads and in-line comments on the merge request. Mark them as resolved when addressed.
* Submitting and reviewing are equally important: Be a great submitter **and** a great reviewer. See below for more details on how.

## What to look out for

At a high level, you should look out for the following things in a code review (sources with more details[^google] [^codeproject]):

* **Design:** Is the code well-designed and appropriate for your system?
* **Functionality:** Does the code behave as the author likely intended? Is the way the code behaves good for its users?
* **Complexity:** Could the code be made simpler? Would another developer be able to easily understand and use this code when they come across it in the future?
* **Tests:** Does the code have correct and well-designed automated tests?
* **Naming:** Did the developer choose clear names for variables, classes, methods, etc.?
* **Comments:** Are the comments clear and useful?
* **Style:** Does the code follow our style guides?
* **Documentation:** Did the developer also update relevant documentation?

Note: The above list is taken verbatim from Google's Code Review Developer Guide[^google]. A more detailed description of each item exists[^google-look-for].

## How to be a great submitter

The following is a short summary of how to be a great submitter (sources with more details[^talk] [^phauer]):

* **One concern:** Submit one issue per merge request. If you solve an unrelated problem, create a new merge request.
* **Small MRs:** Keep merge requests as small as possible to lower barrier to start review. It also helps prevent reviewer burnout. Strive for less than 500 lines. If the work is too big, try to split it into smaller (logical) pieces.
* **Get feedback early:** Make use of Draft merge requests to show your work in progress and get early feedback. This is especially helpful for architectural and design decisions to show the direction you are going in (before fully doing it) and ensuring that this is the right direction.
* **Primary reviewer: YOU:** You are the primary reviewer. Don't rely on others to catch your mistakes, ensure your code works and is thoroughly tested. It can be very helpful to look at your changes from a different perspective, i.e., looking at the changes in the merge request yourself and see if you spot anything. This different look at your code might reveal something you didn't notice before.
* **Context:** Provide context in your merge request. Mention/link the ticket you addressed and document how you addressed it. Point out any open issues or side-effects.
* **Anticipate feedback:** It is a conversation. Be humble, acknowledge that everyone makes mistakes. Don't take it personally, you are not your code.
* **Checklist:** Try using your own checklist to check for general things to ensure and for things that come up frequently in your reviews.
    * Ensure readability of code
    * Check for reusable code and utility methods
    * Remove debugger/print statements
    * Is the code maintainable, scalable, secure, resilient?

## How to be a great reviewer

The following is a short summary of how to be a great submitter (sources with more details[^talk] [^phauer]):

* **Clear Feedback:** Provide clear and actionable feedback. Opinions need to be strongly supported. Share how and why a change is necessary and back it up with supporting documentation, articles etc.
* **Be Objective:** Talk about the code, not the coder ("This method is missing ..." instead of "You forgot to ..."). It is harder to take it personally and prevents finger-pointing. Have empathy.
* **Use I-Messages**: Formulate your feedback from your point of view by expressing your personal thoughts and impressions. Use sentences that start with "I ..." (I suggest, I think, For me, etc.).
* **Ask Questions:** Ask questions instead of giving answers. It feels less like criticism, can trigger a thought process, and the submitter can explain the rationale.
* **Offer Suggestions:** Phrase suggestions accordingly, e.g., "It might be easier to ...", "We tend to do it this way ...". Make suggestions clear but accept that there are different solutions.
* **Praise:** Don't forget to express your appreciation when you see something good. Compliment good work & great ideas.
* **Avoid:** Avoid the following terms: Simply, Easily, Just, Obviously, Well, actually ... No one writes bad code on purpose. This is also an opportunity to learn from each other and grow.
* **Don't be a perfectionist:** Don't let perfect get in the way of perfectly acceptable. "The goal is better code, not 'exactly the code you would have written'"[^twitter]. Google's Guide[^google] states:

    > In general, reviewers should favor approving a CL once it is in a state where it definitely improves the overall code health of the system being worked on, even if the CL isn’t perfect.

* **Nit-pick is OK:** Nit-picking is ok. Save them for last (after all major concerns are addressed). Prefix these comments with "nit:" to convey this to the submitter.

## Resources

All referenced sources can be found as footnotes at the bottom of this page. The below list contains extra resources that may be of interest:

* Talk: Amazing Code Reviews: Creating a Superhero Collective • Alejandro Lujan • GOTO 2019: https://www.youtube.com/watch?v=ly86Wq_E18o
* How to Make Good Code Reviews Better - Stack Overflow Blog: https://stackoverflow.blog/2019/09/30/how-to-make-good-code-reviews-better/
* Best Practices for Code Review | SmartBear: https://smartbear.com/learn/code-review/best-practices-for-peer-code-review/

[^talk]: Presentation and slides on "Code Review Skills for Pythonistas": https://www.nnja.io/post/2018/2018-djangocon-code-review/
[^phauer]: Code Review Guidelines for Humans: https://phauer.com/2018/code-review-guidelines/
[^google]: Code Review Developer Guidelines - Google: https://google.github.io/eng-practices/review/
[^google-look-for]: What to look for in code review - Google: https://google.github.io/eng-practices/review/reviewer/looking-for.html
[^twitter]: Rebecca's Rules for Constructive Code Reviews - Twitter: https://twitter.com/i_a_r_n_a/status/623922369376202758
[^codeproject]: Code review guidelines - Code Project: https://www.codeproject.com/Articles/524235/Codeplusreviewplusguidelines

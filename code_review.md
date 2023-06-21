# Code Review Guidelines in OCR-D

The OCR-D coordination project (CP) is responsible for ensuring an optimal level of code quality during the third phase of the OCR-D project.
To achieve this, the CP has created a development workflow in GitHub the implementation projects (IP) should stick to.

The main part of this development workflow are GitHub's pull requests (PR).
IPs create pull requests and assign one or more of the CP's developers as reviewers.
After a successful review, the code can be merged into the codebase.

## How the Pull Requests Should Look Like

Since the CP manages the pull requests (PRs) of all IPs, they should follow a certain pattern to make reviewers' lifes easier.

Each pull request should contain only a small feature/increment.
This way it is easier for reviewers to grasp what is happening on the code level, and it shortens the time the review takes.
This also minimizes the time developers have to wait for feedback on their code.

PRs should be provided with appropriate tests (at least unit tests) so that reviewers can check if the functionality the feature provides is fully implemented.

The PR should have a meaningful description; Please keep in mind that reviewers are not necessarily familiar with every aspect and requirement of the respective IP.
Providing a description of the changes and their rationale not only helps reviewers to quickly understand the context of the PR but also serves as a kind of project documentation as well.

Last but not least developers in the IPs should keep the code review checklist below in mind during their work as well and can of course give feedback about it.

## How the Review Process Works

The CP performs informal code reviews.
A survey [1] finds these to be just as effective as more formalized forms of reviews.
Different developers have varying degrees of experience and/or expertise and therefore have different perspectives on code;
Therefore we try to cushion this effect by using an additional checklist the reviewers can consult during the review.
Of course reviewers are not bound to this checklist: 
If they spot something interesting while reading the code that's not on the list they are highly encouraged to note it anyway!
Aspects of the list that do not apply in a given PR can be skipped.
The checklist serves as a general guide to streamline the reviews but doesn't have to be worked off meticulously.

### The Code Review Checklist

During the review process reviewers should ask themselves the following questions:

- Does the feature's functionality meet the IP's requirements?
- Is the code readable? Can I understand what it's doing by simply reading it from top to bottom? Are functions and variables properly named? Do they reflect what's going on?
- Does the code stick to the repository's style guidelines?
- Is a dependency introduced that is not necessary?
- Can the code be easily expanded or changed if need be? Is the new feature/class/function coupled loosely (or not at all) to another system? Is the configuration injected instead of hard-coded?
- Does the new feature introduce any security risks? Can the code be exploited in some way?
- Is the code performant? Does it only allocate resources it actually needs? Could it achieve the same result with less disk usage/memory/...? Does the execution take as little time as possible without compromising the result?
- Does the code provide appropriate documentation where necessary, e.g. a README? Does the documentation explain _why_ things happen instead of describing _what_ happens? Do all of the comments help to understand why a certain decision has been made? Could some of the comments be removed by improving the readability of the code? Have all TODOs and commented out code been removed?
- Does the code use language features to the full extent? Can you spot any design patterns? If not, could it be feasible to introduce them?
- Are errors anticipated and handled gracefully? Are the error messages user-friendly? Are errors logged in a way such that users can understand what went wrong?
- Is the feature scalable, i.e. does it handle a lot of input or requests well?
- Is the code reusable? Does it follow the YAGNI and DRY principles?
- Does the feature reuse functionality that already exists (in a similar way) in the codebase?
- Does the feature have at least unit tests? Are the tests sufficient or are there any cases missing? Are the tests executed automatically by a CI/CD runner?
- Is there anything missing in the feature (think of edge cases, unexpected inputs etc.)?
- Is there anything to improve on the feature's architecture?
- Are the changes backwards compatible if necessary (i.e. when parts of the software that are already widely used are changed)?
- Does the CLI stick to the OCR-D guidelines?

Sources for this list:

- <https://www.codementor.io/blog/code-review-checklist-76q7ovkaqj>
- <https://www.michaelagreiler.com/wp-content/uploads/2019/08/Code_Review_Checklist_Greiler.pdf>

General sources:

[1] <https://t2informatik.de/wissen-kompakt/code-review/>

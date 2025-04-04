# OCR-D Recommendations for Using CI in Your Repository

Regarding a fast and safe integration of new changes to your software, the OCR-D Coordination Project (CP) recommends setting up and using a CI/CD tool for automating the software's unit and integration test, its build and (if applicable) deployment.
Ideally, this should be done as one of the first steps after setting up a new repository so that your software evidently build and passes quality assurance.

Depending on the version control server you use there are several options to choose from:

* GitHub
  * CircleCI
  * GitHub Actions
  * Jenkins
  * ...
* GitLab
  * GitLab CI

The choice of a CI/CD tools heavily relies on your version control server as well as your project's requirements and your institution's infrastructure.

The OCR-D CP can assist you with the following tools in case you have questions:

* CircleCI
* GitLab CI

## CI/CD Best Practices

- Try to keep your pipelines fast to get rapid feedback. Some aspects to consider are running the fastest test first (see below), using small images for your Docker containers, and caching your data.
- Your CI/CD pipelines should be furnished with proper unit and integration tests. These should run as one of the first stages in your pipelines in order to detect defects early.
- The test stage should run on every push to the remote repository in order to make sure that a commit doesn't break anything.
- Commit often in order to detect breaking changes early.
- Run your fastest test first. If they fail, they fail early and save a lot of resources compared to running slower tests first.
- Run your tests locally before running them via pipelines. This will save a lot of resources as well.
- Commit often in order to detect breaking changes early.
- Either minimize your branching model or make sure that the pipelines run on feature/bugfix branches as well. Otherwise you might not notice breaking changes in time.
- Ensure that the main functionality of your software is still up and running after having deployed (smoke testing).
- Provide an easy way to rollback in case something goes really wrong, e.g. being able to re-deploy a previous release.
- Reuse existing configuration, e.g. by leveraging CircleCI's orbs or GitLab templates.
- Secure your pipelines. Secret variable should be secret, and not everyone in your organization should have admin rights in your CI/CD environment.


## Sources

- <https://www.digitalocean.com/community/tutorials/an-introduction-to-ci-cd-best-practices>
- <https://www.fpcomplete.com/blog/continuous-integration-delivery-best-practices/>
- <https://circleci.com/blog/top-5-ci-cd-best-practices>
- … and of course our daily work with CI/CD tools.

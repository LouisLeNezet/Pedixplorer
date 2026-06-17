# `Pedixplorer`: Contributing Guidelines

Hi there!
Many thanks for taking an interest in improving Pedixplorer.

We try to manage the required tasks for Pedixplorer using GitHub issues, you probably came to this page when creating one.

## Contribution workflow

If you'd like to write some code for Pedixplorer, the standard workflow is as follows:

1. Check that there isn't already an issue about your idea in the [Pedixplorer](https://github.com/LouisLeNezet/Pedixplorer/issues) to avoid duplicating work. If there isn't one already, please create one so that others know you're working on this
2. [Fork](https://help.github.com/en/github/getting-started-with-github/fork-a-repo) the [Pedixplorer repository](https://github.com/LouisLeNezet/Pedixplorer/) to your GitHub account
3. Checkout the devel branch and create your work environment
4. Make the necessary changes / additions within your forked repository
5. Submit a Pull Request against the `devel` branch and wait for the code to be reviewed and merged

If you're not used to this workflow with git, you can start with some [docs from GitHub](https://help.github.com/en/github/collaborating-with-issues-and-pull-requests) or even their [excellent `git` resources](https://try.github.io/).

## Tests

You have the option to test your changes locally by running the unittests.
Execute all the tests with the following command:

```bash
devtools::check()
rcmdcheck
```

When you create a pull request with changes, [GitHub Actions](https://github.com/features/actions) will run automatic tests.
Typically, pull-requests are only fully reviewed when these tests are passing, though of course we can help out before then.

## Patch

:warning: Only in the unlikely and regretful event of a release happening with a bug.

- On your own fork, make a new branch `patch` based on `upstream/main` or `upstream/master`.
- Fix the bug, and bump version (X.Y.Z+1).
- Open a pull-request from `patch` to `main`/`master` with the changes.

## Getting help

For further information/help, please consult the R nf-core/utils vignettes and don't hesitate to get in touch on the nf-core Slack [#nf-core-r-utils](https://nfcore.slack.com/channels/nf-core-r-utils) channel ([join our Slack here](https://nf-co.re/join/slack)).

## Package contribution conventions

To make the `R nf-core/utils` code and processing logic more understandable for new contributors and to ensure quality, we semi-standardise the way the code and other contributions are written.

### Adding a new function

If you wish to contribute a new function, please use the following coding standards:

1. Use snake_case
2. Lint the code
3. Add documentation and example through Roxygen2 syntax
4. Add a unittest and aim for a full coverage

### Images and figures

For overview images and other documents we follow the nf-core [style guidelines and examples](https://nf-co.re/developers/design_guidelines).

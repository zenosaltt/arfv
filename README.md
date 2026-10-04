# Automated Reasoning and Formal Verification (UniTN, 26/27)

Welcome to the _Automated Reasoning and Formal Verification_ (ARFV) notes. This book is based on...

Prof. Sebastiani's [course material](https://disi.unitn.it/rseba/DIDATTICA/arfv2026/SLIDES/).

### A Typst-based project


## Build, develop, and collaborate
This repo allows you to build the PDF locally, without waiting for a brand new file in the Release page of this repository.

> Note: so far, the following instructions assume you are working inside a UNIX-like environment (Linux, macOS). For Windows users, WSL might be a useful starting point.

### Requirements
- [Docker](https://docs.docker.com/get-docker/) with the [official Typst image](https://github.com/typst/typst/pkgs/container/typst), `ghcr.io/typst/typst:0.15.1`.
- `make` and Git for the commands below.
- Optional: [Typst 0.15.1](https://typst.app/open-source/) for builds without Docker.
- [Typstyle 0.15.1](https://github.com/typstyle-rs/typstyle/releases/tag/v0.15.1) for local source formatting.

Recommended VS Code extension: [Tinymist](https://marketplace.visualstudio.com/items?itemName=myriad-dreamin.tinymist).

## Setup
Clone this repository and run `make docker-build` once to check the project and create `build/document.pdf`. That's it.

> Note: inspect the `make` file to see what commands are actually running.

## Build locally

Run these commands from the repository root:

```sh
make docker-build  # Same Typst image and command as CI; writes build/document.pdf
make clean         # Remove the local PDF
```

Docker mounts this repository at `/work` inside the container. The PDF appears in the host's `build/` directory. The image is pinned in the `Makefile`, which is also used by both GitHub workflows. A successful build needs no Dockerfile or local Typst installation.

If Typst is installed on your machine, the equivalent commands are `make build` and `make watch` (builds automatically upon file changes and saves). Both build paths use `main.typ` and write `build/document.pdf`. Fonts are included in `fonts/`, and each build command passes that directory to Typst, so local and Docker builds use the same typography.

Open the repository folder in VS Code, rather than a chapter file on its own. The committed `.vscode/settings.json` tells Tinymist to use `main.typ` as the entry point while you edit included chapters. Reload the VS Code window if you already had the project open. A chapter compiled in isolation lacks the book's heading and equation numbering rules, so references such as `@sec-local-build` can appear invalid even though the complete book compiles.

This book allows to print a version tag on its cover, so as to identify different PDF versions. To preview a release cover locally, pass a tag to either build:

```sh
RELEASE_TAG=v1.0.0 make docker-build
```

The tag is printed as `RELEASE v1.0.0` at the bottom of the cover. Without `RELEASE_TAG`, the cover has no release line. This input affects the PDF only; it does not create a Git tag or a GitHub Release. Every build also adds a separate page immediately after the cover with `last build YYYY-MM-DD`, using the compilation date even when no release tag is set.

## Format Typst sources

Run `make format` to format every `.typ` file in the project. Typstyle wraps paragraphs, captions, and code to an 80-character line width. Run `make format-check` to verify formatting without changing files. The check also reports any lines still longer than 80 characters, such as a string that cannot be split automatically; shorten or restructure those manually.

Tinymist uses the same line width and paragraph wrapping mode in VS Code, and formats Typst files when you save them. The build and release workflows install the pinned Typstyle binary, verify its SHA-256 digest, and run `make format-check` before compiling the PDF. CI reports formatting problems and fails until you run `make format` and commit the result.

## Edit the book

`main.typ` is the reading order of the book. Files in `frontmatter/` provide the
cover, build information, preface, notes, and contents; `chapters/` contains each
complete chapter; `backmatter/` contains the references. Page styles and layout
helpers live in `styles/book.typ`.

Page boundaries are written in `main.typ`: `#pagebreak()` always starts a new
page, while `#blank-page-if-needed()` starts the next part or chapter on a
right-hand page. It adds a left-hand page marked “intentionally left blank”
only when needed. The part-page, preface, notes, and contents helpers do not
insert hidden page breaks; cover and build information are self-contained
pages.

To add a chapter, create another `.typ` file under `chapters/` with a `==`
heading and `#chapter-opening()`. The chapter file includes its title, margin
contents, opening quotation, sections, and any internal page breaks. For
example:

```typst
#import "../styles/book.typ": chapter-opening, short-title

== A Chapter Title

#chapter-opening(
  quote: [An optional quotation.],
  author: [Its author],
)

=== A Section Title <sec-example>

Write the first paragraph here. Add a note#footnote[An example note.] when needed.

=== A Longer Section Title
#short-title[Short title]

Write the next paragraph here. See @sec-example for an earlier section.
```

Then add the complete chapter to `main.typ` at the desired point:

```typst
#blank-page-if-needed()
#chapter([#include "chapters/new-chapter.typ"])
```

`#chapter(...)` also advances the chapter number and resets figure, table,
algorithm, and equation numbering. To start a new part, write
`#blank-page-if-needed()` followed by `#part-page("Part Title")`.

For pseudocode, use [`algorithmic`](https://typst.app/universe/package/algorithmic/)
directly in a chapter. Its `algorithm-figure` stays in the text column and
provides the caption and reference target; the book style supplies chapter-based
numbering and paragraph-sized space around figures and tables. For example:

```typst
#import "@preview/algorithmic:1.0.7" as algorithmic
#import algorithmic: algorithm-figure

As shown in @alg-example, the procedure returns its input.

#algorithm-figure(
  [An example procedure.],
  {
    import algorithmic: *
    Function("Identity", ("x",), { Return[$x$] })
  },
) <alg-example>
```

Place a label after each `#body_diagram(...)`, `#body_figure(...)`, or
`#body_table(...)` call to reference it with `@label`. The same convention applies
to ordinary Typst `figure(...)` calls.

For a diagram in the wide right margin, use `#margin_diagram(...)` with one
diagram per call. Pass its related paragraph as `beside: [...]` and its reference
label as `id: <fig-example>`. The paragraph and the complete diagram are kept
together when the page breaks; the example in `chapters/01-sat.typ` shows both
automata this way.

## GitHub builds and releases

Every push to `main` and every pull request runs `make format-check` followed by `make docker-build`. The resulting PDF is available as a temporary `document-preview` artifact on that workflow run's page. These builds have no release tag on the cover, but still show the compilation date on the page after it.

Pushing a tag triggers the release workflow. It passes the exact Git tag to Typst, builds the PDF with Docker, and creates a GitHub Release with `document.pdf` attached. For example, after committing and pushing your changes:

```sh
git tag v1.0.0
git push origin v1.0.0
```

The cover of that release PDF displays `RELEASE v1.0.0`. Find it under the repository's **Releases** tab or on the release workflow run. Each new release needs a new tag.

# Automated Reasoning and Formal Verification

Welcome to the _Automated Reasoning and Formal Verification_ (ARFV) notes. This book is based on...

Prof. Sebastiani's [course material](https://disi.unitn.it/rseba/DIDATTICA/arfv2026/SLIDES/).

## Build and develop on your own: requirements

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

`main.typ` sets the order of the cover, front matter, parts, and chapters. Each file in `chapters/` is ordinary Typst markup: a `==` chapter heading, `===` section headings, and paragraphs written directly beneath them. There is no chapter data structure or nested `body` field. Styles and page layout live in `styles/book.typ`; images live in `images/`; references live in `bibliography.bib`.

For example, a chapter file can begin like this:

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

`#chapter-opening()` builds the small margin contents automatically from the `===` headings in that chapter. The quotation and author are optional. Place `#short-title[...]` immediately after a long section heading to abbreviate only its margin entry. The heading in the text and main contents stays complete. Add a label such as `<sec-example>` to a heading and refer to it with `@sec-example`.

To add a margin figure, import `margin_figure` from `../styles/book.typ` and place `#margin_figure("../images/name.svg", caption: [Caption text.], id: <fig-name>)` where the figure belongs. For a wider figure in the main text, import `body_figure` and write `#body_figure("../images/name.svg", [Caption text.]) <fig-name>`. Figures are numbered within each chapter, such as **Fig. 2.1**, and can be referenced with `@fig-name`.

Diagrams can also be drawn directly in Typst. The tree and finite automaton in [Chapter 2](chapters/02-workflow.typ) are defined in [`diagrams.typ`](diagrams.typ) with built-in shapes, curves, and math labels; no drawing package or image file is needed. Wrap a Typst drawing with `margin_diagram(..., caption: [...], alt: "...", id: <fig-name>)` or `body_diagram(..., [Caption], "Alternative description") <fig-name>` to retain the same figure numbering and references.

For a numbered table in the main column, import `body_table` and write `#body_table(table(columns: 2, [A], [B], [1], [2]), [Caption]) <tab-name>`. For a small table in the outer margin, import `margin_table` and pass the same `table(...)` plus `id: <tab-name>`. Use a column count or `auto` tracks to size columns to their contents; `fr` tracks expand to fill the available width. Both helpers center the table and caption. Tables have their own chapter-based sequence, such as **Table 2.1**, and can be cited with `@tab-name`. To write pseudocode, import `algorithm` and pass a title plus an array of `(indent: ..., body: [...])` lines, then attach a label and cite it with `@alg-name`. [Chapter 2](chapters/02-workflow.typ) shows all three forms.

A displayed equation such as `$ a_(n+1) = a_n + 1 $ <eq-example>` receives a chapter number such as `(2.1)` and can be referenced with `@eq-example`. Equation numbers start at one in each chapter. Add a footnote with `#footnote[Footnote text.]`. [Chapter 2](chapters/02-workflow.typ) demonstrates both figure placements, equations, and cross-references.

To add a chapter, create another `.typ` file under `chapters/` with a `==` heading and `#chapter-opening()`. Then insert these two lines in `main.typ` at the desired point:

```typst
#chapter-start()
#include "chapters/new-chapter.typ"
```

Use `#part-page("Title")` to start a new group. Parts and chapters start on right-hand pages; inserted blank pages say “intentionally left blank.” Because parts use `=` headings internally, chapters use `==` and sections use `===`.

## GitHub builds and releases

Every push to `main` and every pull request runs `make format-check` followed by `make docker-build`. The resulting PDF is available as a temporary `document-preview` artifact on that workflow run's page. These builds have no release tag on the cover, but still show the compilation date on the page after it.

Pushing a tag triggers the release workflow. It passes the exact Git tag to Typst, builds the PDF with Docker, and creates a GitHub Release with `document.pdf` attached. For example, after committing and pushing your changes:

```sh
git tag v1.0.0
git push origin v1.0.0
```

The cover of that release PDF displays `RELEASE v1.0.0`. Find it under the repository's **Releases** tab or on the release workflow run. Each new release needs a new tag.

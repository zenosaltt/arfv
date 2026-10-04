# Automated Reasoning and Formal Verification

Source for the UniTN 2026/27 ARFV notes, written in
[Typst](https://typst.app/docs/) and based on
[Prof. Sebastiani's course material](https://disi.unitn.it/rseba/DIDATTICA/arfv2026/SLIDES/)
and lectures.

## Get started

You can find the latest release (i.e., the latest PDF built by collaborators of this repository) in the Release page. Releases, are, however, less frequent than minor, and sometimes, major updates to these notes, thus you may want to build the PDF on your own. To accomplish this, you need at least Git, Make, and Docker to build the book without much effort. Don't worry, this is not LaTeX: it is going to be as easy as taking a walk around Povo 1:

```sh
# WARNING: we assume you are working inside a UNIX-like environment (e.g. Linux & macOS)

# Requirement 0: make sure Git, Make, and Docker are installed
# Requirement 1: Clone this repository first

# Inside the repository root:
make docker-build
```

The result is `build/document.pdf`. This command uses the pinned Typst 0.15.1
Docker image and the fonts in `fonts/`, so a local Typst installation is not
required. Other useful commands:

- `make build`: build with a locally installed Typst 0.15.1.
- `make watch`: rebuild after each save, using local Typst 0.15.1.
- `make clean`: remove the generated PDF.

For a tagged cover, run `RELEASE_TAG=v1.0.0 make docker-build`. The PDF will
display `RELEASE v1.0.0` on the cover and the compilation date on the next page.
`RELEASE_TAG` changes the PDF only; it does not create a Git tag or release.

## Find and edit content

- `main.typ` is the entry point: it includes files in reading order and places
  page breaks between parts and chapters.
- `frontmatter/` holds the cover, preface, notes, contents, and other opening
  pages; `chapters/` holds the chapters; `backmatter/` holds references.
- `styles/book.typ` defines the layout and reusable elements. `bibliography.bib`
  holds citation data; `images/` and `fonts/` hold local assets.

Typst uses `==` for a chapter heading here and `===` for a section. A `#` calls
a function or includes a file, while `@key` refers to a labeled figure or a
bibliography entry.

To add a chapter, create a `.typ` file in `chapters/` with a `==` heading and
`#chapter-opening()` (imported from `styles/book.typ`). Then add it at the
appropriate point in `main.typ`:

```typst
#blank-page-if-needed()
#chapter([#include "chapters/new-chapter.typ"])
```

The first call starts the chapter on a right-hand page; the second applies
chapter numbering. Import only the helpers and Typst packages your chapter
uses. Common helpers in `styles/book.typ` include `#body_figure(...)` and
`#margin_figure(...)` for figures, the corresponding `*_diagram` and
`*_table` helpers, and `#short-title[Short title]` for the margin contents.
See their definitions or existing chapters for arguments and examples.

## Checks, previews, and releases

Install [Typstyle 0.15.1](https://github.com/typstyle-rs/typstyle/releases/tag/v0.15.1)
to run `make format` before a pull request. `make format-check` checks that
formatting and the 80-character line limit. The optional VS Code settings in
`.vscode/` use Tinymist with `main.typ` as the entry point.

Pull requests targeting `main` run the format check and PDF build; download
the `document-preview` artifact from the workflow run to inspect the result.
To publish a version, push a Git tag: the release workflow builds a PDF with
that tag on the cover and attaches `document.pdf` to a GitHub Release.

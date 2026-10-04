# Automated Reasoning and Formal Verification

Typst source for the UniTN 2026/27 ARFV notes, based on
[Prof. Sebastiani's course material](https://disi.unitn.it/rseba/DIDATTICA/arfv2026/SLIDES/).
This is a draft: the SAT chapter contains a DPLL example and diagram samples;
the SMT and CTL chapters currently contain headings only. The disclaimer and
notes contain placeholder text, and the preface and chapter quotations are
samples.

## Build

From the repository root, run `make docker-build` to write
`build/document.pdf`. This uses Docker and the pinned Typst 0.15.1 image. With
Typst 0.15.1 installed locally, use `make build` or `make watch`. All builds use
`main.typ` and the bundled `fonts/` directory. `make clean` removes the PDF.

Set `RELEASE_TAG=v1.0.0` before a build to print `RELEASE v1.0.0` on the cover.
The next page shows the compilation date. The tag input changes only the PDF;
it does not create a Git tag or GitHub Release.

To format sources, install [Typstyle 0.15.1](https://github.com/typstyle-rs/typstyle/releases/tag/v0.15.1)
and run `make format`. `make format-check` checks formatting and the 80-character
line limit. The optional [Tinymist](https://marketplace.visualstudio.com/items?itemName=myriad-dreamin.tinymist)
settings in `.vscode/` use `main.typ` as the entry point.

## Edit the book

`main.typ` sets reading order and explicit page breaks. `frontmatter/` contains
the cover, build date, disclaimer, preface, notes, and contents; `chapters/`
contains the three chapters; `backmatter/` contains references. Layout and
reusable page elements are in `styles/book.typ`.

To add a chapter, create a file with a level-2 heading (`==`) followed by
`#chapter-opening()`, then add it in `main.typ`:

```typst
#blank-page-if-needed()
#chapter([#include "chapters/new-chapter.typ"])
```

`#blank-page-if-needed()` starts on a right-hand page; `#chapter(...)` advances
the chapter number and resets figure, table, algorithm, and equation numbers.
Use `#part-page("Title")` after a right-hand page break for a new part.

Available elements from `styles/book.typ`:

| Element | Use |
| --- | --- |
| `#front-page(title, body)` | Titled front-matter prose page |
| `#contents-page()` | Contents through section level |
| `#chapter-opening(quote: ..., author: ...)` | Chapter margin contents and optional epigraph |
| `#short-title[Title]` | Shorten a section title in the margin contents |
| `#body_figure(...)`, `#body_diagram(...)`, `#body_table(...)` | Image, generated diagram, or table in the text column |
| `#margin_figure(...)`, `#margin_diagram(...)`, `#margin_table(...)` | Figure or table in the right margin |
| `#epigraph(words, author)` | Small quotation with attribution |

Append `<label>` after a body figure or algorithm to reference it with `@label`.
For marginal figures and tables, pass `id: <label>`. The marginal helpers use
[Marginalia](https://typst.app/universe/package/marginalia/) to position items
without reserving text-column space. See `chapters/01-sat.typ` for diagram and
[algorithmic](https://typst.app/universe/package/algorithmic/) examples.

## GitHub builds and releases

The build workflow runs when a pull request targeting `main` is opened or
updated. It checks formatting, builds the PDF, and uploads a temporary
`document-preview` artifact. Protect `main` by requiring a PR and its `build`
check in GitHub's branch rules. Pushing a Git tag runs the separate
release workflow, which builds a tagged cover and creates a GitHub Release with
`document.pdf` attached.

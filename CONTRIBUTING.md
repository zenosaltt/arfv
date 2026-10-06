# Contributing

To build the notes locally, install Git, Make, and Docker, then follow the [build instructions](README.md#build-the-pdf-on-your-own). Run all commands below from the repository root.

## Find and edit content

The structure of this repository tries to make additions, edits, and deletes as easier as possible by placing each piece of the document in its appropriate, coherent place. Here is how the source files are arranged:

- `src/main.typ` is the entry point: it includes files in reading order and places page breaks between parts and chapters.
- `src/frontmatter/` holds the cover, preface, notes, contents, and other opening pages; `src/chapters/` holds the chapters; `src/backmatter/` holds references.
- `src/assets/styles/book.typ` defines the layout and reusable elements. `src/bibliography.bib` holds citation data; `src/assets/images/` holds the cover photo and other local assets.

Edit the relevant `.typ` file to change the text. The optional VS Code settings in `.vscode/` use Tinymist with `src/main.typ` as the entry point. Run `make watch` for a PDF that rebuilds after each save.

## Add a chapter

Create a `.typ` file in `src/chapters/` with a `==` heading and `#chapter-opening()` (imported from `../assets/styles/book.typ`). For example:

```typst
#import "../assets/styles/book.typ": chapter-opening

== New chapter

#chapter-opening()
```

Then add it at the appropriate point in `src/main.typ`:

```typst
#blank-page-if-needed()
#chapter([#include "chapters/new-chapter.typ"])
```

The first call starts the chapter on a right-hand page; the second applies chapter numbering. Common helpers in `src/assets/styles/book.typ` include `#body_figure(...)` and `#margin_figure(...)` for figures, the corresponding `*_diagram` and `*_table` helpers, and `#short-title[Short title]` for the margin contents. See their definitions or existing chapters for arguments and examples.

## Add other elements

For an opening page, add a file to `src/frontmatter/` and include it in `src/main.typ` at the intended position. Follow the surrounding page breaks and the existing front matter files for the appropriate page helper.

Add references to `src/bibliography.bib`; the bibliography is rendered by `src/backmatter/references.typ`. Store local images in `src/assets/images/`. For reusable layout or figure helpers, edit `src/assets/styles/book.typ`.

## Check changes before a pull request

Since most of this repository is made out of readable text plus some code, checks should be performed to keep everything consistent and clear. To run these checks, which are the same used in the CI, use

```sh
make check
```

This prepares the Docker tools image once, shows progress for formatting, prose, and build checks, and reports each result. Tool output is shown if a check fails; the command exits with an error if any check fails.

Here is a breakdown of the check pipeline (you can run each of them separately, in any order):
* `make format-check`: checks whether the Typst sources are well formatted, e.g. no more than 80 characters per line. Run `make format` to format edited files accordingly.
* `make prose-check`: looks for typos and inconsistencies of the English plain text inside each source file. It skips Typst code and math. If a valid term is marked as misspelled, add it to `.github/vale/config/vocabularies/ARFV/accept.txt`.
* `make build`: tries to build the PDF from the Typst source files and additional assets.

Pull requests targeting `main` run formatting, English prose, and PDF build as separate CI jobs, so each check has its own status. The build job produces `ARFV-Notes_ddmmyy.pdf`; download the `document-preview` artifact from the workflow run to inspect the result.

## Releases

For a tagged cover, run `RELEASE_TAG=vX.Y.Z make build`. The output becomes `build/ARFV-Notes_vX.Y.Z_ddmmyy.pdf`; the PDF displays `VERSION vX.Y.Z` on the cover and the compilation date on the next page. `RELEASE_TAG` does not create a Git tag or release. Without a tag, the cover shows `DRAFT` and the build date.

When preparing a release, create a version tag on the latest `main` commit and push it (replace `vX.Y.Z` with the new version):

```sh
git switch main
git pull --ff-only origin main
git tag vX.Y.Z
git push origin vX.Y.Z
```

Pushing the tag starts the release workflow. It checks formatting and English, builds the PDF with the tag on its cover, and attaches `ARFV-Notes_v1.0.0_ddmmyy.pdf` (with the actual tag and build date) to a GitHub Release.

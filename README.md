# Automated Reasoning and Formal Verification

Source for the UniTN 2026/27 ARFV notes, written in
[Typst](https://typst.app/docs/) and based on
[Prof. Sebastiani's course material](https://disi.unitn.it/rseba/DIDATTICA/arfv2026/SLIDES/)
and lectures.

## Get started

You can find the latest PDF in the Releases page. Releases are less frequent
than updates to the notes, so you may want to build the PDF yourself. On Linux
and macOS, install Git, Make, and Docker, then clone this repository and run:

```sh
make build
```

The result is `build/ARFV-Notes_ddmmyy.pdf`, using the build date in the file
name (for example, `ARFV-Notes_041026.pdf` for 4 October 2026). The first run
builds a Docker image with the required tools; later runs reuse it. Downloaded
Typst packages are cached in `.cache/`. No Typst, Typstyle, Vale, Python, or
Rust installation is needed on the host. Other useful commands:

- `make watch`: rebuild the PDF after each save.
- `make format`: format the Typst sources.
- `make format-check`: check Typst formatting and the 80-character line limit.
- `make prose-check`: check English spelling and grammar in the README and Typst
  sources. The first run downloads the pinned Harper rules inside Docker.
- `make clean`: remove generated PDFs from `build/`.

For a tagged cover, run `RELEASE_TAG=v1.0.0 make build`. The output becomes
`build/ARFV-Notes_v1.0.0_ddmmyy.pdf`; the PDF displays `VERSION v1.0.0` on
the cover and the compilation date on the next page. `RELEASE_TAG` does not
create a Git tag or release. Without a tag, the cover shows `DRAFT` and the
build date.

## Find and edit content

- `main.typ` is the entry point: it includes files in reading order and places
  page breaks between parts and chapters.
- `frontmatter/` holds the cover, preface, notes, contents, and other opening
  pages; `chapters/` holds the chapters; `backmatter/` holds references.
- `styles/book.typ` defines the layout and reusable elements. `bibliography.bib`
  holds citation data; `images/` holds the cover photo and other local assets.

To add a chapter, create a `.typ` file in `chapters/` with a `==` heading and
`#chapter-opening()` (imported from `styles/book.typ`). Then add it at the
appropriate point in `main.typ`:

```typst
#blank-page-if-needed()
#chapter([#include "chapters/new-chapter.typ"])
```

The first call starts the chapter on a right-hand page; the second applies
chapter numbering. Common helpers in `styles/book.typ` include `#body_figure(...)` and
`#margin_figure(...)` for figures, the corresponding `*_diagram` and
`*_table` helpers, and `#short-title[Short title]` for the margin contents.
See their definitions or existing chapters for arguments and examples.

## Checks, previews, and releases

Before a pull request, run the same checks used in CI:

```sh
make format-check
make prose-check
make build
```

Vale skips Typst code and math. If a valid course term is marked as misspelled,
add it to `.github/vale/config/vocabularies/ARFV/accept.txt`.
The optional VS Code settings in `.vscode/` use Tinymist with `main.typ` as
the entry point.

Pull requests targeting `main` run the format and English checks and build the
PDF as `ARFV-Notes_ddmmyy.pdf`. Download the `document-preview` artifact from
the workflow run to inspect the result.
After the changes are merged, create a version tag on the latest `main` commit
and push it (replace `v1.0.0` with the new version):

```sh
git switch main
git pull --ff-only origin main
git tag v1.0.0
git push origin v1.0.0
```

Pushing the tag starts the release workflow. It checks formatting and English,
builds the PDF with the tag on its cover, and attaches
`ARFV-Notes_v1.0.0_ddmmyy.pdf` (with the actual tag and build date) to a GitHub
Release.

## Use local command-line tools instead

On Linux and macOS, you can run the tools directly if you prefer. Install
[Typst 0.15.1](https://github.com/typst/typst/releases/tag/v0.15.1),
[Typstyle 0.15.1](https://github.com/typstyle-rs/typstyle/releases/tag/v0.15.1),
[Vale 3.23.0](https://github.com/vale-cli/vale/releases/tag/v3.23.0),
Python 3, and the [Typst prose parser](https://github.com/jdkato/typst2vast)
(`cargo install typst2vast --version 0.1.0 --locked`). From the repository
root, run:

```sh
mkdir -p build
release_tag=
output="build/ARFV-Notes_${release_tag:+${release_tag}_}$(date +%d%m%y).pdf"
typst compile --input "release-tag=$release_tag" main.typ "$output"
typstyle --line-width 80 --wrap-text=fill --inplace $(find . -name '*.typ' -not -path './build/*' -not -path './.cache/*')
typstyle --line-width 80 --wrap-text=fill --check $(find . -name '*.typ' -not -path './build/*' -not -path './.cache/*')
python3 .github/scripts/check-line-width.py $(find . -name '*.typ' -not -path './build/*' -not -path './.cache/*')
vale sync
vale README.md $(find . -name '*.typ' -not -path './build/*' -not -path './.cache/*')
```

For live rebuilding, run this command on its own:

```sh
release_tag=
output="build/ARFV-Notes_${release_tag:+${release_tag}_}$(date +%d%m%y).pdf"
typst watch --input "release-tag=$release_tag" main.typ "$output"
```

Set `release_tag=v1.0.0` in either example to include the version in the PDF
name and on its cover.

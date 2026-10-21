# Contributing

Install Git, Make, and Docker, then follow the [build instructions](README.md#build-the-pdf-on-your-own).
Run commands from the repository root. Keep the notes in English.

## Find and edit content

- `src/main.typ` includes files in reading order and controls page breaks.
- `src/chapters/` holds chapter text; `src/frontmatter/` holds opening pages;
  `src/backmatter/` holds references and the index.
- `src/assets/styles/book.typ` defines the shared layout and reusable helpers.
- `src/assets/styles/graphics.typ` pins the shared drawing package versions.
- `src/examples/graphics.typ` demonstrates the drawing and panel helpers.
- `src/assets/images/` holds local images; `src/bibliography.bib` holds sources.

Edit the relevant chapter and use `make watch` to rebuild after each save.
Press `Ctrl+C` to stop and remove the watcher. ARFV and ML share the global
container name `typst-watch`, so only one watcher can run at a time. If it
already exists, run `make clean` in either repository to stop it before
starting another. Cleaning stops the shared watcher before deleting PDFs
from the current repository; if Docker is unavailable, it warns and still
cleans those PDFs.
The optional VS Code settings use Tinymist with `src/main.typ` as the entry
point. Compile that entry point, rather than individual chapters, to retain
styles, numbering, and references. Keep layout changes in `book.typ` and
content in the chapters; keep shared conventions aligned across ARFV and ML.

## Paragraphs, sections, chapters, and parts

Separate paragraphs with a blank line. A single source newline continues the
same paragraph. Use `*bold*`, `_emphasis_`, and backticks for inline code;
`-` starts a bullet and `+` starts a numbered list. For example:

```typst
A *formula* may contain an _unassigned_ variable called `x`.
This sentence continues the same paragraph.

This is a new paragraph.

- First case.
- Second case.
```

The heading hierarchy is fixed by the book style:

| Level | Syntax | Numbering / contents |
| --- | --- | --- |
| Part | `= Title`, via `part-page` | Roman numeral; main contents |
| Chapter | `== Title`, inside `chapter` | Continuous chapter number; main contents |
| Section | `=== Title` | Chapter.section; main and chapter margin contents |
| Subsection | `==== Title` | Unnumbered; omitted from both contents |

Create `src/chapters/new-chapter.typ` with this skeleton. Use a descriptive
filename, optionally with a numeric prefix to match neighboring chapters.

```typst
#import "../assets/styles/book.typ": chapter-opening, short-title

== New chapter <chap-new>

#chapter-opening()

=== A section with a long descriptive title <sec-example>
#short-title[Short section title]

The section text starts here.

==== A subsection

More text.
```

`short-title` is optional: it changes only the chapter's margin contents.
Place it immediately after the section heading. `chapter-opening` must follow
the chapter heading and precede its sections; it can also take
`quote: [Opening quotation]` and `author: [Author]`.

Register the chapter at the intended position in `src/main.typ`:

```typst
#blank-page()
#chapter([#include "chapters/new-chapter.typ"])
```

`blank-page()` always inserts exactly one page containing only the footer
"intentionally left blank". It finishes the preceding page and starts the next
content on a fresh page, regardless of odd/even page numbers. No additional
`pagebreak()` is needed around it. Consecutive calls insert consecutive blank
pages. The blank page counts toward pagination but does not display its number.

Keep these layout decisions in `src/main.typ`. Use `#pagebreak()` when you only
want to start a new page without inserting a blank separator. Parts and chapters
do not automatically start on odd pages; add or remove `#blank-page()` explicitly
at each boundary where a blank page is wanted.

The chapter wrapper advances the chapter counter and resets equation, figure,
table, and algorithm counters. A filename prefix does not determine numbering;
include order does.

To introduce a part, import `part-page` from `assets/styles/book.typ` in
`src/main.typ` if it is not already imported, then insert this before its
first chapter:

```typst
#blank-page()
#part-page("New part")
```

For a part that needs a reference, use this equivalent of `part-page` instead,
so the label attaches directly to the heading:

```typst
#blank-page()
#v(6cm)
= New part <part-new>
```

A label appended to `part-page(...)` labels its output sequence and cannot
be referenced. Parts do not reset chapter numbering. Use the chapter wrapper
for chapters and let the style generate all numbers.

For an opening page, add a file in
`src/frontmatter/`, include it in `src/main.typ`, and follow the page helpers
and page breaks used by neighboring opening pages.

## Equations and cross-references

Use `$...$` for inline math and `$ ... $` (with spaces inside both delimiters)
for a displayed equation. Displays are unnumbered by default. Add a label
immediately after a display to number it by chapter, even before it is
referenced. Only labeled displays advance the equation counter:

```typst
For inline math, write $a^2 + b^2 = c^2$ within the sentence.

$ a^2 + b^2 = c^2 $ <eq-pythagoras>

$ x + 0 = x $

By @eq-pythagoras, the squared lengths satisfy the stated relation.
```

Attach a unique label immediately after the target and refer to it with
`@label`; Typst supplies its number and a link. Use descriptive prefixes such
as `part-`, `chap-`, `sec-`, `eq-`, `fig-`, `tab-`, and `alg-`. Labels and
bibliography keys share the `@...` reference syntax, so keep them distinct.

```typst
See @part-new, @chap-new, and @sec-example.
See @fig-photo and @tab-values for the supporting material.
```

For custom link text, use `#link(<sec-example>)[the earlier discussion]`.
Use labels on numbered levels for numeric heading references: subsections
are unnumbered in this style. Never type object numbers into the prose or
reset counters manually.

## Images, diagrams, and tables

Import the helpers needed by each chapter:

```typst
#import "../assets/styles/book.typ": (
  body_figure, margin_figure, body_diagram, margin_diagram,
  body_table, margin_table,
)
```

Use `body_*` for the text column and `margin_*` for the right margin. All
figures share chapter-based figure numbering; tables have their own sequence.
Provide a caption, describe the element in the text, and place its source
near the relevant paragraph. Check the PDF for crowded margins, collisions
with chapter contents, and diagrams or tables that exceed the available width.

### Image files

Store images in `src/assets/images/`; use SVG for vector artwork and PNG or
JPEG for raster images. These examples use the existing cover photograph;
replace it with the relevant asset:

```typst
#body_figure(
  "../images/broadperspective.jpg",
  [An example photograph.],
  width: 70%,
) <fig-photo>

#margin_figure(
  "../images/broadperspective.jpg",
  caption: [A photograph in the margin.],
  id: <fig-margin-photo>,
)
```

The image helpers resolve paths inside `src/assets/styles/book.typ`, so use
`../images/filename.svg`. A direct `image(...)` call in a chapter instead uses
`../assets/images/filename.svg`. Body helpers take an appended label;
margin helpers need `id: <label>` to label the figure inside the margin note.
`margin_figure` fills the margin width; `body_figure` accepts `width`.

### Geometry, plots, and connected nodes

Import the native package interfaces through `src/assets/styles/graphics.typ`.
That module pins the same versions in ARFV and ML; update both copies together.
Use a package's layout and drawing primitives rather than calculating arrowheads,
placing every label with `place`, or drawing chart axes by hand.

| Content | Package / exported API |
| --- | --- |
| Geometric constructions, projections, vectors | [CeTZ](https://typst.app/universe/package/cetz/): `cetz` |
| Function plots, scatter plots, charts | [CeTZ-Plot](https://typst.app/universe/package/cetz-plot/): `plot`, `chart` inside a CeTZ canvas |
| Connected nodes, flowcharts, commutative diagrams | [Fletcher](https://typst.app/universe/package/fletcher/): `fletcher` |
| State machines | [Finite](https://typst.app/universe/package/finite/): `finite` |
| Trees and data structures | [typed-dsa](https://typst.app/universe/package/typed-dsa/): `bst`, `graph` |
| Groups of panels | [Subpar](https://typst.app/universe/package/subpar/), through the book helpers below |

Keep reusable drawings in `src/assets/images/*.typ` and export their content
with `#let`. Import that content into a chapter and pass it to `body_diagram`
or `margin_diagram`. The drawing itself does not need to know its placement,
caption, label, or figure number.

For geometry, use Cartesian coordinates and native arrow marks:

```typst
#import "../assets/styles/graphics.typ": cetz, plot, fletcher

#let vector = cetz.canvas({
  import cetz.draw: *
  line((0, 0), (2, 1), mark: (end: ">"))
  content((2, 1.3), $bold(w)$)
})
```

CeTZ-Plot handles sampling, axes, ticks, and legends. Data points can replace
the function; use `mark: "o"` and `style: (stroke: none)` for a scatter plot.

```typst
#let curve = cetz.canvas({
  plot.plot(size: (3, 2), x-tick-step: 1, y-tick-step: 0.5, {
    plot.add(domain: (-1, 1), x => x * x)
  })
})
```

Fletcher connects nodes and places arrow labels without arrowhead geometry:

```typst
#let flow = fletcher.diagram(
  fletcher.node((0, 0), [Input]),
  fletcher.node((1, 0), [Process]),
  fletcher.edge((0, 0), (1, 0), "->"),
)
```

### Figures with multiple panels

Use `body_subfigures` or `margin_subfigures` from `book.typ`. These helpers
use Subpar to generate panel letters and references. Supply a `figure(...)`
for each panel, followed by its label. Give generated drawings `kind: image`
and alternative text. Do not wrap a group in another diagram/figure helper.

```typst
#import "../assets/styles/book.typ": body_subfigures, margin_subfigures

#body_subfigures(
  figure(vector, kind: image, caption: [A vector.],
    alt: "An arrow from the origin to the point two, one"), <fig-vector>,
  figure(curve, kind: image, caption: [A quadratic function.],
    alt: "Plot of x squared"), <fig-curve>,
  caption: [Two mathematical illustrations.],
  alt: "A vector beside a quadratic plot",
  id: <fig-pair>,
)

See @fig-pair, @fig-vector, and @fig-curve.
```

The body helper defaults to two columns; set `columns: (1fr,)` to stack them.
The margin helper stacks panels in one column and accepts the same panel,
caption, alternative text, and ID arguments. A group advances the figure
counter once. Its panels use letters, with references such as `Fig. 1.2a`.
The parent and panel numbers remain correct when cited from another chapter.
Use `id: <label>` for the group instead of appending a label to the helper.

See [the standalone examples](src/examples/graphics.typ) for complete body
and margin groups, cross-chapter references, and labeled equations. Compile
them from the repository root with `make examples`; the result is
`build/graphics-examples.pdf`.

With a local Typst 0.15.1 installation, run
`typst compile --root src src/examples/graphics.typ build/graphics-examples.pdf`
after creating `build/`. The examples are separate from the lecture notes
and do not add pages to them.

### Automaton, graph, and tree diagrams

Use generated Typst content with `body_diagram` or `margin_diagram`. Supply
alternative text describing the diagram. Import packages through `graphics.typ`
so that chapters share the pinned versions. The first compilation may download
packages.

An automaton uses a dictionary from each state to its outgoing transitions.
Here the two states track the parity of the number of `1`s:

```typst
#import "../assets/styles/graphics.typ": finite

#let parity = finite.create-automaton(
  (
    even: (even: "0", odd: "1"),
    odd: (odd: "0", even: "1"),
  ),
  initial: "even",
  final: ("even",),
  labels: (even: $E$, odd: $O$),
)

#margin_diagram(
  finite.automaton(parity, style: (state: (radius: 0.4))),
  caption: [A DFA accepting an even number of ones.],
  alt: "Two states E and O; input 1 switches states and 0 loops",
  id: <fig-parity>,
)
```

For trees and graphs, `typed-dsa` exposes generated content as `.diagram`:

```typst
#import "../assets/styles/graphics.typ": bst, graph

#body_diagram(
  bst(8, 4, 12, 2, 6, 10, 14).diagram,
  [A binary search tree.],
  "Root 8, children 4 and 12, and leaves 2, 6, 10, and 14",
) <fig-tree>

#body_diagram(
  graph(
    ("S": ("A", "B"), "A": ("T",), "B": ("T",), "T": ()),
    layout: "layered",
  ).diagram,
  [Two directed paths from S to T.],
  "Edges S to A, S to B, A to T, and B to T",
) <fig-graph>
```

Each graph key names a vertex; its tuple lists outgoing neighbors. Use `()`
for no neighbors and `(value,)` for a single neighbor. To move any generated
diagram between placements, pass the same content to the other diagram
helper: body captions and alternative text are positional arguments; margin
captions, alternative text, and IDs are named arguments.

### Tables

Build the cells with `table(...)`, then wrap them to obtain a caption,
number, and reference. Both placements accept the same table content:

```typst
#let values = table(
  columns: (auto, auto),
  inset: 4pt,
  table.header([*Input*], [*Output*]),
  [0], [1],
  [1], [0],
)

#body_table(values, [Input and output values.]) <tab-values>

#margin_table(
  values,
  [The same values in the margin.],
  id: <tab-margin-values>,
)
```

Use `table.header` for headers. Keep margin tables narrow; move wider tables
into the body. Table captions appear above the table.

## Index entries and bibliography

### Index terms

Import `index` in each chapter that needs it. Mark only the first occurrence
of a term, next to its explanation. The marker adds an entry and page number;
it does not print the term in the body:

```typst
#import "@preview/in-dexter:0.7.2": index

An automaton#index("Automaton") has states and transitions.
A binary search tree#index("Binary search tree") orders its keys.
Unit propagation#index("SAT", "Unit propagation") simplifies a formula.
```

Use separate arguments for a parent term and subentry. Keep spelling and
capitalization consistent; use additional markers only when another page
adds a useful discussion of the same term.

ARFV already includes the index from `src/main.typ`.

The index layout is in `src/backmatter/index.typ`. Its manual column break
currently occurs at `N`; review the balance when the term list grows.

### Sources and citations

Add a BibTeX entry with a unique, descriptive key to `src/bibliography.bib`.
For example:

```bibtex
@book{knuth-taocp-1,
  author = {Donald E. Knuth},
  title = {The Art of Computer Programming, Volume 1},
  publisher = {Addison-Wesley},
  year = {1997},
  edition = {3}
}
```

Cite its key in the chapter, optionally adding a page locator:

```typst
See @knuth-taocp-1 for background.
#cite(<knuth-taocp-1>, supplement: [p. 10])
```

For online sources, include `url` and `urldate` (the access date); follow an
existing entry in the bibliography. Cite the source of borrowed explanations,
figures, and tables, including in captions when appropriate.
`src/backmatter/references.typ` renders cited entries automatically. An
entry without a citation is not listed by default; use
`#cite(<knuth-taocp-1>, form: "none")` to include it without a visible citation.

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

After a successful build, inspect the PDF in `build/`: check page breaks,
contents, captions, references, index entries, and margin placement. A build
can succeed even when an element is too wide or poorly placed.

Pull requests targeting `main` run formatting, English prose, and PDF build as separate CI jobs, so each check has its own status. CI caches the Docker build layers between runs; a run on `main` after each merge refreshes the shared cache. Each job loads the image before invoking Make, which skips rebuilding it. The build job produces `ARFV-Notes_ddmmyy.pdf`; download the `document-preview` artifact from the workflow run to inspect the result.

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

#import "../styles/book.typ": chapter-opening

== Keep Writing

#chapter-opening(
  quote: [Each chapter adds a question and an answer.],
  author: [Sample text],
)

=== Replace the examples

Replace the chapter text, update `bibliography.bib`, and add images under
`images/`. A margin figure is optional: add `#margin_figure(...)` where it
belongs, or leave it out. You can also reference material in other chapters,
such as @fig-layout and @eq-sum.

=== Add a chapter

Create a file under `chapters/` with a `==` chapter heading, a
`#chapter-opening()` call, and `===` section headings. Then add
`#chapter-start()` and `#include "chapters/new-chapter.typ"` to `main.typ` at
the desired position. Numbers update automatically.

=== Add a section

Add another `===` heading and write its paragraphs directly below it. Sections
are numbered automatically and appear in the main contents. You can also give a
section a label and refer to it elsewhere in the book. This longer sample
paragraph gives the page enough text to demonstrate line wrapping, first-line
indentation, and spacing below a section heading.

#lorem(400)

#lorem(200)

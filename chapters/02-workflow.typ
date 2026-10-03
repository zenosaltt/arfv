#import "../styles/book.typ": (
  algorithm, body_diagram, body_figure, body_table, chapter-opening,
  margin_diagram, margin_figure, margin_table,
)
#import "../diagrams.typ": binary-tree, two-state-dfa

== From Source to PDF

#chapter-opening()

=== Local builds <sec-local-build>

`make build` creates `build/document.pdf`; `make watch` recompiles after
changes. `make docker-build` uses the same Typst container as GitHub Actions.

Here is one sample equation:

$ sum_(k=1)^n k = (n(n+1)) / 2 $ <eq-sum>

A second displayed expression receives the next number:

$ a_(n+1) = a_n + 1 $ <eq-sequence>

A longer paragraph makes the effect of equation spacing easier to judge. The
explanation above each expression should have room to end before the equation
begins, and the next paragraph should start after a clear pause. This sample
text also shows how the narrower main column handles several sentences in
succession. The same rules apply when a chapter contains more substantial
reasoning, multiple equations, or references to material introduced earlier.

#margin_figure(
  "../images/workflow.svg",
  caption: [From source to document. The diagram summarizes the path from a
    Typst file through the build command to the finished PDF. This deliberately
    long caption tests the width of the outer margin and shows how several lines
    of explanatory text can sit beside the main argument. The caption remains
    justified, while its final line returns to the left edge.],
  id: <fig-workflow>,
)

=== Publishing versions

A push to `main` or a pull request produces a temporary artifact. A tag such as
`v1.0.0` creates a GitHub Release with the PDF attached and the tag printed on
its cover. The PDF stays out of Git history.

#body_figure("../images/book-layout.svg", [A page with a central text area and
  an outer margin. Wide illustrations belong in the main column when their
  details would become too small in the margin. The figure leaves room for a
  caption that explains what to notice: the reading area stays compact, while
  the outside edge can hold optional images or notes. This longer example also
  makes the gap before the following paragraph visible.]) <fig-layout>

This paragraph demonstrates cross-references: @sec-local-build describes the
build; @fig-workflow shows the path to the PDF, while @fig-layout shows a figure
in the main text. @eq-sum and @eq-sequence demonstrate equation numbering within
a chapter.

#pagebreak()
=== Pseudocode and C source

The sum in @eq-sum can also be written as @alg-sum. Its numbered lines show the
procedure and loop structure. With $n = 5$, it returns 15.

#algorithm(
  [Sum of the first $n$ positive integers],
  (
    (indent: 0, body: [*Procedure* SUM($n$)]),
    (indent: 1, body: [$s arrow.l 0$]),
    (indent: 1, body: [*for* $k arrow.l 1$ *to* $n$ *do*]),
    (indent: 2, body: [$s arrow.l s + k$]),
    (indent: 1, body: [*end for*]),
    (indent: 1, body: [*return* $s$]),
    (indent: 0, body: [*End Procedure*]),
  ),
) <alg-sum>

The same calculation can be written in C. This program fixes $n = 5$ and prints
the returned value.

==== C code
Here is a code snippet written in C.

```

#include <stdio.h>

int main(void) {
    int sum = 0;
    for (int k = 1; k <= 5; ++k) {
        sum += k;
    }
    printf("%d\n", sum);
    return 0;
}


```

#lorem(50)

=== Tables in the text and margin

@tab-partial-sums lists the running totals calculated by @alg-sum for $n = 5$.

#body_table(
  table(
    columns: 3,
    align: center,
    table.header([Step $k$], [Added value], [Running total]),
    [1], [1], [1],
    [2], [2], [3],
    [3], [3], [6],
    [4], [4], [10],
    [5], [5], [15],
  ),
  [Partial sums for $n = 5$],
) <tab-partial-sums>

Smaller tables can use the outer margin. @tab-sum-values shows the final result
for three inputs without interrupting the main column.

#margin_table(
  table(
    columns: 2,
    align: center,
    table.header([$n$], [Sum]),
    [1], [1],
    [3], [6],
    [5], [15],
  ),
  [Sample outputs of @alg-sum],
  id: <tab-sum-values>,
)

#pagebreak()
=== Trees and state machines

@fig-binary-tree shows a small binary search tree. Each node in a left branch
has a smaller value than its parent, while each node in a right branch has a
larger value.

#margin_diagram(
  binary-tree(),
  caption: [A binary search tree with seven nodes.],
  alt: "Binary search tree with root 8 and seven numbered nodes",
  id: <fig-binary-tree>,
)

@fig-binary-dfa shows a deterministic finite automaton for strings over the
symbols $alpha$ and $beta$ that end in $beta$. The arrow entering $q_0$ marks
the initial state; the double circle marks $q_1$ as accepting. Every state has
one outgoing transition for $alpha$ and one for $beta$.

#body_diagram(
  two-state-dfa(),
  [A two-state automaton accepting exactly the strings that end in $beta$.],
  "Two-state deterministic automaton over alpha and beta; q1 is accepting",
) <fig-binary-dfa>

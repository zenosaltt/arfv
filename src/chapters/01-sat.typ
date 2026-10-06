#import "../assets/styles/book.typ": (
  body_diagram, chapter-opening, margin_diagram, short-title,
)
#import "@preview/finite:0.5.1" as finite
#import "@preview/algorithmic:1.0.7" as algorithmic
#import algorithmic: algorithm-figure
#import "@preview/typed-dsa:0.6.0": bst, graph
#import "@preview/in-dexter:0.7.2": index

== Propositional Satisfiability (SAT)
#index("Propositional satisfiability")
#index("SAT")
#chapter-opening(
  quote: [This chapter deserves a quote.],
  author: [Me.],
)

=== Boolean logics and SAT
#index("Boolean logics")

=== Basic SAT-solving techniques
#index("SAT", "solving techniques")
==== Generalities
==== Resolution
#index("Resolution")
==== Tableaux
#index("Tableaux")
==== DPLL
#index("DPLL")
=== Ordered binary decision diagrams (OBDDs)
#index("Ordered binary decision diagrams (OBDDs)")
#short-title[Ordered binary decision diagrams]
=== Modern CDCL SAT solvers
#index("CDCL SAT solvers")
=== SAT functionalities: proofs, unsat scores, optimization
#index("SAT", "functionalities")
#short-title[SAT functionalities]












=== Useful Examples

The recursive outline in @alg-dpll checks for a satisfied formula or a conflict,
propagates unit clauses, and then branches on a variable.

#algorithm-figure(
  [A basic DPLL procedure.],
  {
    import algorithmic: *
    Function("DPLL", ("F",), {
      If($F = emptyset$, { Return[true] })
      If($emptyset in F$, { Return[false] })
      If([a unit literal $l$ occurs in $F$], {
        Return[$"DPLL"(F |_(l = 1))$]
      })
      Line[Choose a variable $x$ occurring in $F$.]
      Return[$"DPLL"(F |_(x = 1)) or "DPLL"(F |_(x = 0))$]
    })
  },
) <alg-dpll>

Here $F |_(l = 1)$ denotes the formula simplified after setting $l$ to true.

#let automaton-style = (state: (radius: 0.4))

An automaton#index("Automaton") can be described by its transition table. In
this deterministic example, the two states record whether the number of $1$s
read so far is even or odd. The initial and accepting state is `even`
(@fig-parity-dfa).

#let parity-dfa = finite.create-automaton(
  (
    even: (even: "0", odd: "1"),
    odd: (odd: "0", even: "1"),
  ),
  initial: "even",
  final: ("even",),
  labels: (
    even: $E$,
    odd: $O$,
  ),
)

#margin_diagram(
  finite.automaton(parity-dfa, style: automaton-style),
  caption: [A DFA for words with an even number of $1$s.],
  alt: "Two-state deterministic automaton for the parity of 1s",
  id: <fig-parity-dfa>,
)

The same notation also permits several transitions with the same input. This
nondeterministic automaton recognizes words ending in `ab`: from `start`, it may
stay put or guess that the current `a` begins the final suffix
(@fig-suffix-nfa).

#let suffix-nfa = finite.create-automaton(
  (
    start: (start: ("a", "b"), seen-a: "a"),
    seen-a: (accept: "b"),
    accept: (),
  ),
  initial: "start",
  final: ("accept",),
)

#margin_diagram(
  finite.automaton(suffix-nfa, style: automaton-style),
  caption: [An NFA for words ending in `ab`.],
  alt: "Three-state nondeterministic automaton with a branch on a",
  id: <fig-suffix-nfa>,
)

=== Trees and graphs with typed-dsa

A binary search tree#index("Binary search tree") follows from the order in which
keys are inserted. The root is $8$; smaller keys go to its left subtree and
larger keys to its right (@fig-bst).

#body_diagram(
  bst(8, 4, 12, 2, 6, 10, 14).diagram,
  [A binary search tree built by inserting seven keys.],
  "Binary search tree with root 8 and seven nodes",
) <fig-bst>

A graph instead uses an adjacency dictionary: each key names a vertex and its
value lists the outgoing neighbors. Here the edges describe two routes from `S`
to `T` through `A` and `B` (@fig-dag).

#body_diagram(
  graph(
    ("S": ("A", "B"), "A": ("T",), "B": ("T",), "T": ()),
    layout: "layered",
  ).diagram,
  [A directed graph with two routes from `S` to `T`.],
  "Directed diamond graph with vertices S, A, B, and T",
) <fig-dag>

#let entry(term, target, indent: false) = [
  #if indent { h(1.2em) }
  #term, #link(target)[#context counter(page).at(target).first()]
  #linebreak()
]

#let group(title, target, children) = [
  #entry(title, target)
  #for child in children {
    entry(child.at(0), child.at(1), indent: true)
  }
]

#let letter(initial) = [#strong(initial) #linebreak()]

#set page(margin: (left: 2.4cm, right: 2.4cm, top: 2.5cm, bottom: 2.5cm))
#set par(
  first-line-indent: 0pt,
  justify: false,
  leading: 1.1em,
)
#heading(level: 1, numbering: none)[Index]
// To add a term, label its first occurrence in a chapter (for prose, use
// #metadata("glossary-term") <glossary-term>), then add an #entry below with
// that label under its initial. Use #group for terms sharing a root; label each
// subterm too.
#columns(2, gutter: 1cm)[
  #set text(size: 9pt)
  #letter([A])
  #entry([Automaton], <glossary-automaton>)
  #letter([B])
  #entry([Binary search tree], <glossary-binary-search-tree>)
  #entry([Boolean logics], <glossary-boolean-logics>)
  #letter([C])
  #entry([CDCL SAT solvers], <glossary-cdcl>)
  #group([CTL model checking], <glossary-ctl-model-checking>, (
    ([with fair Kripke models], <glossary-fair-kripke>),
  ))
  #letter([D])
  #entry([DPLL], <glossary-dpll>)
  #letter([I])
  #entry([Invariant checking], <glossary-invariant-checking>)
  #colbreak()
  #letter([N])
  #entry([newterm], <glossary-newterm>)
  #letter([O])
  #entry([Ordered binary decision diagrams (OBDDs)], <glossary-obdd>)
  #letter([P])
  #entry([Propositional satisfiability], <glossary-sat>)
  #letter([R])
  #entry([Resolution], <glossary-resolution>)
  #letter([S])
  #group([SAT], <glossary-sat>, (
    ([functionalities], <glossary-sat-functionalities>),
    ([solving techniques], <glossary-sat-solving>),
  ))
  #entry([Satisfiability Modulo Theories (SMT)], <glossary-smt>)
  #letter([T])
  #entry([Tableaux], <glossary-tableaux>)
]

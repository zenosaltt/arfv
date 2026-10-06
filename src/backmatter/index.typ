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

#set page(margin: (left: 2.4cm, right: 2.4cm, top: 2.5cm, bottom: 2.5cm))
#set par(
  first-line-indent: 0pt,
  justify: false,
  leading: 1.1em,
)
#heading(level: 1, numbering: none)[Index]
// To add a term, label its first occurrence in a chapter (for prose, use
// #metadata("glossary-term") <glossary-term>), then add an #entry below with
// that label. Use #group for terms sharing a root; label each subterm too.
#columns(2, gutter: 1cm)[
  #set text(size: 9pt)
  #entry([Automaton], <glossary-automaton>)
  #entry([Binary search tree], <glossary-binary-search-tree>)
  #entry([Boolean logics], <glossary-boolean-logics>)
  #entry([CDCL SAT solvers], <glossary-cdcl>)
  #group([CTL model checking], <glossary-ctl-model-checking>, (
    ([with fair Kripke models], <glossary-fair-kripke>),
  ))
  #entry([DPLL], <glossary-dpll>)
  #colbreak()
  #entry([Invariant checking], <glossary-invariant-checking>)
  #entry([newterm], <glossary-newterm>)
  #entry([Ordered binary decision diagrams (OBDDs)], <glossary-obdd>)
  #entry([Propositional satisfiability], <glossary-sat>)
  #entry([Resolution], <glossary-resolution>)
  #group([SAT], <glossary-sat>, (
    ([functionalities], <glossary-sat-functionalities>),
    ([solving techniques], <glossary-sat-solving>),
  ))
  #entry([Satisfiability Modulo Theories (SMT)], <glossary-smt>)
  #entry([Tableaux], <glossary-tableaux>)
]

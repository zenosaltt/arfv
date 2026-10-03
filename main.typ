#import "styles/book.typ": *

#let release-tag = sys.inputs.at("release-tag", default: "")

#set document(
  title: "Automated Reasoning and Formal Verification",
  author: "Zeno Saletti",
)
#show: document-style

#cover-page(
  [
    Automated Reasoning \
    and Formal Verification
  ],
  "Zeno Saletti",
  release-tag: release-tag,
)

#build-page()

#front-page("Preface", [
  #epigraph(
    [Lorem ipsum dolor sit amet, consectetur adipiscing elit.],
    [Someone],
  )
])

#front-page("Notes", [
  #lorem(200)
])

#contents-page()

#part-page("Automated Reasoning")
#chapter-start()
#include "chapters/01-sat.typ"
#chapter-start()
#include "chapters/02.typ"

#part-page("Formal Verification")
#chapter-start()
#include "chapters/05-explicit_state_ctl_model_checking.typ"

#pagebreak()
#heading(level: 1, numbering: none)[References]
#bibliography("bibliography.bib", title: none)

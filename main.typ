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

#front-page("An Opening Thought", [
  #epigraph(
    [A well-structured document helps readers find their way before explaining
      the path.],
    [Sample text],
  )
])

#front-page("Notes", [
  The text, quotations, and figures in this book are examples. Replace them with
  your own material and verify all sources before publication.
])

#contents-page()

#part-page("Foundations")
#chapter-start()
#include "chapters/01-principles.typ"
#chapter-start()
#include "chapters/02-workflow.typ"

#part-page("Next Steps")
#chapter-start()
#include "chapters/03-next-steps.typ"

#pagebreak()
#heading(level: 1, numbering: none)[References]
#bibliography("bibliography.bib", title: none)

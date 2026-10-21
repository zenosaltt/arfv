#import "assets/styles/book.typ": blank-page, chapter, document-style, part-page

#set document(
  title: "Automated Reasoning and Formal Verification",
  author: "Zeno Saletti",
)
#show: document-style

// Front matter: each include names one component. Cover and build are
// self-contained pages; the other boundaries are explicit below.
#include "frontmatter/cover.typ"
#include "frontmatter/build.typ"
#pagebreak()
#include "frontmatter/disclaimers.typ"
#pagebreak()
#include "frontmatter/preface.typ"
#pagebreak()
#include "frontmatter/acknowledgments.typ"
#pagebreak()
#include "frontmatter/notes.typ"
#pagebreak()
#include "frontmatter/contents.typ"

// Explicit blank separators: each call inserts exactly one blank page.
// Use pagebreak() instead wherever only a new page is wanted.
#blank-page()
#part-page("Automated Reasoning")

#blank-page()
#chapter([#include "chapters/01-sat.typ"])
#blank-page()
#chapter([#include "chapters/02-smt.typ"])
#blank-page()
#part-page("Formal Verification")
#blank-page()
#chapter([#include "chapters/05-explicit_state_ctl_model_checking.typ"])

// Back matter follows the last chapter on a new page.
#pagebreak()
#include "backmatter/references.typ"
#pagebreak()
#include "backmatter/index.typ"

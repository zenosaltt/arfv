#import "styles/book.typ": (
  blank-page-if-needed, chapter, document-style, part-page,
)

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

// A part or chapter begins on a right-hand page. The break inserts a blank
// left-hand page only when the preceding content ends on a right-hand page.
#blank-page-if-needed()
#part-page("Automated Reasoning")

#blank-page-if-needed()
#chapter([#include "chapters/01-sat.typ"])
#blank-page-if-needed()
#chapter([#include "chapters/02-smt.typ"])
#blank-page-if-needed()
#part-page("Formal Verification")
#blank-page-if-needed()
#chapter([#include "chapters/05-explicit_state_ctl_model_checking.typ"])

// Back matter follows the last chapter on a new page.
#pagebreak()
#include "backmatter/references.typ"

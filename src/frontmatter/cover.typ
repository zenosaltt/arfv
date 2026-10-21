#import "../assets/styles/book.typ": cover-page

#cover-page(
  [
    Automated Reasoning \
    and Formal Verification
  ],
  "Zeno Saletti",
  cover-image: path("../assets/images/broadperspective.jpg"),
  release-tag: sys.inputs.at("release-tag", default: ""),
)

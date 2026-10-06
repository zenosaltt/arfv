#import "@preview/in-dexter:0.7.2": make-index

#set page(margin: (left: 2.4cm, right: 2.4cm, top: 2.5cm, bottom: 2.5cm))
#heading(level: 1, numbering: none)[Index]

// Mark only the first occurrence: #index("Term") or
// #index("Root", "subterm") for a nested entry.
#columns(2, gutter: 1cm)[
  #set text(size: 9pt)
  #set par(first-line-indent: 0pt, justify: false, leading: 1.1em, spacing: 1em)
  #make-index(
    title: none,
    entry-casing: key => key,
    surround: body => body,
    section-title: (letter, _) => [
      // Typst does not balance short columns automatically.
      #if letter == "N" { colbreak() }
      #strong(letter)
      #parbreak()
    ],
  )
]

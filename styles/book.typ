#import "@preview/marginalia:0.3.1" as marginalia

// Shared palette, margin width, and counters for chapter-scoped numbering.
#let ink = rgb("25344a")
// Accent color for book details.
#let accent = rgb("#3e84d4")
#let margin-width = 5.85cm
#let chapter-counter = counter("chapter")
#let image-counter = counter(figure.where(kind: image))
#let table-counter = counter(figure.where(kind: table))
#let algorithm-counter = counter(figure.where(kind: "algorithm"))

#let figure-numbering(number) = numbering(
  "1.1",
  chapter-counter.at(here()).first(),
  number,
)
#let equation-numbering(number) = numbering(
  "(1.1)",
  chapter-counter.at(here()).first(),
  number,
)

// Parts are the top level, but are excluded from chapter numbers.
#let book-numbering(..numbers) = {
  let values = numbers.pos()
  if values.len() == 1 {
    numbering("I", values.at(0))
  } else if values.len() == 2 {
    chapter-counter.display("1")
  } else if values.len() == 3 {
    [#chapter-counter.display("1").#numbering("1", values.at(2))]
  } else {
    []
  }
}

// Apply page geometry, typography, numbering, captions, and heading styles.
// Wrap the whole document with `#show: document-style` in main.typ.
#let document-style(body) = {
  import "@preview/algorithmic:1.0.7": style-algorithm
  set page(
    paper: "a4",
    margin: (left: 2.4cm, right: 7cm, top: 2.5cm, bottom: 2.5cm),
    numbering: "1",
    number-align: center,
    footer: context {
      let starts = query(metadata.where(value: "recto-before"))
      let ends = query(metadata.where(value: "recto-after"))
      let current = counter(page).get().first()
      let intentional = range(starts.len()).any(i => (
        current > starts.at(i).location().page()
          and current < ends.at(i).location().page()
      ))
      if intentional {
        align(center)[#text(
          size: 6.5pt,
          style: "italic",
          fill: gray,
        )[intentionally left blank]]
      } else {
        align(center)[#counter(page).display("1")]
      }
    },
  )
  set text(font: "New Computer Modern", size: 8pt, lang: "en", fill: ink)
  set par(
    justify: true,
    leading: 0.68em,
    spacing: 0.65em,
    first-line-indent: (amount: 1.3em, all: true),
  )
  set heading(numbering: book-numbering)
  // Reserve the wide outer margin for notes and marginal figures.
  show: marginalia.setup.with(
    inner: (far: 2.4cm, width: 0cm, sep: 0cm),
    outer: (far: 0.55cm, width: margin-width, sep: 0.6cm),
    top: 2.5cm,
    bottom: 2.5cm,
    book: false,
    clearance: 0.5cm,
  )
  show: style-algorithm
  // One paragraph line of breathing room around every numbered object.
  show figure: set block(above: 0.5cm, below: 0.5cm)
  show figure.where(kind: image): set figure(
    numbering: figure-numbering,
    supplement: [Fig.],
  )
  show figure.where(kind: table): set figure(
    numbering: figure-numbering,
    supplement: [Table],
  )
  show figure.where(kind: table): set figure.caption(position: top)
  show figure.where(kind: "algorithm"): set figure(
    numbering: figure-numbering,
  )
  set math.equation(numbering: equation-numbering)
  show math.equation.where(block: true): set block(above: 0.5cm, below: 0.5cm)
  show figure.caption.where(kind: image): it => {
    set text(size: 7.25pt, fill: black)
    set par(justify: true, first-line-indent: 0pt)
    align(left)[#strong([Fig. #context it.counter.display(it.numbering)]):
      #it.body]
  }
  show figure.caption.where(kind: table): it => {
    set text(size: 7.25pt, fill: black)
    set par(justify: false, first-line-indent: 0pt)
    align(center)[#strong([Table #context it.counter.display(it.numbering)]):
      #it.body]
  }
  show heading.where(level: 1): it => {
    if it.numbering == none {
      block(above: 0pt, below: 1cm)[
        #set par(justify: false, first-line-indent: 0pt)
        #align(left)[#text(size: 19.5pt, weight: "bold")[#it.body]]
      ]
    } else {
      block(above: 0pt, below: 1cm)[
        #set par(justify: false, first-line-indent: 0pt)
        #align(left)[
          #text(
            size: 8.5pt,
            weight: "bold",
            fill: accent,
          )[PART #counter(heading).display("I")]
          #v(0.5cm)
          #text(size: 24pt, weight: "bold", fill: ink)[#it.body]
        ]
      ]
    }
  }
  show heading.where(level: 2): it => block(above: 0pt, below: 0.45cm)[
    #set par(justify: false, first-line-indent: 0pt)
    #align(left)[
      #text(size: 9pt, weight: "bold", fill: accent)[CHAPTER
        #chapter-counter.display("1")]
      #v(0.35cm)
      #text(size: 16pt, weight: "bold", style: "italic")[#it.body]
    ]
    #v(0.12cm)
    #line(length: 100%, stroke: (paint: accent, thickness: 1.3pt))
  ]
  show heading.where(level: 3): it => block(above: 0.7cm, below: 0.25cm)[
    #set par(justify: false, first-line-indent: 0pt)
    #align(left)[#text(size: 10.5pt, weight: "bold")[#counter(heading).display()
      #it.body]]
  ]
  body
}

// Standalone photographic cover with a translucent text panel.
#let cover-page(title, author, release-tag: "") = page(
  paper: "a4",
  margin: 0pt,
  header: none,
  footer: none,
  numbering: none,
)[
  #place(top + left)[
    #image(
      "../images/broadperspective.jpg",
      width: 210mm,
      height: 297mm,
      fit: "cover",
    )
  ]
  #place(bottom + left, dx: 12mm, dy: -18mm)[
    #rect(
      width: 186mm,
      height: 79mm,
      fill: rgb(17, 17, 17, 78%),
      radius: 2mm,
      inset: (left: 11mm, right: 11mm, top: 9mm, bottom: 9mm),
    )[
      #set par(justify: false, first-line-indent: 0pt)
      #text(size: 12pt, weight: "bold", fill: white)[#author]
      #v(5mm)
      #text(size: 24pt, weight: "bold", fill: white)[#title]
      #v(6mm)
      #text(size: 10pt, fill: white)[
        #if release-tag != "" {
          [VERSION #release-tag]
        } else {
          [DRAFT · #datetime.today().display()]
        }
      ]
    ]
  ]
]

// Standalone colophon with build date and license notice.
#let build-page() = page(
  paper: "a4",
  margin: 0pt,
  header: none,
  footer: none,
  numbering: none,
)[
  #set par(justify: false, first-line-indent: 0pt)
  #align(center + horizon)[
    #text(size: 9pt)[Last build: #datetime.today().display()]
    #v(1.2cm)
    #text(size: 9pt)[© 2026 Zeno Saletti]
    #v(0.35cm)
    #text(size: 9pt)[Cover photograph: Zeno Saletti]
    #v(0.35cm)
    #text(size: 9pt)[
      Original text, illustrations, and cover photograph licensed under \
      #link("https://creativecommons.org/licenses/by-sa/4.0/")[Creative Commons
        Attribution-ShareAlike 4.0 International]
    ]
    #v(0.2cm)
    #text(size: 8pt)[
      #link("https://creativecommons.org/licenses/by-sa/4.0/")[
        creativecommons.org/licenses/by-sa/4.0/
      ]
    ]
    #v(0.45cm)
    #link("https://creativecommons.org/licenses/by-sa/4.0/")[
      #image("../images/cc-by-sa.svg", width: 88pt)
    ]
    #v(0.7cm)
    #text(size: 7.5pt)[
      Third-party content retains its respective license.
    ]
  ]
]

// Titled front-matter page for prose such as the preface or notes.
#let front-page(title, body) = {
  v(2cm)
  align(left)[
    #set par(first-line-indent: 0pt)
    #text(size: 17pt, weight: "bold")[#title]
  ]
  v(1.2cm)
  body
}

// Contents list: parts, chapters, and sections up to level 3.
#let contents-page() = {
  align(left)[
    #set par(first-line-indent: 0pt)
    #text(size: 19.5pt, weight: "bold")[Contents]
  ]
  v(1cm)
  show outline.entry: it => {
    if it.level == 2 or (it.level == 1 and it.element.numbering != none) {
      link(
        it.element.location(),
        it.indented(it.prefix(), [#strong(it.body()) #box(width: 1fr, it.fill)
          #it.page()]),
      )
    } else {
      link(it.element.location(), it.indented(it.prefix(), it.inner()))
    }
  }
  outline(depth: 3, title: none, indent: 1.1em)
}

// Start the next part or chapter on an odd (right-hand) page.
#let blank-page-if-needed() = {
  metadata("recto-before")
  pagebreak(to: "odd")
  metadata("recto-after")
}

// Part title page; the caller controls its page break.
#let part-page(title) = {
  v(6cm)
  heading(level: 1)[#title]
}

// Place chapter navigation in the outer margin without using text-column space.
#let outer-note(body) = place(
  right,
  dx: 6.45cm,
  block(width: margin-width)[#body],
)

// Format the captions passed to Marginalia image figures.
#let margin-caption(number, caption) = {
  set text(size: 7.25pt, fill: black)
  set par(justify: true, first-line-indent: 0pt)
  align(left)[#strong([Fig. #context caption.counter.display(
        caption.numbering,
      )]):
    #caption.body]
}

// Add an image file in the right margin; `id` makes it referenceable.
#let margin_figure(path, caption: none, id: none) = [
  #marginalia.notefigure(
    image(path, width: 100%),
    caption: caption,
    side: "right",
    alignment: "top",
    shift: true,
    keep-order: true,
    show-caption: margin-caption,
    text-style: (size: 8pt),
  )
  #id
]

// Add generated Typst content as a right-margin figure; supply alt text.
#let margin_diagram(body, caption: none, alt: none, id: none) = [
  #marginalia.notefigure(
    align(center, body),
    kind: image,
    caption: caption,
    alt: alt,
    side: "right",
    alignment: "top",
    shift: true,
    keep-order: true,
    show-caption: margin-caption,
    text-style: (size: 8pt),
  )
  #id
]

// Text-column image, diagram, and table; append <label> to reference one.
#let body_figure(path, caption, width: 100%) = figure(
  image(path, width: width),
  caption: caption,
)

#let body_diagram(body, caption, alt) = figure(
  align(center, body),
  kind: image,
  caption: caption,
  alt: alt,
)

#let body_table(data, caption) = figure(
  align(center, data),
  kind: table,
  caption: caption,
)

// Add a table in the right margin; `id` makes it referenceable.
#let margin_table(data, caption, id: none) = [
  #marginalia.notefigure(
    align(center, data),
    kind: table,
    caption: caption,
    side: "right",
    alignment: "top",
    shift: true,
    keep-order: true,
    text-style: (size: 8pt),
  )
  #id
]

// Short quotation aligned to the right, usable on front or chapter pages.
#let epigraph(words, author) = align(right)[#block(width: 48%)[
  #set par(justify: false, first-line-indent: 0pt)
  #align(left)[#text(size: 7.5pt, style: "italic")[#words]]
  #v(0.12cm)
  #line(length: 100%, stroke: (paint: black, thickness: 0.8pt))
  #v(0.1cm)
  #align(right)[#text(size: 7pt, fill: black)[#author]]
]]

// Wrap a chapter to advance its number and reset local object counters.
#let chapter(body) = {
  chapter-counter.step()
  image-counter.update(0)
  table-counter.update(0)
  algorithm-counter.update(0)
  counter(math.equation).update(0)
  body
}

// Override a long section title in the chapter's margin contents.
#let short-title(title) = metadata((kind: "short-title", title: title))

// Add margin contents and an optional opening quote after a chapter heading.
// Sections are collected up to the next chapter or part heading.
#let chapter-opening(quote: none, author: none) = context {
  let major = heading.where(level: 1).or(heading.where(level: 2))
  let next-major = query(selector(major).after(here())).first(default: none)
  let section-selector = selector(heading.where(level: 3)).after(here())
  if next-major != none {
    section-selector = section-selector.before(next-major.location())
  }
  let sections = query(section-selector)

  outer-note([
    #set par(justify: false, first-line-indent: 0pt)
    #for index in range(sections.len()) {
      let item = sections.at(index)
      let following = sections.at(index + 1, default: next-major)
      let short-selector = selector(metadata).after(item.location())
      if following != none {
        short-selector = short-selector.before(following.location())
      }
      let abbreviated = query(short-selector)
        .filter(entry => (
          type(entry.value) == dictionary
            and entry.value.at("kind", default: none) == "short-title"
        ))
        .first(default: none)
      let label = if abbreviated == none { item.body } else {
        abbreviated.value.title
      }
      block(above: 0.1cm, below: 0.1cm)[
        #grid(
          columns: (0.7cm, 1fr),
          gutter: 0.05cm,
          align(left)[#text(
            size: 8pt,
            weight: "bold",
            fill: accent,
          )[#context numbering(
            "1.1",
            chapter-counter.get().first(),
            index + 1,
          )]],
          align(left)[#text(size: 8pt)[#label]],
        )
      ]
    }
  ])
  if quote != none {
    v(0.2cm)
    epigraph(quote, author)
    v(1.2cm)
  } else {
    v(0.9cm)
  }
}

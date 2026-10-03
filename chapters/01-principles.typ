#import "../styles/book.typ": chapter-opening, short-title

== Why begin with a simple structure when the chapter title grows longer

#chapter-opening(
  quote: [It is a long established fact that a reader will be distracted by the
    readable content of a page when looking at its layout. The point of using
    Lorem Ipsum is that it has a more-or-less normal distribution of letters, as
    opposed to using 'Content here, content here', making it look like readable
    English. Many desktop publishing packages and web page editors now use Lorem
    Ipsum as their default model text, and a search for 'lorem ipsum' will
    uncover many web sites still in their infancy. Various versions have evolved
    over the years, sometimes by accident, sometimes on purpose (injected humour
    and the like).],
  author: [Who wrote this thing, this quote, amazing things happened.],
)

=== A document with readable parts <sec-structure>

The project separates content from formatting#footnote[The layout rules live in
  `styles/book.typ`, so the chapter files can focus on writing. This
  deliberately long note tests how the footnote area behaves when an explanation
  continues across several lines. It can hold details that would interrupt the
  main argument, such as a clarification about file organization, a short
  comment on a source, or a reminder about an editorial choice. As the book
  grows, notes should remain readable and separate from the text above them
  without taking over the page.]. The official Typst guide is cited here as an
example @typst-docs. Each chapter lives in a file under `chapters/`, while
`main.typ` sets the order of the cover, front matter, parts, and chapters.

To add a section, write another `===` heading in this file. Its title and number
will appear in both the main contents and the small margin contents#footnote[The
  optional `short-title` helper abbreviates a heading only in the margin
  contents.].

=== A deliberately long section title to demonstrate the shortened margin entry
#short-title[Shortened title]

The short title applies only to the margin contents. You can omit it when the
full heading is already short enough. The main text keeps the longer title here.

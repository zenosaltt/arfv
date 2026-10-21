#import "../assets/styles/book.typ": (
  body_diagram, body_subfigures, chapter, chapter-opening, document-style,
  margin_subfigures,
)
#import "../assets/styles/graphics.typ": cetz, fletcher, plot

#show: document-style

// Compile this file on its own; it is not included in the lecture notes.
#let geometry = cetz.canvas({
  import cetz.draw: *
  line((0, 0), (2, 0), (2, 1), close: true)
  cetz.angle.right-angle((2, 0), (0, 0), (2, 1), label: none)
  content((1, -0.3), $a$)
})

#let curve = cetz.canvas({
  plot.plot(
    size: (3, 2),
    x-label: $x$,
    y-label: $f(x)$,
    x-tick-step: 1,
    y-tick-step: 0.5,
    {
      plot.add(domain: (-1, 1), x => x * x)
    },
  )
})

#let flow = fletcher.diagram(
  spacing: 12pt,
  node-stroke: 0.6pt,
  node-inset: 4pt,
  {
    import fletcher: edge, node
    node((0, 0), [Input])
    node((1, 0), [Process])
    edge((0, 0), (1, 0), "->")
  },
)

#chapter([
  == Graphics examples
  #chapter-opening()

  === Geometry and plots

  #body_subfigures(
    figure(
      geometry,
      kind: image,
      caption: [A right triangle.],
      alt: "Right triangle with horizontal base a",
    ),
    <fig-example-triangle>,
    figure(
      curve,
      kind: image,
      caption: [A quadratic function.],
      alt: "Plot of x squared from minus one to one",
    ),
    <fig-example-curve>,
    caption: [CeTZ geometry and a CeTZ-Plot function.],
    alt: "A triangle beside a quadratic plot",
    id: <fig-example-pair>,
  )

  @fig-example-pair contains @fig-example-triangle and @fig-example-curve.

  #body_diagram(
    flow,
    [A Fletcher flowchart.],
    "An arrow connects Input to Process",
  ) <fig-example-flow>

  @fig-example-flow is the next figure after the group.

  === Margin panels

  #margin_subfigures(
    figure(geometry, kind: image, caption: [Geometry.], alt: "Right triangle"),
    <fig-example-margin-geometry>,
    figure(
      flow,
      kind: image,
      caption: [Flowchart.],
      alt: "Input connects to Process",
    ),
    <fig-example-margin-flow>,
    caption: [The same content arranged vertically in the margin.],
    alt: "A triangle above a flowchart",
    id: <fig-example-margin>,
  )

  @fig-example-margin groups @fig-example-margin-geometry and
  @fig-example-margin-flow. Both helpers use the same package-generated content.

  $ x^2 >= 0 $ <eq-example-square>

  $ x + 0 = x $

  $ x dot 1 = x $ <eq-example-product>

  @eq-example-square and @eq-example-product are numbered; the middle display is
  not. Inline mathematics also works at the start of a paragraph:

  $bold(x)$ is a vector in $RR^n$.
])

#pagebreak()
#chapter([
  == References across chapters
  #chapter-opening()

  === Stable figure numbers

  Earlier panels remain @fig-example-triangle, @fig-example-curve,
  @fig-example-margin-geometry and @fig-example-margin-flow.

  #body_diagram(
    flow,
    [Figure numbering starts again in this chapter.],
    "Input connects to Process",
  ) <fig-example-next-chapter>

  @fig-example-next-chapter starts the new chapter's figure sequence.
])

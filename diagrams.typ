#let edge = rgb("#3d65a9")
#let node-fill = rgb("#e7efff")
#let node-text = rgb("#25344a")

#let tree-node(x, y, value) = place(
  top + left,
  dx: x - 7pt,
  dy: y - 7pt,
  circle(radius: 7pt, fill: node-fill, stroke: 0.7pt + edge, inset: 0pt)[
    #align(center + horizon)[#text(size: 6.5pt, fill: node-text)[#value]]
  ],
)

#let binary-tree() = block(width: 160pt, height: 95pt)[
  #place(top + left, curve(
    stroke: 0.7pt + edge,
    curve.move((80pt, 10pt)),
    curve.line((40pt, 40pt)),
    curve.move((80pt, 10pt)),
    curve.line((120pt, 40pt)),
    curve.move((40pt, 40pt)),
    curve.line((20pt, 77pt)),
    curve.move((40pt, 40pt)),
    curve.line((60pt, 77pt)),
    curve.move((120pt, 40pt)),
    curve.line((100pt, 77pt)),
    curve.move((120pt, 40pt)),
    curve.line((140pt, 77pt)),
  ))
  #tree-node(80pt, 10pt, [8])
  #tree-node(40pt, 40pt, [4])
  #tree-node(120pt, 40pt, [12])
  #tree-node(20pt, 77pt, [2])
  #tree-node(60pt, 77pt, [6])
  #tree-node(100pt, 77pt, [10])
  #tree-node(140pt, 77pt, [14])
]

#let arrow-stroke = (
  paint: edge,
  thickness: 0.8pt,
  cap: "round",
  join: "round",
)

// The open tip follows the tangent of the incoming line or Bézier curve.
#let arrowhead(tip, direction) = {
  let (x, y) = tip
  let (dx, dy) = direction
  let magnitude = calc.sqrt(dx * dx + dy * dy)
  let ux = dx / magnitude
  let uy = dy / magnitude
  let base = (x - ux * 4pt, y - uy * 4pt)
  let wing-a = (base.at(0) - uy * 2pt, base.at(1) + ux * 2pt)
  let wing-b = (base.at(0) + uy * 2pt, base.at(1) - ux * 2pt)
  let bend-a = (x - ux * 1.8pt + uy * 0.2pt, y - uy * 1.8pt - ux * 0.2pt)
  let bend-b = (x - ux * 1.8pt - uy * 0.2pt, y - uy * 1.8pt + ux * 0.2pt)
  curve(
    stroke: arrow-stroke,
    curve.move(wing-a),
    curve.quad(bend-a, tip),
    curve.quad(bend-b, wing-b),
  )
}

#let dfa-label(x, y, body) = place(
  top + left,
  dx: x - 8pt,
  dy: y - 5pt,
  box(width: 16pt)[
    #align(center)[#text(size: 7.25pt, fill: node-text)[#body]]
  ],
)

#let dfa-node(x, y, body, accepting: false) = {
  place(
    top + left,
    dx: x - 8pt,
    dy: y - 8pt,
    circle(radius: 8pt, fill: node-fill, stroke: 0.8pt + edge, inset: 0pt)[
      #align(center + horizon)[#text(size: 7.25pt, fill: node-text)[#body]]
    ],
  )
  if accepting {
    place(
      top + left,
      dx: x - 6pt,
      dy: y - 6pt,
      circle(radius: 6pt, stroke: 0.5pt + edge),
    )
  }
}

#let two-state-dfa() = block(width: 240pt, height: 90pt)[
  #place(top + left, curve(
    stroke: arrow-stroke,
    curve.move((10pt, 50pt)),
    curve.line((55pt, 50pt)),
    curve.move((60pt, 43pt)),
    curve.cubic((42pt, 13pt), (88pt, 13pt), (70pt, 43pt)),
    curve.move((170pt, 43pt)),
    curve.cubic((152pt, 13pt), (198pt, 13pt), (180pt, 43pt)),
    curve.move((73pt, 47pt)),
    curve.cubic((100pt, 25pt), (140pt, 25pt), (167pt, 47pt)),
    curve.move((167pt, 53pt)),
    curve.cubic((140pt, 78pt), (100pt, 78pt), (73pt, 53pt)),
  ))
  #place(top + left, arrowhead((55pt, 50pt), (1, 0)))
  #place(top + left, arrowhead((70pt, 43pt), (-18, 30)))
  #place(top + left, arrowhead((180pt, 43pt), (-18, 30)))
  #place(top + left, arrowhead((167pt, 47pt), (27, 22)))
  #place(top + left, arrowhead((73pt, 53pt), (-27, -25)))
  #dfa-node(65pt, 50pt, [$q_0$])
  #dfa-node(175pt, 50pt, [$q_1$], accepting: true)
  #dfa-label(65pt, 12pt, [$alpha$])
  #dfa-label(175pt, 12pt, [$beta$])
  #dfa-label(120pt, 27pt, [$beta$])
  #dfa-label(120pt, 80pt, [$alpha$])
]

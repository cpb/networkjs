#= require commonjs
#= require Network
#= require EventedForceLayout
#= require d3.v2

width = 960
height = 500

color = d3.scale.category20()

svg = d3.select("#chart").append("svg")
  .attr("width", width)
  .attr("height", height)

restart = (svg,force,links,nodes) ->
  force.start()
  updateLinkPosition(buildLinks(svg,links))
  updateNodePosition(buildNodes(svg,force,nodes))

buildLinks = (svg,links) ->
  svg.selectAll("line.link")
    .data(links)
    .enter().append("line")
    .attr("class", "link")
    .style("stroke-width", 3)
    .style("stroke", "#ddd")

buildNodes = (svg,force,nodes) ->
  node = svg.selectAll("g.node")
    .data(nodes)
    .enter().append("g")
    .attr("class", "node")
    .call(force.drag)

  node.append("circle")
    .attr("r", 5)
    .style("fill", (d) -> color(d.group))

  node.append("text")
    .attr("text-anchor","start")
    .attr("dy", ".35em")
    .text((d) -> d.name)

  node

updateLinkPosition = (links) ->
  links.attr("x1", (d) -> d.source.x)
    .attr("y1", (d) -> d.source.y)
    .attr("x2", (d) -> d.target.x)
    .attr("y2", (d) -> d.target.y)

updateNodePosition = (nodes) ->
  nodes.attr("transform", (d) -> "translate("+d.x+","+d.y+")")

network = new exports.Network()
network.on("newNode", ->
  restart(svg,force,@links,@nodes))

force = new exports.EventedForceLayout(d3.layout.force(),
  charge: -240
  linkDistance: 30
  nodes: network.nodes
  links: network.links
  size: [width, height]
  onTick: ->
    updateLinkPosition(svg.selectAll("line.link"))
    updateNodePosition(svg.selectAll("g.node"))
)

exports.force = force

d3.json "miserables.json", (json) ->
  undrawnNodes = json.nodes.map (node,i) ->
    node.index = i
    node.targets = []
    node.sources = []
    json.links.forEach (link,i) ->
      if link.source == node.index
        node.targets.push(link.target)

      if link.target == node.index
        node.sources.push(link.source)

    node

  undrawnLinks = json.links

  svg.on "mousedown", () ->
    newNode = undrawnNodes.pop()
    network.addNode(newNode) if newNode?


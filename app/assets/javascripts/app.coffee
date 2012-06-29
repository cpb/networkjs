#= require commonjs
#= require Network
#= require d3.v2

width = 960
height = 500

color = d3.scale.category20()

net = new exports.Network()

nodes = []
links = []

force = d3.layout.force()
  .charge(-240)
  .linkDistance(30)
  .nodes(nodes)
  .links(links)
  .size([width, height])
  .on "tick", ->
    updateLinkPosition(svg.selectAll("line.link"))
    updateNodePosition(svg.selectAll("g.node"))

exports.force = force
for own prop, value in force
  console.log(prop,value)

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


d3.json "miserables.json", (json) ->
  undrawnNodes = json.nodes
  undrawnLinks = json.links

  svg.on "mousedown", () ->
    newNode = undrawnNodes.pop()
    if newNode?
      newNode.index = undrawnNodes.length

      newLinks = undrawnLinks.filter (link,i,set) ->
        (link.source == newNode.index || link.target == newNode.index)

      targets = []
      sources = []

      newLinks.forEach (link,i,set) ->
        if link.source == newNode.index
          targets.push(link)
        else
          sources.push(link)

      nodes.forEach (node,i,set) ->
        if targets.some((link,i,set) -> link.target == node.index)
          links.push({source: newNode, target: node})
        else if sources.some((link,i,set) -> link.source == node.index)
          links.push({target: newNode, source: node})

      nodes.push(newNode)

      restart(svg,force,links,nodes)

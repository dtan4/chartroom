$ ->
 # {
 #   id: "1aa324d4afc11e971cb86467681c0c94ff5bc0e946055ff92526bebee9477216",
 #   tagged?: false,
 #   name: "1aa324d4afc1",
 #   children: [
 #     {
 #       id: "2ba324d4afc11e971cb86467681c0c94ff5bc0e946055ff92526bebee9477216",
 #       tagged?: true,
 #       name: "dtan4/hoge:latest",
 #       children: [
 #         {
 #           id: "3ca324d4afc11e971cb86467681c0c94ff5bc0e946055ff92526bebee9477216",
 #           tagged?: true,
 #           name: "dtan4/fuga:latest",
 #           children: [],
 #         },
 #       ],
 #     },
 #   ],
 # }

  calculateDimensions = (containerId) ->
    containerElem = document.getElementById(containerId)

    return null if containerElem is null

    containerSize = { width: containerElem.clientWidth, height: 800 }
    margin = { top: 40, right: 0, bottom: 20, left: 20 }
    treeWidth = Math.max(0, containerSize.width - margin.right - margin.left)
    treeHeight = Math.max(0, containerSize.height - margin.top - margin.bottom)
    treeSize = { width: treeWidth, height: treeHeight }

    return { container: containerSize, tree: treeSize, margin: margin }


  offset = { x: 20, y : 20 }

  dimentions = calculateDimensions("imageDiagram")
  svg = d3.select("#imageDiagram")
    .append("svg")
    .attr("width", dimentions.container.width)
    .attr("height", dimentions.container.height)
  tree = d3.layout.tree()
    .size([dimentions.tree.width, dimentions.tree.height])

  toggle = (d) ->
    if (d.children)
      d._children = d.children
      d.children = null
    else
      d.children = d._children
      d._children = null

  renderImageTree = (dataList) ->
    nodes = tree.nodes(dataList)

    svg.selectAll("path")
      .data(tree.links(nodes))
      .enter()
      .append("path")
      .attr("d", d3.svg.diagonal())
      .attr("fill", "none")
      .attr("stroke", "#aaa" )
      .attr("stroke-width", 1)
      .attr("transform", "translate(#{offset.x}, #{offset.y})")

    svg.selectAll("circle")
      .data(nodes)
      .enter()
      .append("circle")
      .attr("cx", (d) -> return d.x + offset.x)
      .attr("cy", (d) -> return d.y + offset.y)
      .attr("r", 5)
      .style("stroke", (d) -> if d.tagged then "lightgreen" else "blue")
      .style("fill", (d) -> if d.tagged then "green" else "white")
      .on("click", (d) -> toggle(d); renderImageTree(dataList))

  d3.json "/api/images", (error, data) ->
    renderImageTree(data[0])

  $("#imagesList > tbody td").click ->
    return if network == null

    # focusOnNode

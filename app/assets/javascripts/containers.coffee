$ ->
  diagram_container = document.getElementById("containersDiagramContainer")
  network = null

  options = {
    edges: {
      width: 2
    },
    physics: {
      barnesHut: {
        enabled: false
      }
      repulsion: {
        nodeDistance: 100
      }
    },
    height: "700px"
  }

  $.getJSON "/api/containers", {}, (data) ->
    network = new vis.Network(diagram_container, data, options)

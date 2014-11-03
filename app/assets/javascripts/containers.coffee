$ ->
  diagram_container = document.getElementById("containersDiagramContainer")
  network = null

  options = {
    edges: {
      width: 2
    },
    width: "500px",
    height: "500px"
  }

  $.getJSON "/api/containers", {}, (data) ->
    network = new vis.Network(diagram_container, data, options)

$ ->
  diagram_container = document.getElementById("containersDiagramContainer")
  network = null

  options = {
    edges: {
      color: "black",
      width: 2
    }
  }

  $.getJSON "/api/containers", {}, (data) ->
    network = new vis.Network(diagram_container, data, options)

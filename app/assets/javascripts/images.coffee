$ ->
  diagram_container = document.getElementById("diagramContainer")
  network = null

  options = {
    edges: {
      color: "black",
      width: 2
    }
  }

  $.getJSON "/api/images", {}, (data) ->
    network = new vis.Network(diagram_container, data, options)

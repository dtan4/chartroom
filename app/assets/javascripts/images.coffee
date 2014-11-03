$ ->
  diagram_container = document.getElementById("imagesDiagramContainer")
  diagram_data = null
  network = null

  options = {
    edges: {
      width: 2
    },
    stabilize: false,
    smoothCurves: false,
    hierarchicalLayout: {
      enabled: true,
    }
  }

  $.getJSON "/api/images", {}, (data) ->
    diagram_data = data
    network = new vis.Network diagram_container, data, options

$ ->
  diagram_container = document.getElementById("imagesDiagramContainer")
  diagram_data = null
  network = null

  options = {
    edges: {
      width: 2
    },
    stabilize: false,
    hierarchicalLayout: {
      enabled:true,
      levelSeparation: 150,
      nodeSpacing: 1000,
      direction: "UD"
    }
  }

  $.getJSON "/api/images", {}, (data) ->
    diagram_data = data
    network = new vis.Network diagram_container, data, options

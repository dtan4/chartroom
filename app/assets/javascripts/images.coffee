$ ->
  diagramContainer = document.getElementById("imagesDiagramContainer")
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
      levelSeparation: 150,
      nodeSpacing: 1000,
      direction: "UD"
    },
    height: "700px"
  }

  $.getJSON "/api/images", {}, (data) ->
    diagram_data = data
    network = new vis.Network diagramContainer, data, options

  $("#imagesList > tbody td").click ->
    return if network == null

    imageId = $(this).parent()[0].id
    network.focusOnNode "image_#{imageId}", { scale: 1 }

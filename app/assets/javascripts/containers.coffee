$ ->
  diagramContainer = document.getElementById("containersDiagramContainer")
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

  unless diagramContainer is null
    $.getJSON "/api/containers", {}, (data) ->
      network = new vis.Network(diagramContainer, data, options)

  $("#containersList > tbody td").click ->
    return if network == null

    containerId = $(this).parent()[0].id
    network.focusOnNode "container_#{containerId}"

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

  $.getJSON "/api/containers", {}, (data) ->
    network = new vis.Network(diagramContainer, data, options)

  $("#containersList > tbody td").click ->
    return if network == null

    containerId = $(this).parent()[0].id
    console.log containerId
    network.focusOnNode "container_#{containerId}"

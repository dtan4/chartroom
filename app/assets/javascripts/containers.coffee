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

  refreshDiagram = ->
    $.getJSON "/api/containers", {}, (data) ->
      network = new vis.Network(diagramContainer, data, options)

  unless diagramContainer is null
    refreshDiagram()

  $("#containersList > tbody td").click ->
    return if network == null

    containerId = $(this).parent()[0].id
    network.focusOnNode "container_#{containerId}"

  $(".text-center > button").click ->
    containerId = $(this).parent().parent().parent().attr "id"

    $.ajax {
      type: "DELETE",
      url: "/api/containers/#{containerId}",
      success: (data) ->
        console.log data
        $("##{containerId}").remove()
        refreshDiagram()
      ,
      error: (data) -> console.error JSON.parse(data)["message"]
     }

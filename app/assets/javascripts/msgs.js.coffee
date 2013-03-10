# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  if 0 < $("#live_msgs").length
    source = new EventSource('/msgs/watch?room=' + $('#room').text())

    source.onopen = (event) ->
      console.log("open", event)
      $("#live_msgs").prepend("(open)" + "<br />")

    source.onmessage = (event) ->
      data = $.parseJSON(event.data)
      if data.debug
        $("#debug").html(data.debug)
      else
        console.log(data)
        # JSON.stringify(data)
        $("#live_msgs").prepend(data.sender + ":" + data.body + "<br />")

    source.onerror = (x) ->
      console.log("error", x)
      $("#live_msgs").prepend("error" + "<br />")


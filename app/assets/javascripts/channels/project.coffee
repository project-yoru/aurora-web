App.project = App.cable.subscriptions.create "ProjectChannel",
  connected: ->
    # Called when the subscription is ready for use on the server
    console.debug 'actioncable connected'

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    console.debug 'actioncable received'

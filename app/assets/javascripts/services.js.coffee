@ocarinaServices = angular.module('ocarinaServices', ['ngResource'])

@ocarinaServices.factory 'Pusher', ->
  if Pusher?
    pusher = new Pusher("28d86c309600f754848f")
  else
    # if pusher doesn't load
    {
      subscribe: ->
        {
          bind: ->
            true
          unbind: ->
            true
        }
    }

  ##
  # Uncomment this during development
  #
  # Pusher.log = (message) ->
  # window.console.log message if window.console and window.console.log

  # TODO this should probably go in Ctrls
  # subscribe: (channel) ->
  #   pusher.subscribe(channel)

  # bind: (event, callback) ->
  #   channel.bind event, ->
  #     args = arguments
  #     $rootScope.$apply ->
  #       callback.apply channel, args

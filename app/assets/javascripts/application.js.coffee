# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# compiled file.
#
# Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
# about supported directives.
#
# = require_self
# = require directives
# = require_tree ./controllers/


window.App = angular.module
  .module('ocarina', ['ngResource', 'ngSanitize'])
  .config(['$locationProvider', '$routeProvider', '$httpProvider', \
          ($locationProvider, $routeProvider, $httpProvider) ->
    $locationProvider.html5Mode(true)

    # Put CSRF token in all AJAX headers
    $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')

App.factory "pusher", ($rootScope) ->
  pusher = new Pusher("28d86c309600f754848f")

  ##
  # Uncomment this during development
  #
  # Pusher.log = (message) ->
  # window.console.log message if window.console and window.console.log

  subscribe: (channel) ->
    pusher.subscribe(channel)

  bind: (event, callback) ->
    channel.bind event, ->
      args = arguments
      $rootScope.$apply ->
        callback.apply channel, args




ocarinaDirectives = angular.module('ocarinaDirectives', [])

ocarinaDirectives.directive 'dropboxAuth', ->
  (scope, $elm, attr) ->
    $elm.on 'click', ->
      window.location.replace("/auth/dropbox")

ocarinaDirectives.directive 'audio', ['AudioService', (AudioService) ->
  restrict: 'EA',
  scope: {
    'src': '=source'
  },
  template: '' +
    '<div ng-transclude>' +
      '<button ng-click="player.playPause()">play/pause</button>' +
      '<div>position: {{position}}</div>' +
      '<div>duration: {{duration}}</div>'+
    '</div>',
  replace: true,
  transclude: true,
  controller: ($scope, $element, $attrs, $transclude) ->
    $scope.player = AudioService

    $scope.player.on 'timeupdate', (time, duration) ->
      $scope.$apply ->
        $scope.position = time
        $scope.duration = duration

    $scope.$watch 'src', (new_value, old_value) ->
        $scope.player.load(new_value)
]

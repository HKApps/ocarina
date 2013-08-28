ocarinaDirectives = angular.module('ocarinaDirectives', [])

ocarinaDirectives.directive 'dropboxAuth', ->
  (scope, $elm, attr) ->
    $elm.on 'click', ->
      window.location.replace("/auth/dropbox")

ocarinaDirectives.directive 'onReturn', ->
  (scope, $elm, attr) ->
    $elm.bind 'keydown', (e) ->
      if e.keyCode == 13 && !e.shiftKey && !e.altKey
        e.preventDefault()
        scope.$apply(attr.onReturn)

ocarinaDirectives.directive 'onInput', ->
  (scope, $elm, attr) ->
    $elm.on 'keydown', ->
      scope.$apply(attr.onInput)

ocarinaDirectives.directive 'onDebouncedKeyup', ->
  (scope, $elm, attr) ->
    debouncedApply = _.debounce ->
      scope.$apply(attr.onDebouncedKeyup)
    , 300
    $elm.bind('keyup', debouncedApply)

ocarinaDirectives.directive 'onFocus', ->
  (scope, $elm, attr) ->
    $elm.on 'focusin', ->
      scope.$apply(attr.onFocus)

ocarinaDirectives.directive 'onBlur', ->
  (scope, $elm, attr) ->
    $elm.on 'blur', ->
      scope.$apply(attr.onBlur)

ocarinaDirectives.directive 'onClickFocus', ->
  (scope, $elm, attr) ->
    $elm.on 'click', ->
      $(attr.onClickFocus).focus()

# will end up removing this when upgrading angular
ocarinaDirectives.directive "ocarinaIf", ->
  transclude: "element"
  priority: 1000
  terminal: true
  restrict: "A"
  compile: (element, attr, transclude) ->
    (scope, element, attr) ->
      childElement = undefined
      childScope = undefined
      scope.$watch attr.ocarinaIf, (newValue) ->
        if childElement
          childElement.remove()
          childElement = `undefined`
        if childScope
          childScope.$destroy()
          childScope = `undefined`
        if newValue
          childScope = scope.$new()
          transclude childScope, (clone) ->
            childElement = clone
            element.after clone

ocarinaDirectives.directive 'ocarinaPrevious', ->
  (scope, $elm, attr) ->
    $elm.on 'click', ->
      window.history.back()

ocarinaDirectives.directive 'seekProgressBar', ->
  (scope, $elm, attr) ->
    $elm.on 'mousedown', (e) ->
      scope.timeDrag = true
      scope.updatebar e.pageX
    $elm.on 'mouseup', (e) ->
      if scope.timeDrag
        scope.timeDrag = false
        scope.updatebar e.pageX
    $elm.on 'mousemove', (e) ->
      scope.updatebar e.pageX if scope.timeDrag

ocarinaDirectives.directive 'timeAgo', ['$rootScope', '$timeout',
  ($rootScope, $timeout) ->
    (scope, $elm, attr) ->
      $timeout ->
        $elm.timeago()
      , 0
]

ocarinaDirectives.directive "typeahead", ["$timeout", ($timeout) ->
  restrict: "E"
  transclude: true
  replace: true
  template: """
    <div class='col-md-6 col-md-offset-3'>
      <form class='form'>
        <input class='form-control input-lg col-lg-8' ng-model='term'
        ng-change='query()' type='text' autocomplete='off' placeholder='Search'/>
      </form>
      <div ng-transclude class='typeahead-menu'>
      </div>
    </div>
    """
  scope:
    search: "&"
    select: "&"
    items: "="
    term: "="

  controller: ["$scope", ($scope) ->
    $scope.items = []
    $scope.hide = false

    @activate = (item) ->
      $scope.active = item

    @activateNextItem = ->
      index = $scope.items.indexOf($scope.active)
      @activate $scope.items[(index + 1) % $scope.items.length]

    @activatePreviousItem = ->
      index = $scope.items.indexOf($scope.active)
      @activate $scope.items[(if index is 0 then $scope.items.length - 1 else index - 1)]

    @isActive = (item) ->
      $scope.active is item

    @selectActive = ->
      @select $scope.active

    @select = (item) ->
      $scope.hide = true
      $scope.focused = true
      $scope.select item: item

    $scope.isVisible = ->
      not $scope.hide and ($scope.focused or $scope.mousedOver)

    $scope.query = ->
      $scope.hide = false
      $scope.search term: $scope.term
  ]
  link: (scope, element, attrs, controller) ->
    $input = element.find("form > input")
    $list = element.find("> div")

    $input.bind "focus", ->
      scope.$apply ->
        scope.focused = true

    $input.bind "blur", ->
      scope.$apply ->
        scope.focused = false

    $list.bind "mouseover", ->
      scope.$apply ->
        scope.mousedOver = true

    $list.bind "mouseleave", ->
      scope.$apply ->
        scope.mousedOver = false

    $input.bind "keyup", (e) ->
      if e.keyCode is 9 or e.keyCode is 13
        scope.$apply ->
          controller.selectActive()

      if e.keyCode is 27
        scope.$apply ->
          scope.hide = true

    $input.bind "keydown", (e) ->
      e.preventDefault()  if e.keyCode is 9 or e.keyCode is 13 or e.keyCode is 27
      if e.keyCode is 40
        e.preventDefault()
        scope.$apply ->
          controller.activateNextItem()

      if e.keyCode is 38
        e.preventDefault()
        scope.$apply ->
          controller.activatePreviousItem()

    scope.$watch "items", (items) ->
      controller.activate (if items.length then items[0] else null)

    scope.$watch "focused", (focused) ->
      if focused
        $timeout (->
          $input.focus()
        ), 0, false

    scope.$watch "isVisible()", (visible) ->
      if visible
        pos = $input.position()
        height = $input[0].offsetHeight
        $list.css
          top: pos.top + height
          left: pos.left
          position: "absolute"
          display: "block"
      else
        $list.css "display", "none"
]

ocarinaDirectives.directive "typeaheadItem", ->
  require: "^typeahead"
  link: (scope, element, attrs, controller) ->
    item = scope.$eval(attrs.typeaheadItem)

    scope.$watch (->
      controller.isActive item
    ), (active) ->
      if active
        element.addClass "active"
      else
        element.removeClass "active"

    element.bind "mouseenter", (e) ->
      scope.$apply ->
        controller.activate item

    element.bind "click", (e) ->
      scope.$apply ->
        controller.select item

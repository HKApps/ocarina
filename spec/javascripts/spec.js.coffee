# This pulls in all your specs from the javascripts directory into Jasmine:
#
# spec/javascripts/*_spec.js.coffee
# spec/javascripts/*_spec.js
# spec/javascripts/*_spec.js.erb
#
#=require application
#=require angular-mocks
#=require_self
#=require_tree ./unit/

beforeEach ->
  window.env = 'test'

  @addMatchers
    toEqualData: (expected) ->
      angular.equals(this.actual, expected)

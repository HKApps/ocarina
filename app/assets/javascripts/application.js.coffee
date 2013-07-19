#= require jquery
#= require angular
#= require angular-resource
#= require angular-sanitize
#= require underscore
#= require ocarina
#= require_tree ./controllers/
#= require services
#= require directives
#= require filters
#= require_self
#= require zepto/default
#= require foundation

# Setups foundation
$ ->
  $(document).foundation()

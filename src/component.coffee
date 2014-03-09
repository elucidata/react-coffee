
# Public: Define components as CoffeeScript classes
#
# Example:
# 
#   class UserChip extends Component
# 
#     @staticMethod: -> # becomes a static method on the React Component
#       "hello"
# 
#     render: ->
#       (@div null, "Hello")
#
#   # This will create the React component based on the class definition,
#   # including translating (@div XXX) calls into React.DOM.div(XXX) calls.
#   module.exports= UserChip.reactify() 
#
class Component
  
  @reactify: ->
    React.createClass extractMethods this


extractMethods= (comp)->
  methods= {}
  for key,val of comp::
    continue if key in ignoredKeys
    methods[key]= translateTagCalls val
  methods.displayName= comp.name or comp.displayName or 'UnnamedComponent'
  methods.statics= extractStatics comp
  methods

extractStatics= (comp)->
  statics=
    Class: comp
  for key,val of comp
    continue if key in ignoredKeys
    statics[key]= translateTagCalls val
  statics

ignoredKeys= '__super__ constructor reactify'.split ' '

tagParser= /this\.(\w*)\(/g

translateTagCalls= (fn)->
  return fn unless typeof(fn) is 'function'
  
  source= fn.toString()
  compiled= source.replace tagParser, (segment)->
    tag= segment.replace('this.', '').replace('(', '')
    if React.DOM[ tag ]? then "React.DOM.#{ tag }(" else segment
  
  if compiled isnt source
    # Yes, this uses eval. Deal with it.
    eval "(#{ compiled })"
  else
    fn

React= @React or require('react')

umd= (factory) ->
  if typeof exports is 'object'
    module.exports = factory()
  else if typeof define is 'function' and define.amd
    define([], factory)
  else
    @Component = factory()
 
umd -> Component

React.Component= Component

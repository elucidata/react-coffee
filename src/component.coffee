###
  elucidata-react-coffee v0.3.2
  https://github.com/elucidata/react-coffee


  Public: Define components as CoffeeScript classes
 
  Example:
  
    class UserChip extends Component
  
      @staticMethod: -> # becomes a static method on the React Component
        "hello"
  
      render: ->
        (@div null, "Hello")
 
    # This will create the React component based on the class definition,
    # including translating (@div XXX) calls into React.DOM.div(XXX) calls.
    module.exports= UserChip.reactify() 

###
class Component
  
  @reactify: (componentClass=this)->
    React.createClass extractMethods componentClass


extractMethods= (comp)->
  methods= extractInto {}, comp::
  methods.displayName= comp.name or comp.displayName or 'UnnamedComponent'
  methods.statics= extractInto Class:comp, comp
  methods

extractInto= (target, source)->
  for key,val of source
    continue if key in ignoredKeys
    target[key]= translateTagCalls val
  target

ignoredKeys= '__super__ constructor reactify'.split ' '

tagParser= /this\.(\w*)\(/g

translateTagCalls= (fn)->
  return fn unless typeof(fn) is 'function'
  
  source= fn.toString()
  compiled= source.replace tagParser, (fragment, tag)->
    if React.DOM[ tag ]? then "React.DOM.#{ tag }(" else fragment
  
  if compiled isnt source
    eval "(#{ compiled })" # Yes, this uses eval. Deal with it.
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

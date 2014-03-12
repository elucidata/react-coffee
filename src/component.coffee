###
  elucidata-react-coffee
  https://github.com/elucidata/react-coffee


  Public: Define components as CoffeeScript classes
 
  Example:

    class UserChip extends Component
  
      @staticMethod: -> # becomes a static method on the React Component
        "hello"
  
      render: ->
        (@div null, "Hello")
 
    # This will create the React component based on the class definition,
    # including translating (@div XXX) calls into React.DOM.div(XXX) calls
    # (disabled by default, pass true as param to enable).
    module.exports= UserChip.reactify(true) 

###
class Component
  
  @reactify: (translateTags=no, componentClass=this)->
    if typeof(translateTags) is 'function'
      componentClass= translateTags
      translateTags= no
    React.createClass extractMethods componentClass, translateTags

extractMethods= (comp, translateTags)->
  translateTags = comp.translateTags or translateTags
  methods= extractInto {}, comp::, translateTags
  methods.displayName= getFnName comp
  methods.statics= extractInto Class:comp, comp, translateTags
  methods

extractInto= (target, source, translateTags)->
  for key,val of source
    continue if key in ignoredKeys
    target[key]= if translateTags
        translateTagCalls val
      else
        val
  target

ignoredKeys= '__super__ constructor reactify'.split ' '

tagParser= /this\.(\w*)\(/g
nameParser= /function (.+?)\(/

getFnName= (fn)->
  fn.name or fn.displayName or (fn.toString().match(nameParser) or [null,'UnnamedComponent'])[1]

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

###
  elucidata-react-coffee
  https://github.com/elucidata/react-coffee
###
ignoredKeys= '__super__ constructor reactify toComponent'.split ' '
nameParser= /function (.+?)\(/
React= @React or require('react')

class Component
  
  @toComponent: (componentClass=this)->
    React.createClass extractMethods componentClass

  # DEPRECATED: This alias will be removed from a future version.
  @reactify: @toComponent
  

extractMethods= (comp)->
  methods= extractInto {}, comp::
  methods.displayName= getFnName comp
  methods.statics= extractInto Class:comp, comp
  methods

extractInto= (target, source)->
  for key,val of source
    continue if key in ignoredKeys
    target[key]= val
  target


getFnName= (fn)->
  fn.name or fn.displayName or (fn.toString().match(nameParser) or [null,'UnnamedComponent'])[1]

umd= (factory) ->
  if typeof exports is 'object'
    module.exports = factory()
  else if typeof define is 'function' and define.amd
    define([], factory)
  else
    @Component = factory()
 
umd -> Component

React.Component= Component

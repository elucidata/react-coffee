###
  elucidata-react-coffee
  https://github.com/elucidata/react-coffee
###
nameParser= /function (.+?)\(/
React= @React or require('react')

class Component

  @keyBlacklist= '__super__ __superConstructor__ constructor keyBlacklist reactify build toComponent'.split ' '

  @toComponent: (componentClass=this, ignore=[])->
    React.createFactory React.createClass extractMethods componentClass, ignore

  @build: @toComponent

  # DEPRECATED: This alias will be removed from a future version.
  @reactify: @toComponent


extractMethods= (comp, ignore)->
  methods= extractInto {}, (new comp), ignore
  methods.displayName= getFnName comp
  handleMixins methods, comp
  handlePropTypes methods, comp
  methods.statics= extractInto Class:comp, comp, ignore.concat(['mixins', 'propTypes'])
  methods


extractInto= (target, source, ignore)->
  for key,val of source
    continue if key in Component.keyBlacklist
    continue if key in ignore
    target[key]= val
  target

extractAndMerge= (prop, merge)->
  (instance, statics)->
    result= statics[prop]?() or statics[prop]
    if result?
      unless instance[prop]?
        instance[prop]= result
      else
        instance[prop]= merge(instance[prop], result)

handlePropTypes= extractAndMerge 'propTypes', (target, value)->
  target[key]= val for key,val of value
  target

handleMixins= extractAndMerge 'mixins', (target, value)->
  target.concat value

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

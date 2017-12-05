###
  elucidata-react-coffee
  https://github.com/elucidata/react-coffee
###
React = require 'react'
createReactClass = require 'create-react-class'

nameParser = /function (.+?)\(/
keyBlacklist = '__super__ __superConstructor__ constructor keyBlacklist toComponent'.split ' '

createReactComponent = (componentClass, ignore) ->
  React.createFactory createReactClass extractMethods componentClass, ignore ? []

extractMethods = (comp, ignore) ->
  methods = extractInto {}, (new comp), ignore
  methods.displayName = getFnName comp
  handleMixins methods, comp
  handlePropTypes methods, comp
  methods.statics = extractInto Class: comp, comp, ignore.concat(['mixins', 'propTypes'])
  methods

extractInto = (target, source, ignore) ->
  for key, val of source
    continue if key in keyBlacklist
    continue if key in ignore
    target[key] = val
  target

extractAndMerge = (prop, merge) ->
  (instance, statics) ->
    result = statics[prop]?() or statics[prop]
    if result?
      if not instance[prop]?
        instance[prop] = result
      else
        instance[prop] = merge(instance[prop], result)

handlePropTypes = extractAndMerge 'propTypes', (target, value) ->
  target[key] = val for key, val of value
  target

handleMixins = extractAndMerge 'mixins', (target, value) ->
  target.concat value

getFnName = (fn) ->
  fn.name or fn.displayName or (fn.toString().match(nameParser) or [null, 'UnnamedComponent'])[1]

module.exports = createReactComponent

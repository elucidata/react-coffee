
/*
  elucidata-react-coffee
  https://github.com/elucidata/react-coffee


  Public: Define components as CoffeeScript classes
 
  Example:

    class UserChip extends Component
  
      @staticMethod: -> # becomes a static method on the React Component
        "hello"
  
      render: ->
        (@div null, "Hello")
 
     * This will create the React component based on the class definition,
     * including translating (@div XXX) calls into React.DOM.div(XXX) calls
     * (disabled by default, pass true as param to enable).
    module.exports= UserChip.reactify(true)
 */

(function() {
  var Component, React, extractInto, extractMethods, getFnName, ignoredKeys, nameParser, tagParser, translateTagCalls, umd,
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  Component = (function() {
    function Component() {}

    Component.reactify = function(translateTags, componentClass) {
      if (translateTags == null) {
        translateTags = false;
      }
      if (componentClass == null) {
        componentClass = this;
      }
      if (typeof translateTags === 'function') {
        componentClass = translateTags;
        translateTags = false;
      }
      return React.createClass(extractMethods(componentClass, translateTags));
    };

    return Component;

  })();

  extractMethods = function(comp, translateTags) {
    var methods;
    translateTags = comp.translateTags || translateTags;
    methods = extractInto({}, comp.prototype, translateTags);
    methods.displayName = getFnName(comp);
    methods.statics = extractInto({
      Class: comp
    }, comp, translateTags);
    return methods;
  };

  extractInto = function(target, source, translateTags) {
    var key, val;
    for (key in source) {
      val = source[key];
      if (__indexOf.call(ignoredKeys, key) >= 0) {
        continue;
      }
      target[key] = translateTags ? translateTagCalls(val) : val;
    }
    return target;
  };

  ignoredKeys = '__super__ constructor reactify'.split(' ');

  tagParser = /this\.(\w*)\(/g;

  nameParser = /function (.+?)\(/;

  getFnName = function(fn) {
    return fn.name || fn.displayName || (fn.toString().match(nameParser) || [null, 'UnnamedComponent'])[1];
  };

  translateTagCalls = function(fn) {
    var compiled, source;
    if (typeof fn !== 'function') {
      return fn;
    }
    source = fn.toString();
    compiled = source.replace(tagParser, function(fragment, tag) {
      if (React.DOM[tag] != null) {
        return "React.DOM." + tag + "(";
      } else {
        return fragment;
      }
    });
    if (compiled !== source) {
      return eval("(" + compiled + ")");
    } else {
      return fn;
    }
  };

  React = this.React || require('react');

  umd = function(factory) {
    if (typeof exports === 'object') {
      return module.exports = factory();
    } else if (typeof define === 'function' && define.amd) {
      return define([], factory);
    } else {
      return this.Component = factory();
    }
  };

  umd(function() {
    return Component;
  });

  React.Component = Component;

}).call(this);

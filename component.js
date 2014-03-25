
/*
  elucidata-react-coffee
  https://github.com/elucidata/react-coffee
 */

(function() {
  var Component, React, extractInto, extractMethods, getFnName, nameParser, umd,
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  nameParser = /function (.+?)\(/;

  React = this.React || require('react');

  Component = (function() {
    function Component() {}

    Component.keyBlacklist = '__super__ __superConstructor__ constructor keyBlacklist reactify toComponent'.split(' ');

    Component.toComponent = function(componentClass) {
      if (componentClass == null) {
        componentClass = this;
      }
      return React.createClass(extractMethods(componentClass));
    };

    Component.build = Component.toComponent;

    Component.reactify = Component.toComponent;

    return Component;

  })();

  extractMethods = function(comp) {
    var methods;
    methods = extractInto({}, new comp);
    methods.displayName = getFnName(comp);
    methods.statics = extractInto({
      Class: comp
    }, comp);
    return methods;
  };

  extractInto = function(target, source) {
    var key, val;
    for (key in source) {
      val = source[key];
      if (__indexOf.call(Component.keyBlacklist, key) >= 0) {
        continue;
      }
      target[key] = val;
    }
    return target;
  };

  getFnName = function(fn) {
    return fn.name || fn.displayName || (fn.toString().match(nameParser) || [null, 'UnnamedComponent'])[1];
  };

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

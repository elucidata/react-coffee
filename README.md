# elucidata-react-coffee

Define React components using natural CoffeeScript syntax.

Example:

```coffeescript
{div}= React.DOM

class UserChip extends React.Component
  @staticMethod: -> # becomes a static method on the React Component
    "hello"

  render: ->
    (div null, "Hello")

module.exports= UserChip.reactify()
```

Alternate style:

```coffeescript
{div}= React.DOM

module.exports= React.Component.reactify class MyComponent
  
  render: ->
    (div null,
      "My Component!"
    )
```

There is *experimental* support for translating `(@div ...)` calls into `React.DOM.div(...)` calls (not just div, any tag defined in React.DOM). Under the covers it uses `eval` to create a new function with the translated calls, so it loses any enclosed values. For that reason it's disabled by default, and this particular feature is not recommended for any real use (except for maybe leaf level, html content-heavy, components).

```coffeescript
class UserChip extends React.Component
  @translateTags: yes # Will convert `@div` into `React.DOM.div`. Default: no

  @staticMethod: -> # becomes a static method on the React Component
    (@section null, "statically yours")

  render: ->
    (@div null, "Hello ", (@b null, "you"), ".")

module.exports= UserChip.reactify()
```


## Installation

For browserify:

    npm install elucidata-react-coffee --save

For bower:

    bower install elucidata-react-coffee --save


## Todo

- Examples
- Tests


# License

The MIT License (MIT)

Copyright (c) 2014 Elucidata unLTD

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
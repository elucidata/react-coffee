# Abusing React.Component for Fun and Profit

React, by its very nature, encourages composition over inheritance. But sometimes, just *sometimes*, inheritance can be useful. In those rare instances, you can do something like this:

`base-result-item.coffee`:
```coffeescript
{tr, td}= React.DOM

class BaseResultItem extends React.Component
  render: ->
    (tr null,
      (td null, @props.name)
      (do @renderOtherFields)
    )

  renderOtherFields: -> null

module.exports= BaseResultItem.reactify()
```

`simple-result-item.coffee`:
```coffeescript
{td}= React.DOM
BaseResultItem= require 'base-result-item'

class SimpleResultItem extends BaseResultItem.Class
  renderOtherFields: ->
    (td null,
      "actions or other things."
    )  

module.exports= SimpleResultItem.reactify()
```




{CompositeDisposable} = require 'atom'
proxy = require './services/symfony2-proxy.coffee'

module.exports =
  activate: ->

  deactivate: ->

  getAutocompleteTools: (tools) ->
    proxy.providePhpProxy(tools.proxy)

{CompositeDisposable} = require 'atom'
proxy = require './services/symfony2-proxy.coffee'
config = require './config.coffee'
YamlServiceProvider = require './providers/services/yaml-service-provider.coffee'
XmlServiceProvider = require './providers/services/xml-service-provider.coffee'

module.exports =
    config:
        console:
            title: 'Relative path to console file'
            description: 'Relative path to symfony2 console file (default app/console)'
            type: 'array'
            default: ['app/console']
            order: 1

    activate: ->
        config.init()

        @providers = []
        @providers.push(new YamlServiceProvider)
        @providers.push(new XmlServiceProvider)

    deactivate: ->

    getAutocompleteTools: (tools) ->
        proxy.providePhpProxy(tools.proxy)

    getProvider: ->
        return @providers

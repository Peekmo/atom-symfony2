{CompositeDisposable} = require 'atom'
proxy = require './services/symfony2-proxy.coffee'
parser = require './services/php-parser.coffee'
config = require './config.coffee'
plugin = require './plugin.coffee'
YamlServiceProvider = require './providers/services/yaml-service-provider.coffee'
YamlClassProvider = require './providers/services/yaml-class-provider.coffee'
XmlServiceProvider = require './providers/services/xml-service-provider.coffee'
XmlClassProvider = require './providers/services/xml-class-provider.coffee'
ServiceProvider = require './providers/service-provider.coffee'

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
        proxy.init()

        @providers = []
        @providers.push(new YamlServiceProvider)
        @providers.push(new YamlClassProvider)
        @providers.push(new XmlServiceProvider)
        @providers.push(new XmlClassProvider)
        @providers.push(new ServiceProvider)

    deactivate: ->

    getAutocompleteTools: (tools) ->
        proxy.providePhpProxy(tools.proxy)
        parser.parser = tools.parser

    getPhpPlugin: ->
        return plugin

    getProvider: ->
        return @providers

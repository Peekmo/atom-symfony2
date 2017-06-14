config = require '../config.coffee'

module.exports =
    phpProxy: null
    data:
        entities: {}
        services: {}
        routes: {}

    ###*
     * Execute a symfony2 command
     * @param  {array} command
     * @return {mixed}
    ###
    execute: (command) ->
        if !@phpProxy
            return []

        for directory in atom.project.getDirectories()
            for cons in config.config["console"]
                res = @phpProxy.execute([cons].concat(command), false, {cwd: directory.path}, true)
                if not res.error? and res.result?.split("\n").length > 2
                    return res
                else
                    res = []

        return []

    ###*
     * Adds the atom autocomplete php proxy
     * @param  {Object} proxy
    ###
    providePhpProxy: (proxy) ->
        @phpProxy = proxy

    ###*
     * Returns sf2 services
     *
     * @param {bool} force Force refresh or not ?
     *
     * @return {array}
    ###
    getServices: (force) ->
        if Object.keys(@data.services).length == 0 || force
            @data.services = {}

            lines = @execute("debug:container")

            if lines != [] and lines.result
                lines = lines.result.split("\n")

            list = false
            for line in lines
                if list == false
                    if line.indexOf("Service ID") != -1
                        list = true
                    continue

                ## @TODO Manage aliases
                regex = /([^\s]+)[\s]+([^\s]+)/g
                result = regex.exec(line)

                if result and result[1]? and result[2]? and not result[3]?
                    @data.services[result[1]] = result[2]

        return @data.services

    ###*
     * Récupère les entités gérées par doctrine
     *
     * @param {bool} force Force refresh or not ?
     *
     * @return {Array}
    ###
    getEntities: (force) ->
        if Object.keys(@data.entities).length == 0 || force
            @data.entities = []

            lines = @execute("doctrine:mapping:info")

            if lines != [] and lines.result
                lines = lines.result.split("\n")

            list = false
            for line in lines
                if list == false
                    if line.indexOf("mapped entities") != -1
                        list = true
                    continue

                regex = /([^\s]+)[\s]+([^\s]+)/g
                result = regex.exec(line)

                if result and result[1]? and result[2]?
                    @data.entities.push result[2].replace(/\\/g, '').replace(/(Entity)/g, ':')

        return @data.entities

    ###*
     * Returns SF2 routes
     *
     * @param {bool} force Force refresh or not ?
     *
     * @return {array}
    ###
    getRoutes: (force) ->
        if @data.routes.length == 0 || force
            @data.routes = @execute("debug:router")

        return @data.routes

    ###*
     * Clear all cache of the plugin
    ###
    clearCache: () ->
        # Fill cache asynchronously
        (() =>
            @getEntities(true)
            @getServices(true)
            @getRoutes(true)
        )()

    ###*
     * Method called on plugin activation
    ###
    init: () ->
        atom.workspace.observeTextEditors (editor) =>
            editor.onDidSave((event) =>
                @clearCache()
            )

config = require '../config.coffee'

module.exports =
    phpProxy: null
    data:
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
     * @return {array}
    ###
    getServices: () ->
        if Object.keys(@data.services).length == 0
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
     * Returns SF2 routes
     *
     * @return {array}
    ###
    getRoutes: () ->
        if @data.routes.length == 0
            @data.routes = @execute("debug:router")

        return @data.routes

    ###*
     * Clear all cache of the plugin
    ###
    clearCache: () ->
        @data =
            services: {}
            routes: {}

    ###*
     * Method called on plugin activation
    ###
    init: () ->
        atom.workspace.observeTextEditors (editor) =>
            editor.onDidSave((event) =>
                @clearCache()
            )

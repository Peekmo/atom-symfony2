config = require '../config.coffee'

module.exports =
    phpProxy: null
    data:
        services: []
        routes: []

    ###*
     * Execute a symfony2 command
     * @param  {array} command
     * @return {mixed}
    ###
    execute: (command) ->
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
     * Retourne les services sf2 du projet
     *
     * @return {array}
    ###
    getServices: () ->
        if @data.services.length == 0
            @data.services = @execute("debug:container")

        return @data.services

    ###*
     * Retourne les services sf2 du projet
     *
     * @return {array}
    ###
    getRoutes: () ->
        if @data.routes.length == 0
            @data.routes = @execute("debug:router")

        return @data.routes

proxy = require './services/symfony2-proxy.coffee'

module.exports =
    classes: [
        "Symfony\\Component\\DependencyInjection\\ContainerInterface",
        "Symfony\\Component\\DependencyInjection\\Container"
    ]

    ###*
     * Returns a className if something is find for the given parent/method
     * @param  {string} parent Full parent method
     * @param  {string} method Full method (with args)
     * @return {string|null}
    ###
    autocomplete: (parent, method) ->
        # Get method name
        methodName = method.substring(0, method.indexOf("("))

        return unless @isService(parent, methodName)

        reg = /["(][\s]*[\'\"][\s]*([^\"\']+)[\s]*[\"\'][\s]*[")]/g
        result = reg.exec(method)

        return unless result?[1]?
        services = proxy.getServices()

        return unless services[result[1]]?
        return services[result[1]]

    ###*
     * Checks if we should returns completion on services
     * @param  {string}  parent
     * @param  {string}  methodName
     * @return {Boolean}
    ###
    isService: (parent, methodName) ->
        if methodName == "get" && (@classes.indexOf(parent) != -1 || parent.endsWith("Controller"))
            return true

        return false

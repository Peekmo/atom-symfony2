proxy = require './services/symfony2-proxy.coffee'

module.exports =
    config: [{
        type: 'string',
        classes: {
            "Symfony\Component\DependencyInjection\ContainerInterface": {
                "methods": "get",
                "data": () -> return proxy.getServices()
            },
            "Symfony\Component\DependencyInjection\Container": {
                "methods": "get",
                "data": () -> return proxy.getServices()
            }
        }
    }]

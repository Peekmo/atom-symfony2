config = require '../config.coffee'

module.exports =
    phpProxy: null

    providePhpProxy: (proxy) ->
        @phpProxy = proxy

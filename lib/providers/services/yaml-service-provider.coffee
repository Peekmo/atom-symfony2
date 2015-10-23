FileServiceProvider = require './file-service-provider.coffee'

module.exports =
class YamlServiceProvider extends FileServiceProvider
    selector: '.source.yaml'

    getSuggestions: ({editor, bufferPosition, scopeDescriptor, prefix}) ->
        @regex = /@([^\s]*)[\s]*/g

        return @fetchSuggestions({editor, bufferPosition, scopeDescriptor, prefix})

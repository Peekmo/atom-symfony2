FileClassProvider = require './file-class-provider.coffee'

module.exports =
class YamlClassProvider extends FileClassProvider
    selector: '.source.yaml'

    getSuggestions: ({editor, bufferPosition, scopeDescriptor, prefix}) ->
        @regex = /class[\s]*:[\s]*([a-zA-Z0-9_\\]*)/g

        return @fetchSuggestions({editor, bufferPosition, scopeDescriptor, prefix})

FileClassProvider = require './file-class-provider.coffee'

module.exports =
class XmlClassProvider extends FileClassProvider
    selector: '.text.xml'

    getSuggestions: ({editor, bufferPosition, scopeDescriptor, prefix}) ->
        @regex = /class[\s]*=[\s]*[\"]([^\"]*)[\"]*/g

        return @fetchSuggestions({editor, bufferPosition, scopeDescriptor, prefix})

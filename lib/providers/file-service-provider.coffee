proxy = require '../services/symfony2-proxy.coffee'
fuzzaldrin = require 'fuzzaldrin'

module.exports =
class FileServiceProvider
    selector: '.source.yaml'
    inclusionPriority: 1
    regex: /@([^\s]+)[^\s]/g

    getSuggestions: ({editor, bufferPosition, scopeDescriptor, prefix}) ->
        line = editor.getTextInRange([[bufferPosition.row, 0], bufferPosition])

        result = @regex.exec(line)
        console.log result
        return unless result?[1]?

        words = fuzzaldrin.filter proxy.getServices().keys(), result[1]
        console.log words
        suggestions = []
        for word in words
            suggestions.push
                text: proxy.getServices()[word]

        return suggestions

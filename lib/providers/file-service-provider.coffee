proxy = require '../services/symfony2-proxy.coffee'
fuzzaldrin = require 'fuzzaldrin'

module.exports =
class FileServiceProvider
    selector: '.source.yaml'
    inclusionPriority: 1

    getSuggestions: ({editor, bufferPosition, scopeDescriptor, prefix}) ->
        @regex = /@([^\s]*)[\s]*/g
        line = editor.getTextInRange([[bufferPosition.row, 0], bufferPosition])

        result = @regex.exec(line)
        return unless result?[1]?

        words = fuzzaldrin.filter Object.keys(proxy.getServices()), result[1]
        suggestions = []
        for word in words
            suggestions.push
                text: word
                leftLabel: proxy.getServices()[word].split("\\").pop()

        return suggestions

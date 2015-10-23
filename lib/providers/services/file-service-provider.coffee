proxy = require '../../services/symfony2-proxy.coffee'
fuzzaldrin = require 'fuzzaldrin'

module.exports =
class FileServiceProvider
    inclusionPriority: 1

    fetchSuggestions: ({editor, bufferPosition, scopeDescriptor, prefix}) ->
        line = editor.getTextInRange([[bufferPosition.row, 0], bufferPosition])

        result = @regex.exec(line)
        return unless result?[1]?

        words = fuzzaldrin.filter Object.keys(proxy.getServices()), result[1]
        suggestions = []
        for word in words
            suggestions.push
                text: word
                leftLabel: proxy.getServices()[word].split("\\").pop()
                prefix: result[1]

        return suggestions

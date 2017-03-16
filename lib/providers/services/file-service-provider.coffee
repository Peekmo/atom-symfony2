proxy = require '../../services/symfony2-proxy.coffee'
fuzzaldrin = require 'fuzzaldrin'

module.exports =
class FileServiceProvider
    inclusionPriority: 1

    fetchSuggestions: ({editor, bufferPosition, scopeDescriptor, prefix}) ->
        line = editor.getTextInRange([[bufferPosition.row, 0], bufferPosition])

        result = @regex.exec(line)
        return unless result?[1]?

        services = proxy.getServices()
        words = fuzzaldrin.filter Object.keys(services), result[1]
        suggestions = []
        for word in words
            suggestions.push
                text: word
                type: 'tag'
                leftLabel: services[word].split("\\").pop()

        return suggestions

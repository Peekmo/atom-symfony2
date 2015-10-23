proxy = require '../../services/symfony2-proxy.coffee'
fuzzaldrin = require 'fuzzaldrin'

module.exports =
class FileClassProvider
    inclusionPriority: 1

    fetchSuggestions: ({editor, bufferPosition, scopeDescriptor, prefix}) ->
        line = editor.getTextInRange([[bufferPosition.row, 0], bufferPosition])

        result = @regex.exec(line)
        return unless result?[1]?

        @classes = proxy.phpProxy.classes()

        words = fuzzaldrin.filter @classes.autocomplete, result[1]
        suggestions = []
        for word in words
            suggestions.push
                text: word
                type: 'class'

        return suggestions

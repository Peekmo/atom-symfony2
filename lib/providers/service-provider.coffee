parser = require '../services/php-parser.coffee'
fuzzaldrin = require 'fuzzaldrin'
proxy = require '../services/symfony2-proxy.coffee'
plugin = require '../plugin.coffee'

module.exports =
class ServiceProvider
    selector: '.source.php .string'
    inclusionPriority: 1
    disableForSelector: '.source.php .comment'


    getSuggestions: ({editor, bufferPosition, scopeDescriptor, prefix}) ->
        @regex = /->get[\s]*[(][\s]*[\"\']([^\"\']*)/g
        line = editor.getTextInRange([[bufferPosition.row, 0], bufferPosition])

        result = @regex.exec(line)
        return unless result?[1]?

        # Move the buffer position before the parenthese
        newPosition =
            row: bufferPosition.row
            column: bufferPosition.column

        while newPosition.column > 0
            newPosition.column--

            if line[newPosition.column + 1] == "("
                break

        elements = parser.parser.getStackClasses(editor, newPosition)
        return unless elements?

        className = parser.parser.parseElements(editor, newPosition, elements)
        return unless className?

        return unless plugin.isService(className, 'get')

        suggestions = []
        words = fuzzaldrin.filter Object.keys(proxy.getServices()), result[1]
        for word in words
            suggestions.push
                text: word
                type: 'tag'
                leftLabel: proxy.getServices()[word].split("\\").pop()
                prefix: result[1]

        return suggestions

# detection
hook global BufCreate .*[.]factor %{
    set-option buffer filetype factor
}

# initialisation
hook global WinSetOption filetype=factor %{
    require-module factor

    hook window ModeChange pop:insert:.* -group factor-trim-indent factor-trim-indent
    hook window InsertChar \n -group factor-indent factor-indent-on-new-line

    set-option buffer extra_word_chars '<' '>' '{' '}' '[' ']' '(' ')' '!' '$' '%' '&' '*' '+' '-' '.' '/' ':' '=' '?' '@' '^' '_' '~' '#' "'" '`'
}

hook -group factor-highlight global WinSetOption filetype=factor %{
    add-highlighter window/factor ref factor
    hook -once -always window WinSetOption filetype=*. %{ remove-highlighter window/factor }
}

# highlighters
provide-module factor %§
    add-highlighter shared/factor regions
    add-highlighter shared/factor/code default-region group
    add-highlighter shared/factor/comment region "(^|\s)! " $ fill comment
    add-highlighter shared/factor/stack-effect region -recurse "\(" "(?<!:)(^|(?<=\s)|(?<=shuffle)|(?<=execute)|(?<=eval)|(?<=call))\((?=\s)" "\s\)(?=\s)" fill attribute

    # string
    add-highlighter shared/factor/string region '"' (?<!\\)(\\\\)*" group
    add-highlighter shared/factor/string/ fill string
    add-highlighter shared/factor/string/ regex '(\\0|\\b|\\f|\\n|\\r|\\s|\\t|\\v|\\\\|\\")' 0:meta
    add-highlighter shared/factor/string/ regex "(\\x[0-9a-fA-F]{2})" 0:meta
    add-highlighter shared/factor/string/ regex "(\\u[0-9a-fA-F]{6})" 0:meta
    add-highlighter shared/factor/string/ regex "(\\u\{[0-9a-fA-F]{2}\})" 0:meta
    add-highlighter shared/factor/string/ regex "(\\u\{[a-zA-z-]+\})" 0:meta

    # imports
    add-highlighter shared/factor/code/ regex "\b(USING): .*?(?= ;)" 0:module
    add-highlighter shared/factor/code/ regex "\b(USE|IN): .*?$" 0:module
    add-highlighter shared/factor/code/ regex "\b(USING|USE|IN): " 0:meta

    # syntax
    add-highlighter shared/factor/code/ regex "\b[A-Z0-9~!@#$^&*%%]+::? " 0:meta
    add-highlighter shared/factor/code/ regex "^::? " 0:meta
    add-highlighter shared/factor/code/ regex "(^|\s)<PRIVATE(?=\s)" 0:meta
    add-highlighter shared/factor/code/ regex "\bPRIVATE>(?=\s)" 0:meta
    add-highlighter shared/factor/code/ regex "\bCHAR: [^\s](?=\s)" 0:meta

    # functions
    add-highlighter shared/factor/code/ regex "^(?:(?:IDENTITY-)?MEMO|MACRO|GENERIC#?)?::?\s+([^\s]+)" 1:function
    add-highlighter shared/factor/code/ regex "^M::?\s+([^\s]+)\s+([^\s]+)(?=\s)" 1:type 2:function

    # types
    add-highlighter shared/factor/code/ regex "^(?:MIXIN|UNION|TUPLE|ERROR):\s+([^\s]+)" 1:type
    add-highlighter shared/factor/code/ regex "^INSTANCE::?\s+([^\s]+)\s+([^\s]+)(?=\s)" 1:type 2:type
    add-highlighter shared/factor/code/ regex "^C:\s+([^\s]+)\s+([^\s]+)(?=\s)" 1:function 2:type

    # numbers
    add-highlighter shared/factor/code/ regex "\b(t|f)\b" 0:value
    add-highlighter shared/factor/code/ regex "(?<=\s)-?0b[0-1]+(?=\s)" 0:value
    add-highlighter shared/factor/code/ regex "(?<=\s)-?0o[0-7]+(?=\s)" 0:value
    add-highlighter shared/factor/code/ regex "(?<=\s)-?0x[0-9a-fA-F]+(?=\s)" 0:value
    add-highlighter shared/factor/code/ regex "(?<=\s)-?[0-9]+\.[0-9]+([eE][-+]?[0-9]+)?(?=\s)" 0:value
    add-highlighter shared/factor/code/ regex "(?<=\s)-?[0-9]+([eE][-+]?[0-9]+)?(?=\s)" 0:value

    # brackets
    add-highlighter shared/factor/code/ regex "(^|\s)(\[|\]|'\[)(?=\s)" 0:operator

    # commands
    define-command -hidden factor-indent-on-new-line %¹ evaluate-commands -draft -itersel %@
        # preserve indentation on new lines
        try %{ execute-keys -draft <semicolon> K <a-&> }
        # indent after lines ending with { or ( or [
        try %& execute-keys -draft kx <a-k> [[{(]\h*$ <ret> j <a-gt> &
        # cleanup trailing white spaces on the previous line
        execute-keys -draft k :factor-trim-indent <ret>
    @ ¹

    define-command -hidden factor-trim-indent %{ evaluate-commands -draft -itersel %{
        # remove trailing whitespace
        try %{ execute-keys -draft x s \h+$ <ret> d }
    } }
§

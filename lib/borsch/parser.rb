require 'parslet'

module Borsch
  # Psrses Io's source files
  # (Grammar)[http://www.iolanguage.com/scm/io/docs/IoGuide.html#Appendix-Grammar]
  class Parser < Parslet::Parser
    rule :space do
      str(' ')
    end

    rule :space? do
      space.maybe
    end

    # Characters
    rule :comma do
      str(',')
    end

    rule :open do
      str('(') | str('[') | str('{')
    end

    rule :close do
      str(')') | str(']') | str('}')
    end

    rule :letter do
      match['a-zA-Z']
    end

    rule :digit do
      match['0-9']
    end

    rule :digits do
      digit.repeat(1)
    end

    # Numbers
    rule :number do
      hex_number | decimal
    end

    rule :decimal do
      (
        digits >> (str('.') >> digits).maybe |
        str('.') >> digits
      ) >> (str('e') >> str('-').maybe >> digits).maybe
    end

    rule :hex_digit do
      match['a-fA-F']
    end

    rule :hex_number do
      str('0') >> (str('x') | str('X')) >> (digit | hex_digit).repeat(1)
    end

    # Comments
    rule :slash_star_comment do
      str('/*') >> (str('*/').absnt? >> any).repeat >> str('*/')
    end

    rule :slash_slash_comment do
      str('//') >> (str("\n").absnt? >> any).repeat >> str("\n")
    end

    rule :pound_comment do
      str('#') >> (str("\n").absnt? >> any).repeat >> str("\n")
    end

    rule :comment do
      slash_slash_comment | slash_star_comment | pound_comment
    end

    # Spans
    rule :separator do
      (space | str("\f") | str("\t") | str("\v")).repeat(1)
    end
    rule :separator? do
      separator.maybe
    end

    rule :whitespace do
      (space | str("\f") | str("\t") | str("\v") | str("\r") | str("\n")).repeat(1)
    end

    rule :terminator do
      ((separator? >> str(';')) | str("\n") | (str("\r") >> separator?)).repeat(1)
    end

    rule :sctpad do
      (separator | comment | terminator).repeat(1)
    end

    rule :scpad do
      (separator | comment).repeat(1)
    end

    rule :wcpad do
      (whitespace | comment).repeat(1)
    end

    # Quotes
    rule :mono_quote do
      str('"') >> (str('\"') | str('"').absnt? >> any).repeat >> str('"')
    end

    rule :tri_quote do
      str('"""') >> (str('"""').absnt? >> any).repeat >> str('"""')
    end

    rule :quote do
      tri_quote | mono_quote
    end

    # Symbols
    rule :operator do
      (
        str(":") | str(".") | str("'") | str("~") | str("!") |
        str("@") | str("$") | str("%") | str("^") | str("&") |
        str("*") | str("-") | str("+") | str("/") | str("=") |
        str("{") | str("}") | str("[") | str("]") | str("|") |
        str("\\") | str("<") | str(">") | str("?")
      ).repeat(1)
    end

    rule :identifier do
      (letter | digit | str('_')).repeat(1)
    end

    rule :symbol do
      identifier | number | operator | quote
    end

    # Expression
    rule :expression do
      (message | sctpad).repeat
    end

    rule :message do
      wcpad.maybe >> symbol >> scpad.maybe >> arguments.maybe
    end

    rule :arguments do
      open >> (argument >> ((comma >> argument).repeat).maybe).maybe >> close
    end

    rule :argument do
      wcpad.maybe >> expression >> wcpad.maybe
    end

    root :expression
  end
end

# lib/rouge/lexers/solidity.rb
# 출처: https://github.com/rouge-ruby/rouge/pull/1232 (참고 기반)

require 'rouge'

module Rouge
  module Lexers
    class Solidity < RegexLexer
      title "Solidity"
      desc "The Solidity programming language (ethereum.org)"
      tag 'solidity'
      filenames '*.sol'
      mimetypes 'text/x-solidity'

      keywords = %w(
        contract library interface function modifier
        event enum struct mapping
        if else for while do break continue return
        import using as new delete require revert assert
        try catch throw emit
      )

      types = %w(
        address bool string var
        int uint int8 uint8 int16 uint16 int32 uint32 int64 uint64 int128 uint128 int256 uint256
        byte bytes bytes1 bytes2 bytes32
      )

      constants = %w(true false this super msg tx block now)

      state :root do
        rule %r/\s+/m, Text::Whitespace
        rule %r(//.*?$), Comment::Single
        rule %r(/\*.*?\*/), Comment::Multiline

        rule %r/([a-zA-Z_][\w]*)/ do |m|
          if keywords.include? m[0]
            token Keyword
          elsif types.include? m[0]
            token Keyword::Type
          elsif constants.include? m[0]
            token Name::Builtin
          else
            token Name
          end
        end

        rule %r/([0-9]+(\.[0-9]+)?)/, Num
        rule %r/"(\\.|[^"])*"/, Str::Double
        rule %r/'(\\.|[^'])*'/, Str::Single

        rule %r/[{}()\[\];,]/, Punctuation
        rule %r/\./, Punctuation
        rule %r([=+\-*/%&|^!<>]=?|~), Operator
      end
    end
  end
end
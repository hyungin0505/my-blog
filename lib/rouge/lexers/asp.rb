# lib/rouge/lexers/asp.rb

require 'rouge'

module Rouge
  module Lexers
    class ASP < RegexLexer
      title "ASP"
      desc "Classic ASP using VBScript (vbscript.dll)"
      tag 'asp'
      filenames '*.asp'
      mimetypes 'text/x-asp'

      keywords = %w(
        If Then Else ElseIf End Select Case While Wend For Each In Next Do Loop Until
        Dim Set Let Get Const Call Function Sub Exit With Not And Or Xor
      )

      builtins = %w(
        Response Request Server Application Session Eval Execute ExecuteGlobal MsgBox
        CInt CLng CDbl CStr CSng CBool DateTime Date Now Timer Weekday
        LCase UCase Trim Len Mid Left Right InStr Replace Split Join
        Abs Sqr Randomize Rnd Int Fix FormatCurrency FormatDateTime FormatNumber
      )

      constants = %w(True False Nothing Null Empty)

      state :root do
        rule %r/\s+/m, Text::Whitespace
        rule %r/'.*?$/, Comment::Single
        rule %r/Rem .+$/, Comment::Single

        rule %r/[a-zA-Z_]\w*/ do |m|
          if keywords.include? m[0]
            token Keyword
          elsif builtins.include? m[0]
            token Name::Builtin
          elsif constants.include? m[0]
            token Keyword::Constant
          else
            token Name
          end
        end

        rule %r/\d+(\.\d+)?/, Num
        rule %r/".*?"/, Str::Double

        rule %r/[(){}\[\],.:]/, Punctuation
        rule %r([+\-*/&%^=<>\|]), Operator
      end
    end
  end
end
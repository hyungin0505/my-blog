require 'rouge'

module Rouge
  module Lexers
    class Smali < RegexLexer
      title "Smali"
      desc "Smali (Android Dalvik assembly)"
      tag 'smali'
      filenames '*.smali'
      mimetypes 'text/x-smali'

      keywords = %w(
        move move-result move-reulst-object move-exception return return-void return-wide return-object
        const const/4 const/16 const/high16 const-wide const-string const-class
        new-instance new-array filled-new-array check-cast instance-of
        iget iget-wide iget-object iput iput-wide iput-object
        sget sget-wide sget-object sput sput-wide sput-object
        if-eq if-ne if-lt if-ge if-gt if-le goto packed-switch sparse-switch
        cmp-long cmpg-double cmpl-double cmpg-float cmpl-float
        invoke-virtual invoke-super invoke-direct invoke-static invoke-interface
        throw monitor-enter monitor-exit
        add-int sub-int mul-int div-int rem-int and-int or-int xor-int shl-int shr-int ushr-int
      )

      directives = %w(
        .class .super .implements .source
        .field .end field
        .method .end method
        .registers .locals
        .line .prologue .epilogue
        .annotation .end annotation
      )

      registers = %w(
        v0 v1 v2 v3 v4 v5 v6 v7 v8 v9
        p0 p1 p2 p3 p4 p5 p6 p7 p8 p9
      )

      state :root do
        rule %r/\s+/m, Text::Whitespace
        rule %r/#.*?$/, Comment::Single

        # Numbers
        rule %r/\b0x[0-9a-fA-F]+\b/, Num::Hex
        rule %r/\b\d+\b/, Num::Integer

        # Strings
        rule %r/"(\\.|[^"])*"/, Str::Double

        # Identifiers
        rule %r/[a-zA-Z0-9_.$\/>\-]+/ do |m|
          if keywords.include? m[0]
            token Keyword
          elsif directives.include? m[0]
            token Keyword::Declaration
          elsif registers.include? m[0]
            token Name::Builtin
          else
            token Name
          end
        end

        # Punctuation & operators
        rule %r/[\[\]\(\),:={}<>]/, Punctuation
      end
    end
  end
end
# lib/rouge/lexers/assembly.rb

require 'rouge'

module Rouge
  module Lexers
    class Assembly < RegexLexer
      title "Assembly"
      desc "Generic Assembly language"
      tag 'asm'
      filenames '*.asm', '*.s'
      mimetypes 'text/x-asm'

      keywords = %w(
        mov push pop lea
        add sub mul imul div idiv
        inc dec
        and or xor not shl shr
        jmp je jne jz jnz ja jae jb jbe jg jge jl jle
        call ret nop int syscall
        cmp test
      )

      registers = %w(
        eax ebx ecx edx esi edi ebp esp
        ax bx cx dx si di bp sp
        al ah bl bh cl ch dl dh
        rax rbx rcx rdx rsi rdi rbp rsp
        r8 r9 r10 r11 r12 r13 r14 r15
        rip eip ip
      )

      directives = %w(
        section global extern
        db dw dd dq dt
        resb resw resd resq
      )

      state :root do
        rule %r/\s+/m, Text::Whitespace
        rule %r(;.*?$), Comment::Single
        rule %r(/\*.*?\*/), Comment::Multiline

        # Disassembly line addresses (e.g., 0045035E)
        rule %r/^\s*[0-9A-F]{6,8}\b/, Num::Hex

        # Instruction bytes (e.g., 681C044500)
        rule %r/\b[0-9A-F]{2,}\b/, Num::Hex

        # Numbers
        rule %r/\b0x[0-9a-fA-F]+\b/, Num::Hex
        rule %r/\b\$[0-9A-Fa-f]+\b/, Num::Hex   # e.g. $0045041C (Intel/NASM style)
        rule %r/\b[0-9]+\b/, Num::Integer

        # Strings / chars
        rule %r/"(\\.|[^"])*"/, Str::Double
        rule %r/'(\\.|[^'])*'/, Str::Single

        # Identifiers
        rule %r/[a-zA-Z_.$][\w$.]*/ do |m|
          if keywords.include? m[0].downcase
            token Keyword
          elsif registers.include? m[0].downcase
            token Name::Builtin
          elsif directives.include? m[0].downcase
            token Keyword::Declaration
          else
            token Name
          end
        end

        # Operators & punctuation (수정된 안전 버전)
        rule %r/[\[\]\(\),:\+\-\*\/%&\|\^<>=!]/, Operator
        rule %r/:/, Punctuation
      end
    end
  end
end
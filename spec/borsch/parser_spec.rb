require 'spec_helper'

describe Borsch::Parser do
  describe 'Characters' do
    context 'Comma' do
      subject { Borsch::Parser.new.comma }

      it { should parse(',') }
    end
    context 'Open' do
      subject { Borsch::Parser.new.open }

      it { should parse('(') }
      it { should parse('[') }
      it { should parse('{') }
    end
    context 'Close' do
      subject { Borsch::Parser.new.close }

      it { should parse(')') }
      it { should parse(']') }
      it { should parse('}') }
    end
    context 'letter' do
      subject { Borsch::Parser.new.letter }

      it { should parse('a') }
      it { should parse('A') }
    end
    context 'digit' do
      subject { Borsch::Parser.new.digit }

      it { should parse('1') }
    end
    context 'digits' do
      subject { Borsch::Parser.new.digits }

      it { should parse('123') }
    end
  end

  describe 'Numbers' do
    describe 'number' do
      subject { Borsch::Parser.new.number }

      it { should parse('123') }
      it { should parse('123.456') }
      it { should parse('0.456') }
      it { should parse('.456') }
      it { should parse('123e-4') }
      it { should parse('123e4') }
      it { should parse('123.456e-7') }
      it { should parse('123.456e7') }
      it { should parse('0x0') }
      it { should parse('0x0F') }
      it { should parse('0XeE') }
    end

    describe 'decimal' do
      subject { Borsch::Parser.new.number }

      it { should parse('123') }
      it { should parse('123.456') }
      it { should parse('0.456') }
      it { should parse('.456') }
      it { should parse('123e-4') }
      it { should parse('123e4') }
      it { should parse('123.456e-7') }
      it { should parse('123.456e7') }
    end

    describe 'hex number' do
      subject { Borsch::Parser.new.hex_number }

      it { should parse('0x0') }
      it { should parse('0x0F') }
      it { should parse('0XeE') }
    end
  end

  describe 'Comments' do
    context '/**/' do
      subject { Borsch::Parser.new.slash_star_comment }

      it { should parse("/* multiline\ncomment */") }
    end

    context '//' do
      subject { Borsch::Parser.new.slash_slash_comment }

      it { should parse("// comment\n") }
    end

    context '#' do
      subject { Borsch::Parser.new.pound_comment }

      it { should parse("# comment\n") }
    end

    context 'comment' do
      subject { Borsch::Parser.new.comment }

      it { should parse("/* multiline\ncomment */") }
      it { should parse("// comment\n") }
      it { should parse("# comment\n") }
    end
  end

  describe 'Spans' do
    context 'separator' do
      subject { Borsch::Parser.new.separator }

      [' ', "\f", "\t", "\v"].each do |sep|
        it { should parse(sep) }
      end
    end

    context 'whitespace' do
      subject { Borsch::Parser.new.whitespace }

      [' ', "\f", "\t", "\v", "\r", "\n"].each do |sep|
        it { should parse(sep) }
      end
    end

    context 'terminator' do
      subject { Borsch::Parser.new.terminator }

      it { should parse('  ;') }
      it { should parse("\n") }
      it { should parse("\r") }
    end

    context 'sctpad' do
      subject { Borsch::Parser.new.sctpad }

      it { should parse(" \r\n\t\v\f ;\n/* comment\none more*/ ") }
    end

    context 'scpad' do
      subject { Borsch::Parser.new.scpad }

      it { should parse(" \t\v\f # comment\n ") }
    end

    context 'wcad' do
      subject { Borsch::Parser.new.wcpad }

      it { should parse(" \t\v\f // comment\n ") }
    end
  end

  describe 'Quotes' do
    context 'mono_quote' do
      subject { Borsch::Parser.new.mono_quote }

      it { should parse(%|"string"|) }
      it { should parse(%|"string\\"sub string\\""|) }
    end

    context 'tri_quote' do
      subject { Borsch::Parser.new.tri_quote }

      it { should parse(%|"""string"""|) }
    end

    context 'quote' do
      subject { Borsch::Parser.new.quote }

      it { should parse(%|"string"|) }
      it { should parse(%|"string\\"sub string\\""|) }
      it { should parse(%|"""string"""|) }
    end
  end

  describe 'Symbols' do
    context 'operator' do
      subject { Borsch::Parser.new.operator }

      [":", ".", "'", "~", "!", "@", "$", "%", "^",
        "&", "*", "-", "+", "/", "=", "{", "}", "[",
        "]", "|", "\\", "<", ">", "?"].each do |operator|
        
        it { should parse(operator) }
      end
    end

    context 'identifier' do
      subject { Borsch::Parser.new.identifier }

      it { should parse('1') }
      it { should parse('a') }
      it { should parse('_') }
      it { should parse('_abc1') }
      it { should parse('_123abcz') }
      it { should parse('underscored_text') }
    end

    context 'symbol' do
      subject { Borsch::Parser.new.symbol }

      it { should parse('_abc_123') }
      it { should parse('+') }
      it { should parse(%|"a"|) }
    end
  end

  describe 'Messages' do
    context 'expression' do
      subject { Borsch::Parser.new.expression }

      it do should parse(<<-IO)
        Account := Object clone

        Account balance := 0
        Account deposit := method(amount,
          balance = balance + amount
        )

        account := Account clone
        account deposit(10.00)
        account balance println
IO
      end
    end
  end
end

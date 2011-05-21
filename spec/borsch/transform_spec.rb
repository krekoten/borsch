require 'spec_helper'

describe Borsch::Transform do
  describe 'Numbers' do
    subject { Borsch::Transform.new }

    it { should transform('42').to([Borsch::Ast::Number.new(42)]) }
  end
end

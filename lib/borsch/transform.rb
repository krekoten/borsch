require 'parslet'

module Borsch
  class Transform < Parslet::Transform
    rule :decimal => simple(:number) do
      Borsch::Ast::Number.new(number.to_i)
    end
  end
end

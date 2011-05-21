module Borsch
  module Ast
    class Number
      attr_accessor :value
      def initialize(value)
        @value = value
      end
      def ==(other)
        self.class == other.class &&
        self.value == other.value
      end
    end
  end
end

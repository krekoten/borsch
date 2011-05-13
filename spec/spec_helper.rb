require 'borsch'

RSpec::Matchers.define :parse do |string_for_parsing|
  match do |parser|
    begin
      parser.parse(string_for_parsing)
      true
    rescue Parslet::ParseFailed, NotImplementedError => e
      @error = parser.error_tree
      false
    end
  end

  failure_message_for_should do |parser|
    "expected #{parser} to parse #{string_for_parsing}\n#{@error}"
  end

  failure_message_for_should_not do |parser|
    "didn't expect #{parser} to parse #{string_for_parsing}"
  end
end
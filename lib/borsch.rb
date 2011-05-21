$: << File.expand_path('..', __FILE__)

module Borsch
  autoload :Parser,     'borsch/parser'
  autoload :Transform,  'borsch/transform'
end

require 'borsch/ast'

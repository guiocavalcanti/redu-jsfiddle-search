require 'lib/hypertext'

class Submission
  include Hypertext
  attr_accessor :connection, :representation, :spaces

  def initialize(options={})
    @representation = options[:representation]
  end

  def method_missing(method, *args)
    raise NoMethodError.new("no method #{method}") unless representation.has_key? method.to_s
    representation.fetch(method.to_s)
  end
end

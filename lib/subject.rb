require 'lib/hypertext'

class Subject
  include Hypertext
  attr_accessor :connection, :representation

  def initialize(opts={})
    @representation = opts[:representation]
    @subject_id = @representation[:id] || opts[:subject]
    @connection = opts[:connection]
  end

  def submissions
    pp JSON.parse(connection.get("http://www.redu.com.br/api/subjects/2016/lectures").body)
  end

  def representation
    @representation ||= JSON.parse connection.get("subjects/#{@subject_id}").body
  end
end



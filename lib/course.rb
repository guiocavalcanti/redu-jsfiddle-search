require 'lib/hypertext'
require 'lib/space'

class Course
  include Hypertext
  attr_accessor :connection, :representation

  def initialize(opts={})
    @connection = opts[:connection]
    @course_id = opts[:course]
  end

  def spaces
    spaces_url = link('spaces')
    @spaces ||= JSON.parse(connection.get(spaces_url).body).collect do |s|
      Space.new(:representation => s, :connection => connection)
    end
  end

  def students
    users_url = link('enrollments')
    @users ||= JSON.parse connection.get(users_url).body
    @users.select { |s| s['state'] == 'approved' }
  end

  def representation
    @representation ||= JSON.parse connection.get("courses/#{@course_id}").body
  end
end

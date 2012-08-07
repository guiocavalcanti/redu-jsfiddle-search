require 'lib/hypertext'
require 'lib/subject'
require 'lib/submission'

class Space
  include Hypertext
  attr_accessor :connection, :representation

  def initialize(opts={})
    @representation = opts[:representation]
    @space_id = @representation[:id] || opts[:space]
    @connection = opts[:connection]
  end

  def subjects
    subjects_url = link('subjects')
    @subjects ||= JSON.parse(connection.get(subjects_url).body).collect do |s|
      Subject.new(:representation => s, :connection => connection)
    end
  end

  def submissions
    timeline_url = link('timeline')
    posts = []

    1.upto(1.0/0.0) do |page|
      response = connection.get(timeline_url) do |r|
        r.params = { :page => page }
      end
      entity = JSON.parse(response.body)
      entity.empty? ? break : posts << entity
    end

    posts.flatten!

    @submissions ||= posts.select { |s| s['type'] == 'Activity' }.
      select { |s| s['text'] =~ /jsfiddle/ }.collect do |submission|
      Submission.new(:representation => submission)
    end
  end

  def representation
    @representation ||= JSON.parse connection.get("spaces/#{@space_id}").body
  end
end


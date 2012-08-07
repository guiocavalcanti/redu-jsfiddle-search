module Hypertext
  def link(rel)
    item = representation['links'].select { |l| l['rel'] == rel }.first
    item['href']
  end
end

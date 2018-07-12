require 'wombat'
require 'pry'

review_data = WombatScraper.new.crawl

review_data['the_articles'].each do |review|
  # if article is empty or it is nil, jump to the next
  next if review['article'].nil? || review['article'].empty?

  tentative_title = review['article'][0]['titles']
  binding.pry

  next if tentative_title.empty? || tentative_title.nil?

# TODO: Need to simplfy way that title is set, consider using .first for an array to get first occuring title else if the first element is not the one we want (why??), we will use the long method

  if tentative_title.nil? || tentative_title.length.nil?
    title = 'untitled'
  else
    title = tentative_title.group_by(&:itself).values.max_by(&:size).first
  end

  Game.create!(game_title: title) if Game.find_by(game_title: title).nil?

  # The content is broken up into separate index based on paragraphs. Joining them together at a line break
  content = review['article'][0]['content']
  complete_content = content.join("\n")

  begin
    puts "creating review #{tentative_title}"
    Review.create!(title: title, content: complete_content)
  rescue
    binding.pry
  end
end

require 'digg'

class Dig
  attr_accessor :topic
  attr_accessor :num_of_stories

  def initialize(topic = 'apple')
    @topic = topic
    @num_of_stories = 10
    @digg = Digg.new
  end

  def get_top_upcoming
    @digg.stories("stories/topic/#{@topic}/upcoming", :sort => 'digg_count-desc', :count => @num_of_stories)
  end

  def get_diggs story
    diggs = []
    (story.diggs.to_i / 10 + 1).times do | i |
      diggs <<  @digg.events("/story/#{story.id}/diggs", :count => 10, :offset => i)
    end
    diggs.flatten
  end

  def get_top number=10
    hUsers = {}
    self.get_top_upcoming.each do | story |
      diggs = self.get_diggs story
      diggs.each do | digg |
        unless hUsers.has_key?(digg.user)
          hUsers[digg.user] = 0
        end
        hUsers[digg.user] += 1
      end
    end
    
    shUsers = hUsers.sort { |a, b| b[1] <=> a[1] }
    shUsers.first(number)
  end

end

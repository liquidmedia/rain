module Rain
  class Drop < ActiveRecord::Base
    scope :drops, -> { where('type != ?', 'Rain::Cloud') }
    scope :clouds, -> { where('type = ?', 'Rain::Cloud') }

    validates_presence_of :name
    validates_uniqueness_of :name, :scope => :type

    alias :uri :to_s
    
    def uri=(new_uri)
      self.name = new_uri
    end
  
    def to_s
      name
    end
  end
end
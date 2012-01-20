module Rain
  class Rapid < ActiveRecord::Base
    has_many :rapids, :class_name => "Rain::Rapid", :foreign_key => "parent_id"
    belongs_to :rapid, :foreign_key => "id", :class_name => "Rain::Rapid"

    scope :root, where(:parent_id => nil).order(:position)
  
    def to_s
      name
    end
  end
end
class Rain::AdminController < ApplicationController
  before_filter :require_admin
  before_filter :rain_crumbs
  
  def index
  end
  
  def drops
    @drops = Rain::Drop.where(:type => nil).order(:name)
    @clouds = Rain::Cloud.order(:name)
  end
  
  def rapids
    @rapids = Rain::Rapid.root
  end

  private

  def rain_crumbs
    add_crumb 'Admin', '/admin'
    if action_name == 'index'
      add_crumb 'Rain'
    else
      add_crumb 'Rain', :action => :index
      add_crumb action_name.titleize
    end
  end
end
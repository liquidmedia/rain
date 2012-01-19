class Rain::DropsController < ApplicationController
  include RainCmsHelper
  
  before_filter :drop,:except=>[:create]
  before_filter :track_referrer, :only=>[:show]
  before_filter :check_permissions, :except => [:show, :cloud]
  
  def check_permissions    
    return true if can_edit_drop?(params[:id].to_i)
    return require_admin
  end
  
  
  def new
    render :layout=>false
  end
  
  def edit
    render :layout=>false
  end
  
  def show
    render :new, :layout => false and return if @drop.new_record?
    render :edit, :layout => false
  end
  
  def create
    @drop = Rain::Drop.new(params[:rain_drop])
    respond_to do |format|
      if @drop.save
        flash[:success]= t(:drop_created)
        format.html { redirect_to(session[:rain_referrer]) }
        format.xml  { render :xml => @drop, :status => :created, :location => @drop }
        format.js   { render 'update', :layout=>false}
      else
        format.html { render :new }
        format.xml  { render :xml => @drop.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def update
    respond_to do |format|
      if @drop.update_attributes(params[:rain_drop])
        flash[:success] = t(:drop_updated)
        format.html { redirect_to(rain_cloud_path(@drop.name)) }
        format.xml  { head :ok }
        format.js
      else
        format.html { render :action => "edit", :layout=>false }
        format.xml  { render :xml => @drop.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @drop.delete
    
    redirect_to :back
  end
    
  def history
    @versions = drop.versions
  end
  
  def revert_to
    flash[:notice] = "Reverted to version #{params[:version]}"
    drop.revert_to!(params[:version].to_i)
    redirect_to :back
  end
  
  def previous
    @drop.revert_to!(@drop.version - 1)
    redirect_to :back
  end
  
  def next
    @drop.revert_to!(@drop.version + 1)
    redirect_to :back
  end
  
  private  
    def drop
      name = (params[:id].is_a?(Array) ? params[:id].join('/') : params[:id]).downcase
      if name.to_i > 0
        @drop ||= Rain::Drop.find(params[:id])
      else        
        @drop ||= Rain::Drop.find_by_name(name) || Rain::Drop.create(:name=>name)
      end    
    end
        
    def track_referrer
      session[:rain_referrer] = request.referer
    end
end
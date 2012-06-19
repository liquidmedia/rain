class Rain::DropsController < ApplicationController
  include RainCmsHelper
  
  before_filter :drop, :except => [:create]
  before_filter :track_referrer, :only => [:cloud]
  before_filter :check_permissions, :except => [:cloud]
  skip_before_filter :authenticate, :only => [:cloud]
  before_filter :authenticate_lite, :only => [:cloud]
  
  def check_permissions    
    return true if can_edit_drop?(params[:id].to_i)
    return require_admin
  end
  
  def new
    render 'rain/drops/new', :layout=>false
  end
  
  def edit
    render 'rain/drops/edit', :layout=>false
  end
  
  def show
    render 'rain/drops/new', :layout => false and return if @drop.new_record?
    render 'rain/drops/edit', :layout => false
  end
  
  def create
    if params[:rain_drop]
      @drop = Rain::Drop.new(params[:rain_drop])
    else
      @drop = Rain::Cloud.new(params[:rain_cloud])
    end
    respond_to do |format|
      if @drop.save
        flash[:success]= t(:drop_created)
        format.html { redirect_to(session[:rain_referrer]) }
        format.xml  { render :xml => @drop, :status => :created, :location => @drop }
        format.js   { render 'rain/drops/update', :layout=>false}
      else
        format.html { render :new }
        format.xml  { render :xml => @drop.errors, :status => :unprocessable_entity }
        format.js   { render :text =>@drop.errors.inspect}
      end
    end
  end
  
  def update
    respond_to do |format|
      if @drop.update_attributes(params[:rain_drop] || params[:rain_cloud])
        flash[:success] = t(:drop_updated)
        format.html { redirect_to "/" }
        format.xml  { head :ok }
        format.js   { render 'rain/drops/update', :layout=>false}
      else
        format.html { render :action => "edit", :layout=>false }
        format.xml  { render :xml => @drop.errors, :status => :unprocessable_entity }
        format.js   { render :text =>@drop.errors.inspect}
      end
    end
  end
  
  def destroy
    @drop.delete
    
    redirect_to rain_admin_drops_path
  end
    
  def history
    @versions = @drop.versions
  end
  
  def revert_to
    flash[:notice] = "Reverted to version #{params[:version]}"
    @drop.revert_to!(params[:version].to_i)
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

  def cloud
    raise ActionController::RoutingError.new("Rain was unable to find #{request.path}") unless request.format == 'text/html'
    build_crumbs

    if (@drop.admin_only? && !is_admin?) || (@drop.user_only? && !logged_in?)
      flash[:error] = "You are not authorized to view this page"
      redirect_to '/'
    end

    if @drop.new_record? && !is_admin?
      raise ActionController::RoutingError.new("Rain was unable to find #{request.path}")
    end
    render 'rain/clouds/_cloud', :locals=>{:cloud=>@drop}, :layout => request.xhr? ? '' : @drop.layout
  end
  
  private  
    def drop
      if params[:id].match(/\/edit$/)
        params[:id] = params[:id][0..-6]
        force_edit = true
      end

      name = (params[:id].is_a?(Array) ? params[:id].join('/') : params[:id]).downcase
      if name.to_i > 0
        @drop ||= Rain::Drop.find(params[:id])
      else
        if action_name == 'cloud'
          @drop ||= Rain::Cloud.find_by_name(name) || Rain::Cloud.new(:name=>name)
        else
          @drop ||= Rain::Drop.find_by_name(name) || Rain::Drop.create(:name=>name)
        end
      end

      return edit if force_edit
    end
        
    def track_referrer
      session[:rain_referrer] = request.referer
    end

    def build_crumbs
      uri = request.env['REQUEST_URI']
      search_path = ""
      crumbs = uri.split('/').reject{|u| u.blank?}
      crumbs.pop

      if crumbs.length
        crumbs.each do |c|
          if cloud = Rain::Cloud.find_by_name(search_path + c)
            add_crumb cloud.title, "/#{cloud.name}"
            search_path += "#{c}/"
          end
        end
      end
      add_crumb @drop.title
    end
end
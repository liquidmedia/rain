class Rain::RapidsController < ApplicationController
  before_filter :require_admin
  
  def new
    @rapid = Rain::Rapid.new
  end
  
  def edit
    @rapid = Rain::Rapid.find(params[:id])
    
  end
  
  def create
     @rapid = Rain::Rapid.new(params[:rain_rapid])
     respond_to do |format|
       if @rapid.save
         flash[:success]= t(:drop_created)
         format.html { redirect_to :rain_admin_rapids}
         format.xml  { render :xml => @rapid, :status => :created, :location => @drop }
       else
         format.html { render :new }
         format.xml  { render :xml => @rapid.errors, :status => :unprocessable_entity }
       end
     end
   end
   
   def update
     @rapid = Rain::Rapid.find(params[:id])
     
     respond_to do |format|
       if @rapid.update_attributes(params[:rain_rapid])
         flash[:success] = t(:rapid_updated)
         format.html { redirect_to :rain_admin_rapids}
         format.xml  { head :ok }
       else
         format.html { render :action => "edit", :layout=>false }
         format.xml  { render :xml => @rapid.errors, :status => :unprocessable_entity }
       end
     end
   end
   
   def destroy
     @rapid = Rain::Rapid.find(params[:id])
     @rapid.delete

     redirect_to :rain_admin_rapids
   end
end
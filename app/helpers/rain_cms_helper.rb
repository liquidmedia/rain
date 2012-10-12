module RainCmsHelper
  def can_edit_drop?(drop_id)    
    is_admin? ||
      (@drop && session[:editable_drop_ids] && session[:editable_drop_ids].include?(@drop.id)) ||
      (session[:editable_drop_ids] && session[:editable_drop_ids].include?(drop_id))
  end
  
  def rain_drop(name="#{controller_name}_#{action_name}", options = {})
    pure_name = filter_drop(name)
    drop = Rain::Drop.find_or_create_by_name(pure_name)
    
    session[:editable_drop_ids] = [] unless session[:editable_drop_ids]
    session[:editable_drop_ids] << drop.id if is_admin? || options[:admin_override]
    session[:editable_drop_ids].uniq!
    
    if drop.content.present?
      return "" if drop.admin_only? && !is_admin?
      return "" if drop.user_only? && !logged_in?
      render "/rain/drops/drop", :drop => drop
    else
      if is_admin? || options[:admin_override]
        b = Builder::XmlMarkup.new.span({:class=>"rain_drop #{drop.id}"}) do |span|
          span << "Drop '#{name}' is not available. #{link_to 'Click here to create it',rain_drop_path(pure_name),:rel=>"#puddle"}"
        end
        return b.html_safe
      end
    end
  end
  
  def puddle
    "<div id='puddle'><div class='close'></div><div class='contentWrap'></div></div>".html_safe
  end
  
  def waterfall(rapids=nil,options={})
    rapids ||= Rain::Rapid.root
    classes = "nav" << (options[:class] || "")
    
    b = Builder::XmlMarkup.new
    b.div({:class=>classes}) do
      rapids.each do |rapid|
        b << render_rapid(rapid,options.merge({:last_rapid=>(rapid == rapids.last)}))
      end
    end
    b.target!.html_safe
  end
  
  def render_rapid(rapid,options)
    return "" if rapid.admin_only? && !is_admin?
    return "" if rapid.user_only? && !logged_in?
    
    b = Builder::XmlMarkup.new

    b.tag!(options[:element_tag] || :span,:class=>options[:last_rapid] ? "last" : "") do
      class_names = (rapid.classes || "")
      class_names << (rapid.link == request.path_info ? " current " : " ") << (options[:classes] || "")
      
      tag_options = {:href => (rapid.link.blank? ? "#" : rapid.link),:class => class_names}
      tag_options.merge!(:title => rapid.title) if rapid.title.present?
      b.a(tag_options,rapid)

      if options[:show_edit] && is_admin?
        b << " ["
        b.a({:href=>url_for([:edit,rapid])},"edit")
        b << "]"
        b << " | "
        b << " ["
        b << (link_to :delete, rapid, :method=>:delete,:confirm=>'Are you sure you want to delete this drop?' )
        b << "]"
      end
      if rapid.rapids.any?
        display_mode = "display:none" unless request.fullpath == rapid.link || options[:show_edit]
        b.tag!((options[:element_tag] ? 'ul' : 'span'),:style=>display_mode) do
          rapid.rapids.all(:order => 'position').each do |rapid|
            b << render_rapid(rapid, options.merge({:classes => "nav_expand_open children"}))
          end
        end
      end      
    end
  end
  
  def filter_drop(name)
    name.to_s.downcase
  end
  
  def application_layouts
    layouts = Dir.glob(File.join(Rails.root,'app','views','layouts','*'))
    layouts.collect{|layout_file| layout_file.split('/')[-1]}.compact
  end
  
  def drop_structure(drops)
    b = Builder::XmlMarkup.new
    b.ul do
      drops.each do |drop| 
        b.li do
          b << drop.to_s
          # [<%= link_to :edit, drop %>] [<%= link_to :delete, drop, :method=>:delete,:confirm=>'Are you sure you want to delete this drop?' %>]</li>
        end
      end
    end
  end
  
  def build_drop_hash(drops, trim_leading = "")
    b = {}
    drops.each do |drop|
      hash_bits = drop.name.gsub(trim_leading,'').split('_')
      b[hash_bits[0].to_s] ||= []
      leading_uri = hash_bits[0].dup.to_s << "_"
      drop_uri = drop.name.gsub(leading_uri,'')
      if drop_uri.index('_')
        b[hash_bits[0].to_s] << build_drop_hash([drop],hash_bits[0].to_s)
      else
        b[hash_bits[0].to_s] << {drop_uri => "spoon"}
      end
    end
    b
  end
end

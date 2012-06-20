require "rain/engine"

module Rain

  def self.root_path
    @root_path ||= Pathname.new( File.dirname(File.expand_path('../', __FILE__)) )
  end

  def self.assets
    #asset_list = Dir[root_path.join('vendor/assets/javascripts/ckeditor/**', '*.{js,css}')].inject([]) do |list, path|
    #  list << Pathname.new(path).relative_path_from(root_path.join('vendor/assets/javascripts'))
    #end
    [Pathname('rain.js')]
  end

end

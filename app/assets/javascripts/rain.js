//= require jquery.tools.overlay.apple.min
//= require_self
//= require ckeditor/ckeditor

jQuery.ajaxSettings.accepts.html = jQuery.ajaxSettings.accepts.script;

jQuery(function () {
  jQuery("a[rel=#puddle]").live('click',function(){
    jQuery(this).overlay({
        mask: '#ccc',
        effect: 'apple',
        load: true,
        onBeforeLoad: function() {
            var wrap = this.getOverlay().find(".contentWrap");
            wrap.load(this.getTrigger().attr("href"));
        }
    });
    return false;
  });
});

var CKEDITOR_BASEPATH = "/assets/ckeditor/";

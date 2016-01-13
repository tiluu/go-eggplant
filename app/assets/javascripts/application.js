// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require angular
//= require angular-resource
//= require ./picker.js
//= require ./slick.min.js
//= require best_in_place
//= require best_in_place.jquery-ui
//= require_tree .

(function($){
	var app = angular.module('trip', ['Calendar', 'calServices', 
                                      'tripServices', 'datePanels']);

	app.controller("TabController", function(){
		this.tab = 1;
		this.setTab = function(newValue){
            this.tab = newValue;
        };
        
    this.isSet = function(tabName){
      return this.tab === tabName;
    };
});

    $('.idea--form_action').on('click', function(){
        $(this).addClass('closed');
        $('.idea--form').removeClass('closed');
    })
    $('.idea--form_close').on('click', function(){
        $('.idea--form_action').removeClass('closed');
        $('.idea--form').addClass('closed');
    })

 //   $('.date-picker').pickadate({
 //       today: '',
 //   });

    $('.time-picker').pickatime();

    $('.best_in_place').best_in_place();
    $.datepicker.setDefaults({ dateFormat: 'yy-mm-dd'});

})(jQuery, this, this.document);

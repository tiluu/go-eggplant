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
//= require angular
//= require angular-resource
//= require_tree .

(function($){

	//Toggle list
	$('.trip--fav_action').find('button').on('click', function(){
		$('.trip--fav_action').find('.btn').removeClass('active');
		$(this).addClass('active');

		$('.trip--list').find('ul').addClass('closed');
		$('.trip--list').find('[data-type="'+$(this).data('type')+'"]').removeClass('closed');

	});


})(jQuery, this, this.document);

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
	var app = angular.module('trip', ['calServices', 'tripServices', 'WeeklyCalendar']);

	app.controller('CalendarCtrl', function($scope, mnthService, tripDays, tripData, tripMnths) {  
        // GLOBAL VARIABLES
        var months = Object.keys(mnthService);      
        var m1 = tripData.start_m;
        var m2 = tripData.end_m;
        var y1 = tripData.start_y;
        var y2 = tripData.end_y;
        
        $scope.tripDates = tripDays.duration;
        $scope.getMonths =  tripMnths.getMnths(months, m1, m2);
        $scope.weekdays = tripDays.week;
        $scope.days = tripDays;
        $scope.notMaxDays = tripDays.notMaxDays;

        // tag trip months with their respective years
        var setYear = function() {       
            if (y2 - y1 > 0) {
                var december = 12; 

                for (var m = m1 - 1; m < december; m++) {
                    var curr_month = months[m];
                    mnthService[curr_month].year = y1;
                }
                for (var m = 0;m <= m2;m++) {
                    var curr_month = months[m]
                    mnthService[curr_month].year = y2;
                }
            }
            else {
                for (var m = m1 - 1; m < m2; m++) {
                    var curr_month = months[m];                
                    mnthService[curr_month].year = y1;
                }
            }          
            
           return mnthService;   
        }  

        // find out what day of the week the first day of the current month falls on
        $scope.firstDayOfMonth = function(month) {
            setYear();
            var year = mnthService[month].year;
            var start_weekdays = [];
           
            for (var mnth in months) {
                //to account for year, may consider making year a param for the function 
                var first_day_of_month = months[mnth]+" 1 "+ year;
                var d = new Date(first_day_of_month);
                start_weekdays.push(d.getDay()); 
            }; 
            var m = mnthService[month].num - 1;
            return start_weekdays[m];          
        };
        
        // construct the first week of the current month
        $scope.firstWeekOfMonth = function(month) {           
            // var day keeps track  of # days before 1st day of month
            var day = 0;
            var start_day = $scope.firstDayOfMonth(month);
            var m = mnthService[month];
            m.first_week = []; 
                
            while (day < start_day && m.first_week.length < start_day) {
                m.first_week.push('');
                day++;
            }
                
            var first_weekdays = 1;
            while (m.first_week.length < 7) {
                m.first_week.push(first_weekdays);
                first_weekdays++;
            }               
            
            return m.first_week;
        };
       
       // build the rest of the calendar 
       $scope.remainingWeeks = function(month) {
            var last_index = mnthService[month].first_week.length - 1;
            var start_day = mnthService[month].first_week[last_index] + 1;
            
            var curr_row = [];
            while (curr_row.length < 7) {
                curr_row.push(start_day);
                start_day++;
            } 
            return curr_row;
       };

     })

	app.controller("TabController", function(){
		this.tab = 1;
		this.setTab = function(newValue){
            this.tab = newValue;
        };

        this.isSet = function(tabName){
          return this.tab === tabName;
        };
	});


})(jQuery, this, this.document);

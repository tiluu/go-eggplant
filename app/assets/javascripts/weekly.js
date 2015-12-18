(function() {
    var weekly = angular.module('WeeklyCalendar', ['calServices', 'tripServices']);

    weekly.controller('WeekCtrl', function($scope, mnthService, tripDays, tripData, tripMnths) {
    	// GLOBAL VARIABLES
        var months = Object.keys(mnthService);    
        var m1 = tripData.start_m;
        var m2 = tripData.end_m;
        var y1 = tripData.start_y;
        var d1 = tripData.start_d;
        var d2 = tripData.end_d;
       
        $scope.days = tripDays;
        $scope.weekdays = tripDays.week;
        $scope.tripDates = tripDays.duration;
        $scope.getMonths = tripMnths.getMnths(months, m1, m2);
        $scope.notEndTrip = tripDays.notEndTrip;
        $scope.m = mnthService;

        $scope.starters = function(month) {
            //getWkdays(month);
            totalWks(month);
        }

        $scope.getWkdays = function(month) {
        	var m = mnthService;
        	var curr_m = m[month];

        	if (curr_m !== months[m1-1]) {
        		var start_d = m.setCal(months[m1-1], d1, y1);
        	}
        	else {
        		
        	}
        }

        // total # days in trip
        var totalDays = function() {
        	var days_in_month = [];
        	var mnth = mnthService;
        	for (var m = m1-1; m < m2; m++) {
        		var days = mnth[months[m]];
        		days_in_month.push(days);
        	}

        	var total_days = 0;
        	if (m2 - m1 > 0) {
        		var first_mnth_days = days_in_month[0] - d1;
        		// add num days in the first & last month
        		total_days += first_mnth_days + d2;
        		// figure out months in between [if any]
 				for (var d =1; d < days_in_month.length - 1;d++) {
 					total_days += days_in_month[d];
 				}
        	}
        	else {
        		total_days = d2 - d1;
        	}
 			return total_days;
        }

        var totalWks = function(month) {
        	// reset num_wks each time the function is called
        	var m = mnthService[month]
        	m.num_weeks = [];

            if (m2 !== m1 && month === months[m2-1]) {
            	var day = d2;
            }
            else {
            	var day = totalDays();
            } 

            var num_wks = Math.ceil(day/ 7.0);
            for (var i = 0; i < num_wks; i++) {
               	m.num_weeks.push(i);        
            }
        }
      
    });

})();

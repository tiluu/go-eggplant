(function() {
    var weekly = angular.module('WeeklyCalendar', ['calServices']);

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
        $scope.notMaxDays = tripDays.notMaxDays;
        $scope.m = mnthService;

        $scope.starters = function(month) {
            getWkdays(month);
            totalWks(month);
        }

        var setCal = function(month, day) {
        	return new Date(month + " " + day + " " + y1);
        }

        var daysInMnth = function(month) {
        	return mnthService[month].num_days;
        }
        
        var getWkdays = function(month) {
        	// construct each week in the trip
        	var m = mnthService[month];
        	m.trip_week = [];
        	if (month === months[m1-1]) {
        		var start_d = setCal(months[m1-1], d1);
        		var day = d1;
        	}
        	else {
        		var start_d = setCal(month, 1);
        		var day = 1;     		
        	}
            var d1_wkday = start_d.getDay();
            var begin_of_week = d1_wkday;
            var end_of_week = 7 - d1_wkday; 

            while (begin_of_week > 0) {
            	var start_wkdate = day - begin_of_week;
                m.trip_week.push(start_wkdate);
                begin_of_week--;
            }
            while (end_of_week > 0) {
                m.trip_week.push(day);
                day++;
                end_of_week--;
            }
        }

        // total # days in trip
        var totalDays = function() {
        	var days_in_month = [];
        	for (var m = m1-1; m < m2; m++) {
        		var days = daysInMnth(months[m]);
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

        var whichMnth = function() {
        	// find out what # days in total days belong to which month
        	for (var m = m1-1; m< m2;m++) {
        		var mnth = mnthService[months[m]];
        		mnth.trip_dates = [];
        		for (var d = d1; d< d1+totalDays();d++) {
        			mnth.trip_dates.push(day);
        			if (d > mnth.num_days) {

        				d = 1;
        			}	
        		}
        	}
        }

        var totalWks = function(month) {
        	// reset num_wks each time the function is called
        	$scope.num_wks = [];
            var num_wks = Math.ceil(totalDays() / 7);
     		var m = mnthService[month];
     		m.num_tripwks = [];
            for (var i = 0; i < num_wks; i++) {
               	$scope.num_wks.push(i);        
            }

            return $scope.num_wks;
        }
    });

})();

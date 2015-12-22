// services related to trip dates
(function() {
	var services = angular.module("tripServices", ["calServices"]);

	services.factory("tripData", function() {
        var div = document.getElementById('calendar-dates');
        var start_date = div.getAttribute("start_date");
        var end_date = div.getAttribute("end_date")
        var start = new Date(start_date);
        var end = new Date(end_date);

        var data = {
            start: start,
            end: end,
            start_y: start.getFullYear(),
            start_m: start.getMonth() + 1,
            start_d: start.getDate(),
            end_y: end.getFullYear(),
            end_m: end.getMonth() + 1,
            end_d: end.getDate()
               
        };
        return data;
    });

    services.factory("tripMnths", function(tripData, mnthService) {
        // a list of months in the trip
        // todo: account for trips that span 2+yrs?
        var func = {};
        func.getMnths = function(months, m1, m2) {
            var trip_months = [];
            var december = 12;
            if (m2 - m1 < 0) {
                for (var m = m1 - 1;m < december; m++) {
                    trip_months.push(months[m]);
                }
                for(var m = 0; m < m2; m++) {
                    trip_months.push(months[m]);
                }
            }
            else {
                for(var m = m1 -1; m < m2; m++) {
                    trip_months.push(months[m]);   
                }
            }
            return trip_months;
        };

        func.setYear = function() {
        	var m1 = tripData.start_m;
	        var m2 = tripData.end_m;
	        var y1 = tripData.start_y;
	        var y2 = tripData.end_y;
	        var months = Object.keys(mnthService);  
	        mnthService.isLeapYear("February");

        	if (y2 - y1 > 0) {
                var december = 12; 

                for (var m = m1 - 1; m < december; m++) {
                    var curr_month = months[m];
                    mnthService[curr_month].year = y1;
                }
                for (var m = 0;m < m2; m++) {
                    var curr_month = months[m];
                    mnthService[curr_month].year = y2;
                }
            }
            else {
                for (var m = m1 - 1; m < m2; m++) {
                    var curr_month = months[m];                
                    mnthService[curr_month].year = y1;
                }
            }          
        }
        return func;
    });   

	services.factory("tripDays", function(mnthService, tripData) {
        var m = mnthService;
        var d1 = tripData.start_d;
        var d2 = tripData.end_d;
        var m1 = tripData.start_m;
        var m2 = tripData.end_m;
        var y1 = tripData.start_y;
        var y2 = tripData.end_y;
        var months = Object.keys(mnthService);  

        var trip = {};
        trip.week = ['Sun', 'Mon', 'Tue', 'Wed', 'Thurs','Fri',  'Sat'];

        trip.getDay = function(day,week) {
            return day + 7*week;
        }

       trip.notMaxDays = function(month, day,week) {
            // keep printing out dates until max # days in the month is reached
            m.isLeapYear(month);
            return trip.getDay(day,week) <= m[month].num_days;
        }   

        trip.notEndTrip = function(month,day,week) {
        	var year = m[month].year
            var curr_date = m.setCal(month,day,year);
            var end_of_week = 7 - tripData.end.getDay();
            var end_date = m.setCal(m2, d2 + end_of_week, y2)
            return trip.notMaxDays(month,day,week) && curr_date <= end_date;
        }

        trip.duration = function(month,day,week) {
            // highlight trip dates
           var year = m[month].year;
           var curr_date = m.setCal(month,day,year);
           var start_date = m.setCal(m1, d1, y1);
           var end_date = m.setCal(m2, d2, y2);

           var match_days = curr_date >= start_date && curr_date <= end_date;
           return match_days;
       }
        return trip;
    });
})();
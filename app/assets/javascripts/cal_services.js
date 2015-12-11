(function() {
    var services = angular.module("calServices", []);
    

    services.factory("mnthService", function() {
        var months = {January: {num: 1, num_days: 31}, 
                      February: {num: 2, num_days: 28}, 
                      March: {num: 3, num_days: 31}, 
                      April: {num: 4, num_days: 30},
                      May: {num: 5, num_days: 31},
                      June: {num: 6, num_days: 30}, 
                      July: {num: 7, num_days: 31},
                      August: {num: 8, num_days: 31}, 
                      September: {num: 9, num_days: 30},
                      October: {num: 10, num_days: 31},
                      November: {num: 11, num_days: 30},
                      December: {num: 12, num_days: 31}
                     };

        // leap year
        months.isLeapYear = function(month) {
            var yr = months[month].year; 
            var leap_yr = (yr % 4 === 0) && (yr%100 !== 0) || (yr%400 === 0);
            if (leap_yr && month === "February") {
                months[month].num_days = 29;
            }
        }
        return months;    
    });
    
    services.factory("tripDays", function(mnthService, tripData) {
        var trip = {};
        trip.week = ['Sun', 'Mon', 'Tue', 'Wed', 'Thurs','Fri',  'Sat'];
        trip.getDay = function(day,week) {
            return day + 7*week;
        }

        trip.duration = function(month, cal_day) {
            // highlight trip dates
           var d1 = tripData.start_d;
           var d2 = tripData.end_d;
           var m1 = tripData.start_m;
           var m2 = tripData.end_m;
           var y2 = tripData.end_y;

           var curr_yr = mnthService[month].year;
           var month_num = mnthService[month].num;
          
           var y_diff = y2 - curr_yr;
           var m_diff = (m2 + (12*y_diff)) - month_num;
           
           var new_start_d = d1 - d1*(Math.abs(month_num - m1));           
           var new_end_d = d2 + m_diff*31 + d2*(Math.abs(m2 - month_num));
          
           var match_days = new_start_d <= cal_day && new_end_d >= cal_day && cal_day !== '';
        
           return match_days;
       }

       trip.notMaxDays = function(month, day,week) {
            // keep printing out dates until max # days in the month is reached
            mnthService.isLeapYear(month);
            return trip.getDay(day,week) <= mnthService[month].num_days;
        }   
        return trip;
    });

    services.factory("tripMnths", function() {
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
                    trip_months.pus(months[m]);
                }
            }
            else {
                for(var m = m1 -1; m < m2; m++) {
                    trip_months.push(months[m]);   
                }
            }
            return trip_months;
        };
        return func;
    });   
    
    services.factory("tripData", function() {
        var div = document.getElementById('calendar-dates');
        var start_date = div.getAttribute("start_date");
        var end_date = div.getAttribute("end_date")
        var start = new Date(start_date);
        var end = new Date(end_date);

        var data = {
            start_y: start.getFullYear(),
            start_m: start.getMonth() + 1,
            start_d: start.getDate(),
            end_y: end.getFullYear(),
            end_m: end.getMonth() + 1,
            end_d: end.getDate()
               
        };
        return data;
    });
   
})();

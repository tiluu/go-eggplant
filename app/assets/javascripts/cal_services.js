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
        return months;    
    });
    
    services.factory("wkService", function() {
        var weeks = ['Sun', 'Mon', 'Tue', 
        'Wed', 'Thurs','Fri',  
        'Sat'];
        return weeks;
    });

    services.factory("currDay", function() {
        // calculate dates in the calendar
        var func = {};
        func.getDay = function(day,week) {
            return day + 7*week;
        }
        return func;
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

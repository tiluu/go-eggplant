// services related to the calendar in general
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

        months.setCal = function(month,day,year) {
            return new Date(month + " " + day + " " + year); 
        }
        
        return months;    
      });
   
})();

(function() {
    var services = angular.module("calServices", []);

    services.factory("mnthService", function() {
        //todo: account for leap year
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
        var weeks = ['Sunday', 'Monday', 'Tuesday',                                   'Wednesday', 'Thursday','Friday',                                'Saturday'];
        return weeks;
    });   
    
    services.factory("tripData", function() {
        var div = document.getElementById('date-data');
        var start_date = div.getAttribute("start_date");
        var end_date = div.getAttribute("end_date")
        var start = new Date(start_date);
        var end = new Date(end_date);

        var data = {
            start_y: start.getFullYear(),
            start_m: start.getMonth(),
            start_d: start.getDate(),
            end_y: end.getFullYear(),
            end_m: end.getMonth(),
            end_d: end.getDate()
               
        };
        return data;
    });
   
})();

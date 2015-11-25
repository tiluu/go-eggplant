(function() {
    var services = angular.module("calServices", []);

    services.factory("mnthService", function() {
        //todo: account for leap year
        var months = {January: {num: 1, num_days: 31, first_week: []}, 
                      February: {num: 2, num_days: 28, first_week: []}, 
                      March: {num: 3, num_days: 31, first_week: []}, 
                      April: {num: 4, num_days: 30, first_week: []},
                      May: {num: 5, num_days: 31, first_week: []},                                                                         June: {num: 6, num_days: 30, first_week: []}, 
                      July: {num: 7, num_days: 31, first_week: []},
                      August: {num: 8, num_days: 31, first_week: []}, 
                      September: {num: 9, num_days: 30, first_week: []},
                      October: {num: 10, num_days: 31, first_week: []},                                                                    November: {num: 11, num_days: 30, first_week: []},
                      December: {num: 12, num_days: 31, first_week: []}
                     };
        return months;    
    });
    
    services.factory("wkService", function() {
        var weeks = ['Sunday', 'Monday', 'Tuesday',                                   'Wednesday', 'Thursday','Friday',                                'Saturday'];
        return weeks;
    });   
    
   
})();

(function() {
    var calendar = angular.module('Calendar', ['calServices']);

   
    calendar.controller('CalendarCtrl', function($scope, mnthService, wkService, tripData) {  
        $scope.weekdays = wkService;
        var tripDates = tripData; 
        var months = Object.keys(mnthService);      

        // convert date.getMonth() to name of current month 
        $scope.getMonths = function() {
                                   
            var trip_months = [];
            var m1 = tripDates.start_m;
            var m2 = tripDates.end_m;
            
            for (var m = m1; m <= m2; m++) {                      
                trip_months.push(months[m]);            
              }

            return trip_months;    
        };  

        // calculate current date
        $scope.getDay = function(day, week) {
            return day + 7*week;
        }

        // keep printing out dates until max # days in the month is reached
        $scope.notMaxDays = function(month, day,week) {
            return $scope.getDay(day,week) <= mnthService[month].num_days;
        }   

        // find out what day of the week the first day of the current month falls on
        $scope.firstDayOfMonth = function(month) {
            var start_y = tripDates.start_y;
            var end_y = tripDates.end_y;
            var start_weekdays = [];
           
            for (var mnth in months) {
                //to account for year, may consider making year a param for the function 
                var first_day_of_month = months[mnth]+" 1 "+ start_y;
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

       // highlights trip date
       $scope.tripDates = function(month, cal_day) {
           var start_d = tripDates.start_d;
           var start_m = tripDates.start_m + 1;
           var end_d = tripDates.end_d;
           var end_m = tripDates.end_m + 1;
           
           var curr_month = mnthService[month].num; 
           var start_diff = curr_month - start_m;
           var end_diff = end_m - curr_month;
           
           var new_start_d = start_d - (start_d * start_diff)
           var new_end_d = end_d + (mnthService[month].num_days * end_diff)
           
           var match_days = new_start_d <= cal_day && new_end_d >= cal_day && cal_day !== '';
       
           return match_days;
       };

     })
})();

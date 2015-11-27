(function() {
    var calendar = angular.module('Calendar', ['calServices']);

   
    calendar.controller('CalendarCtrl', function($scope, mnthService, wkService, tripData) {
        $scope.data = tripData;     
        $scope.weekdays = wkService;

        var months = Object.keys(mnthService);
        var start_d = new Date($scope.data.start_d)
        var end_d = new Date($scope.data.end_d);

        $scope.year = start_d.getFullYear();
        // convert date.getMonth() to name of current month 
        
        $scope.getMonths = function() {
            var trip_months = [];
            var m1 = start_d.getMonth();
            var m2 = end_d.getMonth();
            var diff = m2 - m1;
            // need to account for year transitions
            if (diff > 0) { 
                for (var m = m1; m <= m2; m++) {
                trip_months.push(months[m]);            
                }    
            }
            else {
                trip_months.push(months[m1])
            }
            return trip_months;    
        };
       
/**
        $scope.getMonth = function() {
            var m = start_d.getMonth();
            return months[m];
        }
**/

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
            var year = $scope.year.toString();
            var start_weekdays = [];
           
            for (var key in months) {
                var first_day_of_month = months[key]+" 1 "+year;
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
            var first_row = mnthService[month].first_week; 
                
            while (day < start_day && first_row.length < start_day) {
                first_row.push('');
                day++;
            }
                
            var first_weekdays = 1;
            while (first_row.length < 7) {
                first_row.push(first_weekdays);
                first_weekdays++;
            }               
            
            return first_row;
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
           var start_day = start_d.getDate();
           var start_mnth = start_d.getMonth() + 1;
           var end_day = end_d.getDate();
           var end_mnth = end_d.getMonth() + 1;
           
           var curr_month = mnthService[month].num; 
           var start_diff = curr_month - start_mnth;
           var end_diff = end_mnth - curr_month;
           //  new_end_d changes as ng-repeat loop thru each month
           var new_start_d = start_day - (start_day * start_diff)
           var new_end_d = end_day + (mnthService[month].num_days * end_diff)
           
           var match_days = new_start_d <= cal_day && new_end_d >= cal_day;
           console.log(month + new_start_d + " to " + new_end_d + " " + cal_day + match_days);
           return match_days;
       };

     })
})();

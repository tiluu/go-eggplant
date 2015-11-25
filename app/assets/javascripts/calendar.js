(function() {
    var calendar = angular.module('Calendar', ['calServices']);

   
    calendar.controller('CalendarCtrl', function($scope, mnthService, wkService) {
        var div = document.getElementById('date-data');
        $scope.data = {
            start_d: div.getAttribute("start_date"),
            end_d: div.getAttribute("end_date")
        };
        
        $scope.weekdays = wkService;

        var months = Object.keys(mnthService);

        var start_d = new Date($scope.data.start_d)
        var end_d = new Date($scope.data.end_d);

        $scope.year = start_d.getFullYear();
        // convert date.getMonth() to name of current month 
        /**
        $scope.getMonths = function() {
            var trip_months = [];
            var m1 = start_d.getMonth();
            var m2 = end_d.getMonth();
            if (m1 != m2) { 
                trip_months.push(months[m1], months[m2]);            }
            else {
                trip_months.push(months[m1])
            }
            return trip_months;    
        };
        **/

        $scope.getMonth = function() {
            var m = start_d.getMonth();
            return months[m];
        }
        
        // calculate current date
        $scope.getDay = function(day, week) {
            return day + 7*week;
        }

        // keep printing out dates until max # days in the month is reached
        $scope.notMaxDays = function(day,week) {
            var m = $scope.getMonth();
            var notMaxDays;
            /**
            if (m.length == 2) { 
               return $scope.getDay(day, week) <= mnthService[m[0]].num_days && $scope.getDay(day,week <= mnthService[m[1]].num_days;
            }
          **/
           return $scope.getDay(day,week) <= mnthService[m].num_days;
        }   

        // find out what day of the week the first day of the current month falls on
        $scope.firstDayOfMonth = function() {
            var year = $scope.year.toString();
            var start_weekdays = [];
           
            for (var key in months) {
                var first_day_of_month = months[key]+" 1 "+year;
                var d = new Date(first_day_of_month);
                start_weekdays.push(d.getDay()); 
            }; 
            var m = start_d.getMonth();
            return start_weekdays[m];          
        };
        
        // construct the first week of the current month
        $scope.firstWeekOfMonth = function() {           
            // var day keeps track  of # days before 1st day of month
            var day = 0;
            var start_day = $scope.firstDayOfMonth();
            var m = $scope.getMonth();
            var first_row = mnthService[m].first_week; 
                
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
       $scope.remainingWeeks = function() {
            var m = $scope.getMonth();
            var last_index = mnthService[m].first_week.length - 1;
            var start_day = mnthService[m].first_week[last_index] + 1;
            
            var curr_row = [];
            while (curr_row.length < 7) {
                curr_row.push(start_day);
                start_day++;
            } 
            return curr_row;
       };

       // highlights trip date
       $scope.tripDates =function(cal_day) {
            var start_day = start_d.getDate();
            var end_day = end_d.getDate();

            var match_days = start_day <= cal_day && end_day >= cal_day;

            return match_days;
       };

     })
})();

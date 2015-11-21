(function() {
    var calendar = angular.module('Calendar', []);

    calendar.controller('CalendarCtrl', function($scope) {
        var date = new Date();
        $scope.year = date.getFullYear(); 
        $scope.curr_month = date.getMonth();                
        $scope.today = date.getDate();
       // todo: account for leap year 
       $scope.months = {January: {num: 1, num_days: 31, first_week: []}, 
                        February: {num: 2, num_days: 28, first_week: []}, 
                         March: {num: 3, num_days: 31, first_week: []}, 
                         April: {num: 4, num_days: 30, first_week: []},
                         May: {num: 5, num_days: 31, first_week: []}, 
                         June: {num: 6, num_days: 30, first_week: []}, 
                         July: {num: 7, num_days: 31, first_week: []},
                         August: {num: 8, num_days: 31, first_week: []}, 
                         September: {num: 9, num_days: 30, first_week: []},
                         October: {num: 10, num_days: 31, first_week: []},
                         November: {num: 11, num_days: 30, first_week: []},
                         December: {num: 12, num_days: 31, first_week: []}
                        };
                  
        $scope.weekdays = ['Sunday', 'Monday', 'Tuesday',
                           'Wednesday', 'Thursday','Friday', 
                           'Saturday'];
        
        var months = Object.keys($scope.months);
      
        // convert date.getMonth() to name of current month 
        $scope.getMonth = function() {
            var m = $scope.curr_month; 
            return months[m];    
        }
        
        // calculate current date
        $scope.getDay = function(day, week) {
            return day + 7*week;
        }

        // keep printing out dates until max # days in the month is reached
        $scope.notMaxDays = function(day,week) {
            var m = $scope.getMonth();
            return $scope.getDay(day,week) <= $scope.months[m].num_days;
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
            return start_weekdays[$scope.curr_month];          
        };
        
        // construct the first week of the current month
        $scope.firstWeekOfMonth = function() {           
            // var day keeps track  of # days before 1st day of month
            var day = 0;
            var start_day = $scope.firstDayOfMonth();
            var m = $scope.getMonth();
            var first_row = $scope.months[m].first_week; 
                
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
            var last_index = $scope.months[m].first_week.length - 1;
            var start_day = $scope.months[m].first_week[last_index] + 1;
            
            var curr_row = [];
            while (curr_row.length < 7) {
                curr_row.push(start_day);
                start_day++;
            } 
            return curr_row;
       };

       // highlight current day
       $scope.highlightToday = function(month,day) {
           var month_num = $scope.months[month].num;
           var curr_month = $scope.curr_month + 1;                
           var today = date.getDate(); 

           return month_num == curr_month && day == today;
       };

     })
})();

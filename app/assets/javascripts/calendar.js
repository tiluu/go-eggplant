(function() {
    var calendar = angular.module('Calendar', ['calServices']);

   
    calendar.controller('CalendarCtrl', function($scope, mnthService, wkService) {
        var div = document.getElementById('date-data');
        $scope.data = {
            start_d: div.getAttribute("start_date"),
            end_d: div.getAttribute("end_date")
        };

        var date = new Date();
        $scope.year = date.getFullYear(); 
        $scope.curr_month = date.getMonth();                
        $scope.today = date.getDate();
        $scope.weekdays = wkService;
        
        var months = Object.keys(mnthService);
      
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
            return start_weekdays[$scope.curr_month];          
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

       // highlight current day--> switch to trip dates
       $scope.highlightToday = function(month,day) {
           var month_num = mnthService[month].num;
           var curr_month = $scope.curr_month + 1;                
           var today = date.getDate(); 

           return month_num == curr_month && day == today;
       };

       $scope.tripDates =function(start,end,cal_month,cal_day) {
            var start_d = new Date(start);
            var end_d = new Date(end);
            var start_mnth = start_d.getMonth()+1; 
            var end_mnth = end_d.getMonth()+1;
            var start_day = start_d.getDate();
            var end_day = end_d.getDate();

            var match_start_month = start_mnth == cal_month;
            var match_end_month = end_mnth == cal_month;
            var match_days = start_day <= cal_day && end_day >= cal_day;

            return match_start_month && match_end_month && match_days;
       };

     })
})();

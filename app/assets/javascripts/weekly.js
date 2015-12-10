(function() {
    var weekly = angular.module('WeeklyCalendar', ['calServices']);
    
    weekly.controller('WeekCtrl', function($scope, mnthService, wkService, tripData, currDay, tripMnths) {
        $scope.currDay = currDay
        $scope.weekdays = wkService;
        var m1 = tripData.start_m;
        var months = Object.keys(mnthService);
        $scope.m1 = months[m1 - 1];
        
        var m2 = tripData.end_m;
        var y1 = tripData.start_y;
        var d1 = tripData.start_d;
        var d2 = tripData.end_d;
       
        $scope.num_wks = [];
        $scope.week = [];
        $scope.getMonths = tripMnths.getMnths(months, m1, m2);

        $scope.starters = function() {
            getWkdays();
            totalWks();
        }
        
        var getWkdays = function() {
            var d = new Date($scope.m1 + " " + d1 + " " + y1);
            var d1_wkday = d.getDay();
            var begin_of_week = d1_wkday - 0;
            var end_of_week = 7 - d1_wkday; 
            
            var start_wkdate = d1 - begin_of_week;
            while (begin_of_week > 0) {
                $scope.week.push(start_wkdate);
                start_wkdate++;
                begin_of_week--;
            }
            while (end_of_week >0) {
                $scope.week.push(d1);
                d1++;
                end_of_week--;
            }
           return $scope.week;
        }

        var totalWks = function() {
            // assuming in same month
            var diff = d2 - d1;
            var num_wks = diff / 7 + 1;
            for (var i = 0; i <= num_wks; i++) {
                $scope.num_wks.push(i);        
            }
            return $scope.num_wks;
        }
    });

})();

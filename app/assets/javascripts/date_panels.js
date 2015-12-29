(function() {
	var date = angular.module("datePanels", ['calServices', 'tripServices']);

    date.directive('slickSlider',function($timeout){
         return {
           restrict: 'A',
           link: function(scope,element,attrs) {
             $timeout(function() {
                 $(element).slick(scope.$eval(attrs.slickSlider));
             });
           }
         }
        }); 

	date.controller('DateCtrl', function($scope, mnthService, tripDays, tripData, tripMnths) {
        // GLOBAL VARIABLES
        var m = mnthService;
        var months = Object.keys(m);      
        var m1 = tripData.start_m;
        var m2 = tripData.end_m;
        var d1 = tripData.start_d;
        var d2 = tripData.end_d;
        var y1 = tripData.start_y;
        var y2 = tripData.end_y;

        $scope.getWkday = function(date) {
                var day = date.getDay();
                return tripDays.week[day]
        }

        // trip dates stored in array
        $scope.trip = []

        $scope.buildTrip = function() {
                tripMnths.setYear();
                var trip_months = tripMnths.getMnths(months, m1, m2);
                var curr_date = tripData.start;
                var end = tripData.end;

                var month = curr_date.getMonth();
                var day = curr_date.getDate();
                
                while (curr_date < end) {
                    var mnth = months[month];
                    if (day > m[mnth].num_days) {
                        day = 1;
                        // check if current month is december
                        month === 11 ? month = 0 : month++;
                    }
                    else {
                        day;
                    }
                    var year = m[mnth].year;
                    curr_date = m.setCal(mnth, day,year);
                    day++;
                    $scope.trip.push(curr_date);
                }
        }

	});
})();


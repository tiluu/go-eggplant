(function() {
	var app = angular.module('Timezones', []);

	app.factory("timezoneData", function($resource) {
        var timezones = $resource('all-timezones');
        return timezones.get();
    });

    app.controller("TimezoneCtrl", function($scope, timezoneData) {
        var addZero = function(time) {
            time < 10 ? time = "0" + time : time;
            return time;
        };

        var time12hr = function(hour) {
            hour > 12 ? hour = hour % 12 : hour
            hour == 0 ? hour = 12 : hour; 
            return addZero(hour);
        };

        var ampm = function(hour) {
            var result;
            hour > 12 ? result = "PM" : result = "AM"
            return result;
        }

        $scope.getTime = function(zone) {
            var d = new Date();
            var zone_offset = timezoneData[zone] / 60; // in minutes
            var local_gmt_offset = d.getTimezoneOffset();
            var offset = local_gmt_offset + zone_offset;
            var new_time = d.setMinutes(d.getMinutes() + offset);
            
            var hours = time12hr(d.getHours()); 
            var minutes = addZero(d.getMinutes());
            $scope.timezone = hours + ": " + minutes + " " + ampm(d.getHours()); 
        }
    });
})();
var debugScope;
console.log('here');

var rdApp = angular.module('rdApp', ['ngResource']);

rdApp.run(function ($http) {
    // For Rails CSRF
    var csrf_token = $('meta[name="csrf-token"]').attr('content');
    if(csrf_token) {
        $http.defaults.headers.put['X-CSRF-Token'] = csrf_token;
        $http.defaults.headers.post['X-CSRF-Token'] = csrf_token;
    } else {
        alert("Error: no meta tag found with csrf-token. Ajax calls won't work.");
    }
});

rdApp.factory('Room', function ($resource) {
  return $resource('/rooms/:id.json');
});

rdApp.factory('Character', function ($resource) {
  return $resource('/characters/:id.json');
});

rdApp.controller('roomsCtrl', function ($scope, Room) {
  $scope.rooms = Room.query();
});

rdApp.controller('editRoom', function ($scope, Room, Character) {
  var roomId = $("#roomId").val();
  Room.get({id: roomId}, function (room) {
	$scope.room = room;
  	if ($scope.room.mobiles.length <= 0) $scope.room.mobiles = [{}];
  	
  });

  $scope.addMobile = function () {
  	if ($scope.room) $scope.room.mobiles.push({});
  }
  $scope.characters = Character.query();
  debugScope = $scope;
});
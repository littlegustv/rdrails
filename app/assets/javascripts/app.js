var debugScope;

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

rdApp.controller('editRoom', function ($scope, $location, Room, Character) {
	$scope.directions = ["North", "South", "East", "West", "Up", "Down"];

  var roomId = $("#roomId").val();
	if (roomId) {
	  Room.get({id: roomId}, function (room) {
			$scope.room = room;
	  	$scope.initRoom();
	  });
	} else {
		$scope.room = {mobiles: [{}], exits: [{}]};
	}

	$scope.initRoom = function () {
		if ($scope.room.mobiles.length <= 0) $scope.room.mobiles = [{}];
  	if ($scope.room.exits.length <= 0) $scope.room.exits = [{}];
	}

  $scope.save = function () {
  	$scope.room.mobiles_attributes = $scope.room.mobiles.filter( function (m) { return m.character_id });
  	$scope.room.exits_attributes = $scope.room.exits.filter( function (m) { return m.destination_id });
  	delete $scope.room['mobiles'];
  	delete $scope.room['exits'];
  	var redirect = $scope.room.id === undefined;
  	$scope.room = Room.save($scope.room, function (room) {
  		$scope.initRoom();
  		if (redirect) window.location = '/rooms/' + $scope.room.id + '/edit';
  	});
  }

  $scope.destroy = function (mobile) {
  	mobile._destroy = true;
  }

  $scope.add = function (array) {
  	if ($scope.room) array.push({});
  }
  $scope.characters = Character.query();
  $scope.rooms = Room.query();
  debugScope = $scope;
});
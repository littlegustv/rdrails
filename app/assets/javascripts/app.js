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

rdApp.factory('Item', function ($resource) {
	return $resource('/items/:id.json');
});

rdApp.factory('Area', function ($resource) {
  return $resource('/areas/:id.json');
});

rdApp.factory('Skill', function ($resource) {
  return $resource('/skills/:id.json');
});

rdApp.controller('editCharacter', function ($scope, Character, Item, Skill) {
  var characterId = $('#characterId').val() || "new";
  if (characterId) {
    Character.get({id: characterId}, function (character) {
      $scope.character = character;
      if ($scope.character.inventory_items.length <= 0) $scope.character.inventory_items = [{}];
    });
  }

  $scope.save = function () {
    $scope.character.stat_attributes = $scope.character.stat;
    $scope.character.equipment_attributes = $scope.character.equipment;
    $scope.character.character_skills_attributes = $scope.character.skills;
    $scope.character.inventory_items_attributes = $scope.character.inventory_items.filter( function (m) { return m.item_id });
    delete $scope.character['stat'];
    delete $scope.character['inventory_items'];
    delete $scope.character['equipment'];
    delete $scope.character['skills'];
    var redirect = $scope.character.id === undefined;
    $scope.character = Character.save($scope.character, function (character) {
      if (redirect) window.location = '/characters/' + $scope.character.id;
    });
  }

  $scope.destroy = function (obj) {
    obj._destroy = true;
  }

  $scope.add = function (array) {
    if ($scope.character) array.push({});
  }
  $scope.items = Item.query();
  $scope.skills = Skill.query();
  debugScope = $scope;
});

rdApp.controller('editRoom', function ($scope, $location, Room, Character, Item, Area) {
	$scope.directions = ["North", "South", "East", "West", "Up", "Down"];

  var roomId = $("#roomId").val();
	if (roomId) {
    Room.get({id: roomId}, function (room) {
			$scope.room = room;
      $scope.initRoom();
    });
	} else {
		$scope.room = {mobiles: [{}], exits: [{}], room_items: [{}]};
	}

	$scope.initRoom = function () {
		if ($scope.room.mobiles.length <= 0) $scope.room.mobiles = [{}];
    if ($scope.room.exits.length <= 0) $scope.room.exits = [{}];
    if ($scope.room.room_items.length <= 0) $scope.room.room_items = [{}];
	}

  $scope.save = function () {
    $scope.room.mobiles_attributes = $scope.room.mobiles.filter( function (m) { return m.character_id });
    $scope.room.exits_attributes = $scope.room.exits.filter( function (m) { return m.destination_id });
    $scope.room.room_items_attributes = $scope.room.room_items.filter( function (m) { return m.item_id });
    delete $scope.room['mobiles'];
    delete $scope.room['exits'];
    delete $scope.room['room_items'];
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
  $scope.items = Item.query();
  $scope.rooms = Room.query();
  $scope.areas = Area.query();
  debugScope = $scope;
});
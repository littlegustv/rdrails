var rdApp = angular.module('rdApp', ['ngResource']);

rdApp.factory('Room', function ($resource) {
  return $resource('/rooms/:id.json');
});

rdApp.controller('roomsCtrl', function ($scope, Room) {
  $scope.rooms = Room.query();
});

rdApp.controller('editRoom', function ($scope, Room) {
  var roomId = $("#roomId").val();
  $scope.room = Room.get({id: roomId});
  console.log($scope.room);
});
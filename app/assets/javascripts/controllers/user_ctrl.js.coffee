@UserCtrl = ($scope, $http, CurrentUser) ->
  $http.get("users/#{CurrentUser.id}.json").then (response) =>
    #TODO fix format based on API response
    $scope.parties = response.data.parties
    $scope.dropbox_songs = response.data.dropbox_songs

  $scope.partyURL = (id) ->
    root = $scope.location.host()
    "#{root}/party/#{id}"

@UserCtrl.$inject = ['$scope', '$http', 'CurrentUser']

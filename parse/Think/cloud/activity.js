var handlerFollowType 	= require('cloud/activity_follow.js');
var handlerLikeType 	= require('cloud/activity_like.js');
var handlerApn 			= require('cloud/activity_apn.js');
var handlerCounter 		= require('cloud/activity_counter.js');

Parse.Cloud.afterSave('Activity', function(request) {
	handlerApn(request);
	handlerCounter(request);
});

Parse.Cloud.beforeSave('Activity', function ( request, response ) {
	var currentUser = request.user;
	var fromUser 	= request.object.get('from_user');
	var type 		= request.object.get('type');

	if ( !currentUser || !fromUser ) {
		response.error('An Activity should have a valid fromUser.');
	} else if ( currentUser.id === fromUser.id ) {
		if ( type === "follow" ) {
			handlerFollowType(request, response);
		} else if (type === "like") {
			handlerLikeType(request, response);
		} else {
			response.success();
		}
	} else {
		response.error('Cannot set fromUser on Activity to a user other than the current user.');
	}

});
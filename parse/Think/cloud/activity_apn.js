module.exports = function ( request ) {
	// Only send push notifications for new activities
	var currentUser = request.user;

	if ( request.object.existed() ) {
		return;
	}

	var fromUser = request.object.get("to_user");

	if (fromUser.id === currentUser.id) return;

	var toUser = request.object.get("to_user");
	if ( !toUser ) {
		throw "Undefined toUser. Skipping push for Activity " + request.object.get('type') + " : " + request.object.id;
		return;
	}

	var type = request.object.get("type");
	var query = new Parse.Query(Parse.Installation);
	query.equalTo('user', toUser);
	query.equalTo('events', type);

	Parse.Push.send({
		where : query, // Set our Installation query.
		data  : alertPayload(request)
	}).then(function () {
		// Push was successful
		console.log('Sent push.');
	}, function ( error ) {
		throw "Push Error " + error.code + " : " + error.message;
	});
};

var alertMessage = function ( request ) {
	var message = "";

	if ( request.object.get("type") === "comment" ) {
		if ( request.user.get('display_name') ) {
			message = request.user.get('display_name') + ': ' + request.object.get('content').trim();
		} else {
			message = "Someone commented on your post.";
		}
	} else if ( request.object.get("type") === "like" ) {
		if ( request.user.get('display_name') ) {
			message = request.user.get('display_name') + ' likes your post.';
		} else {
			message = 'Someone likes your post.';
		}
	} else if ( request.object.get("type") === "follow" ) {
		if ( request.user.get('display_name') ) {
			message = request.user.get('display_name') + ' is now following you.';
		} else {
			message = "You have a new follower.";
		}
	}

	// Trim our message to 140 characters.
	if ( message.length > 140 ) {
		message = message.substring(0, 140);
	}

	return message;
}

var alertPayload = function ( request ) {
	var payload = {};
	var type = request.object.get("type");
	if ( type === "comment" ) {
		return {
			alert : alertMessage(request), // Set our alert message.
			badge : 'Increment', // Increment the target device's badge count.
			// The following keys help Anypic load the correct photo in response to this push notification.
			p     : 'a', // Payload Type: Activity
			t     : 'c', // Activity Type: Comment
			fu    : request.object.get('from_user').id, // From User
			pid   : request.object.id // Photo Id
		};
	} else if ( type === "like" ) {
		return {
			alert : alertMessage(request), // Set our alert message.
			// The following keys help Anypic load the correct photo in response to this push notification.
			p     : 'a', // Payload Type: Activity
			t     : 'l', // Activity Type: Like
			fu    : request.object.get('from_user').id, // From User
			pid   : request.object.id // Photo Id
		};
	} else if ( type === "follow" ) {
		return {
			alert : alertMessage(request), // Set our alert message.
			// The following keys help Anypic load the correct photo in response to this push notification.
			p     : 'a', // Payload Type: Activity
			t     : 'f', // Activity Type: Follow
			fu    : request.object.get('from_user').id // From User
		};
	}
}
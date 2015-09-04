Parse.Cloud.afterSave('Message', function ( request ) {
	// Only send push notifications for new activities
	var currentUser = request.user;

	if ( request.object.existed() ) {
		return;
	}

	var toUser = request.object.get("to_user");
	if ( !toUser ) {
		throw "Undefined toUser. Skipping push for Message";
		return;
	}

	var query = new Parse.Query(Parse.Installation);
	query.equalTo('user', toUser);

	Parse.Push.send({
		where : query, // Set our Installation query.
		data  : alertPayload(request)
	}).then(function () {
		// Push was successful
		console.log('Sent push.');
	}, function ( error ) {
		throw "Push Error " + error.code + " : " + error.message;
	});
});

var alertMessage = function ( request ) {
	var message = "";

	if ( request.user.get('display_name') ) {
		message = request.user.get('display_name') + ' send you a message.';
	} else {
		message = 'Someone send you a message.';
	}

	// Trim our message to 140 characters.
	if ( message.length > 140 ) {
		message = message.substring(0, 140);
	}

	return message;
};

var alertPayload = function ( request ) {
	return {
		alert : alertMessage(request), // Set our alert message.
		badge : 'Increment', // Increment the target device's badge count.
		p     : 'm', // Payload Type: Message
		fu    : request.object.get('from_user').id, // From User
		mid   : request.object.id // Message Id
	};
};

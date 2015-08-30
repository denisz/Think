var Activity = Parse.Object.extend("Activity");

module.exports = function (request, response) {
	var currentUser = request.user;
	var fromUser 	= currentUser;
	var type 		= request.object.get('type');
	var post 		= request.object.get('post');
	var toUser 		= request.object.get('to_user');

	if (!toUser) {
		response.error('An Activity should have a valid toUser.');
	} else {
		var query = new Parse.Query(Activity);
		query.equalTo('from_user', currentUser);
		query.equalTo('to_user', toUser);
		query.equalTo('type', type);
		query.equalTo('post', post);

		query.first({
			success : function ( object ) {
				if ( object ) {
					response.error("An activity type follow with this userId already exists.");
				} else {
					response.success();
				}
			},
			error   : function () {
				response.error('An Activity should have a valid fromUser.');
			}
		})
	}
};


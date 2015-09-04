var Post = Parse.Object.extend("Post");

module.exports = function(request) {
	if ( request.object.existed() ) {
		return;
	}

	var action 	= false;
	var field 	= null;
	var type 	= request.object.get("type");

	if (type == "like") {
		action = true;
		field = "counter_likes"
	}

	if (type == "comment") {
		action = true;
		field = "counter_comments"
	}

	if (action == true) {
		var postID =  request.object.get("post").id;
		var query = new Parse.Query(Post);
		query.get(postID, {
			success: function(post) {
				console.log("Increment field ", field);
				post.increment(field);
				post.save();
			},
			error: function(object, error) {
				// The object was not retrieved successfully.
				// error is a Parse.Error with an error code and message.
			}
		});

	}
};

Parse.Cloud.afterDelete("Activity", function(request) {
	var action 	= false;
	var field 	= null;
	var type 	= request.object.get("type");

	if (type == "like") {
		action = true;
		field = "counter_likes"
	}

	if (type == "comment") {
		action = true;
		field = "counter_comments"
	}

	if (action == true) {
		var postID =  request.object.get("post").id;
		var query = new Parse.Query(Post);
		query.get(postID, {
			success: function(post) {
				console.log("Decrement field ", field);
				post.increment(field, -1);
				post.save();
			},
			error: function(object, error) {
				// The object was not retrieved successfully.
				// error is a Parse.Error with an error code and message.
			}
		});

	}
});

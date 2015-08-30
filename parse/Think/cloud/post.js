var _ = require('underscore');
var Post = Parse.Object.extend("Post");
var kPostContentObjKey = "content_obj";
var kPostTitleKey = "title";

var validPost = function ( object ) {
	var title = object.get(kPostTitleKey);
	var content_obj = object.get(kPostContentObjKey);

	return title.length > 0 && Array.isArray(content_obj) && content_obj.length > 0
};

Parse.Cloud.beforeSave("Post", function ( request, response ) {
	var content = request.object.get(kPostContentObjKey);

	if ( validPost(request.object) ) {
		var firstBlock = content[0].text;
		request.object.set("content_short", firstBlock.substring(0, 180) + "...");
		response.success();
	} else {
		response.error('Cannot save post define content_obj is invalid ' + request.object.get("owner").id);
	}
});


var Post = Parse.Object.extend("Post");

Parse.Cloud.beforeSave("Post", function(request, response) {
  response.success();
});


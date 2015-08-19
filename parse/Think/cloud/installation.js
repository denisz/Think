//ассоциируем устройство с пользователем для отправки ему пушеей
Parse.Cloud.beforeSave(Parse.Installation, function(request, response) {
  Parse.Cloud.useMasterKey();
  if (request.user) {
	  request.object.set('user', request.user);
  } else {
  	request.object.unset('user');
  }
  response.success();
});

json.hyper do
  json.statusCode  200
  json.errorCode  0
  json.version 1.0
  json.href_delete "https://api.your-company.com/v1/users/delete/#{@user.guid.to_s}"
  json.doc "https://api.your-company.com/"
end

json.data do
  json.id             @user.id.to_s
  json.email          @user.email.to_s
  json.givenName      @user.fname.to_s
  json.familyName     @user.lname.to_s
  json.GUID           @user.guid.to_s
end


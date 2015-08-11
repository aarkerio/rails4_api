json.user do
  if @user.nil?
    json.message  'User does not exist.'
  else
    json.first  @user.first
    json.last   @user.last
    json.email  @user.email
  end
end

json.message 'Created successfully'
json.user do
  json.partial! 'users/user', user: @user
end

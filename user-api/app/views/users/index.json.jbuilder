json.array! @users do |user|
  json.partial! 'users/user', user:
end

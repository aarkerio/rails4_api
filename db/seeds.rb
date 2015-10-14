# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

groups = %w(admin users)

groups.each do |group|
  Group.create! name: group, description: group
end

u = User.create! uname: 'admin', email: 'admin@example.com', passwd: 'admin', group_id: 1, guid: 'admin'

# secret_key  = Digest::SHA256.hexdigest('koalacorp')
data = {name: 'Koala Corp', api_key: 'koalacorp', secret_key: '2bfd3972b34942d5277df8f57f45b8c7dfc3088ce4aca7dada433ed5e110f48b', active: true,
       db_name: 'koalacorp', db_user: 'koala',  db_pwd: '12dert66888', db_staging: 'staging-server.your-company.com', db_production: 'prod-server.your-company.com'}
c = Customer.create! data

u = User.create! uname: 'pancho69', fname: 'Pancho', lname: 'Villa', email: 'pancho@example.com', passwd: 'usernormal', group_id: 2, guid: 'bb22Hga45@GG512klq'

u = User.create! uname: 'silvio61', fname: 'Julio', lname: 'Lopez', email: 'lpez@example.com', passwd: 'usernormal', group_id: 2, guid: 'bHH45WWw58912klq'



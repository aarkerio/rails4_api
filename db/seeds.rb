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

u = User.create! uname: 'admin', email: 'admin@example.com', passwd: 'admin', group_id: 1

c = Customer.create! name: 'Koala Corp', api_key: 'koalacorp', secret_key: 'koalacorp', active: true




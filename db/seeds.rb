# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

  ###  Create Roles
puts "\n===  Criando usuarios\n"
  users_attributes = [
    { name: 'secretária 1'},
    { name: 'secretária 2'},
    { name: 'secretária 3'},
    { name: 'secretária 4'},
    { name: 'secretária 5'},
    { name: 'super_admin'}
  ]

  users_attributes.each do |user|
    User.create(user)
  end

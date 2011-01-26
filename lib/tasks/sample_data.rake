require 'faker'

namespace:db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
#    User.create!(:name => "Example User",
#                 :email => "example@railstutorial.org",
#                 :password => "foobar",
#                 :password_confirmation => "foobar")
    100.times do |n|
      name = Faker::Name.name
      email = "example-#{n}@railstutorial.org"
      password = "password"
      user = User.create!( :name => name,
                    :email => email,
                    :password => password,
                    :password_confirmation => password)
      user.toggle!(:admin) if n == 1
    end 
  end
end

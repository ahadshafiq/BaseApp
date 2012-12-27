FactoryGirl.define do 
	factory :user do #converts symbol into a user model
		name("Ahad Shafiq") #name here is a method
		email("ahad@gmail.com")
		password("foobar")
		password_confirmation("foobar")
	end
end


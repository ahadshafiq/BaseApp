FactoryGirl.define do 
	factory :user do #converts symbol into a user model
		sequence(:name){ |n| "Person #{n}"}
		sequence(:email){ |n| "Person_#{n}@example.com"}
		password("foobar")
		password_confirmation("foobar")

		factory :admin do
			admin true
		end
	end
end


require 'spec_helper'

describe User do
  
  	before do
      @user = User.new(name:"Example User", email: "user@example.com",
                       password: "foobar", password_confirmation: "foobar")
    end

  	subject {@user}

  	it { should respond_to(:name) }
  	it { should respond_to(:email) }
  	it { should respond_to(:password_digest) }
    it { should respond_to(:password) }
    it { should respond_to(:password_confirmation) }
    it { should respond_to(:remember_token)}
    it { should respond_to(:admin)}
    it { should respond_to(:authenticate) }
    it { should respond_to(:microposts)}
    it { should respond_to(:feed)}

  	it { should be_valid } #calls this on the subject on the test
    it { should_not be_admin}

    describe "accessible attribute" do
      it "should not allow access to admin" do
        expect do
          User.new(admin:"1")
        end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
      end

    end


  	describe "when name is not present" do
		before { @user.name = " "} #any blank value is invalid 
		it { should_not be_valid }  	
  	end

  	describe "when email is not present" do
  		before { @user.email = " "}
  		it { should_not be_valid}
  	end

  	describe "when name is too long" do
  		before { @user.name = "a"*51} #this is a name that is 51 characters long
  		it { should_not be_valid}
  	end

  	describe "when email format is invalid" do
  		it "should be invalid" do
  			addresses = %w[user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bat+baz.com]
  			addresses.each do |invalid_address|
  				@user.email = invalid_address
  				@user.should_not be_valid
  			end
  		end
 	end

 	describe "when email format is valid" do
 		it "should be valid" do
 			addresses = %w[user@foo.COM A_US-ER@f.b.org first.lst@foo.jp a+b@bax.cn]
 			addresses.each do |valid_addresss|
 				@user.email = valid_addresss
 				@user.should be_valid
 			end
 		end
 	end

 	describe "when an email address is already taken" do
 		before do
 			user_with_same_email = @user.dup #makes a duplicated of the already defined user
 			user_with_same_email.email = @user.email.upcase
 			user_with_same_email.save
 		end
 		it {should_not be_valid}
  	end

  describe "when password is not present" do
    before { @user.password = @user.password_confirmation = " "} #chained assingment
    it { should_not be_valid }
  end

  describe "when password doesn't match the confirmation" do
    before {@user.password_confirmation = "anythingthatisn'tfoobar"}
    it { should_not be_valid}
  end

  describe "when password confirmation is nil" do
    before { @user.password_confirmation = nil}
    it { should_not be_valid}
  end

  describe "when password is too short" do
    before { @user.password = @user.password_confirmation = "a"*5}
    it {should_not be_valid}
  end

  describe "return the value of authenticate method" do
    before { @user.save } #for this test we need to have the user in the memory
    let(:found_user) { User.find_by_email(@user.email)}

    describe "with valid password" do
      it {should == found_user.authenticate(@user.password)}      
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("someinvalidpassword")}  
      it {should_not == user_for_invalid_password}
      specify{ user_for_invalid_password.should be_false}
    end
  end

  describe "Remember token" do
    before {@user.save}
    its(:remember_token) {should_not be_blank}
    # same as:
    # it "should not be blank" do
    #   subject.remember_token.should_not be_blank  
  end

  describe "microposts association" do
    before { @user.save }
      let!(:older_micropost) do
        FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago)
      end
      let!(:newer_micropost) do
        FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago)
      end

    it "should have the right microposts in the right order" do
      @user.microposts.should == [ newer_micropost, older_micropost]
    end

    it "should destory associated microposts" do
      microposts = @user.microposts
      @user.destroy
      microposts.each do |micropost|
        Micropost.find_by_id(micropost.id).should be_nil
      end
    end

    describe "stauts" do
      let(:unfollowed_post) do
       FactoryGirl.create(:micropost, user: FactoryGirl.create(:user))
      end
      its(:feed) { should include(older_micropost)}
      its(:feed) { should include(newer_micropost)}
      its(:feed) { should_not include(unfollowed_post)}
    end
  end
end




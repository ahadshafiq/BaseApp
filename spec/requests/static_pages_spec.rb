require 'spec_helper'

describe "Static pages" do

  subject { page } #page comes for free 

	describe "Home page" do
    before {visit root_path}
    it {should have_selector('h1', text: 'Twitter App')}
		it {should have_selector('title', text: full_title(''))}
		it {should_not have_selector('title', text: '| Home')}

    describe "for signed-in users" do
      let(:user){ FactoryGirl.create(:user)}
      before do
        FactoryGirl.create(:micropost, user: user, content: "Lorem Updsum")
        FactoryGirl.create(:micropost, user: user, content: "Dolor Lorem Updsum")
        sign_in user
        visit root_path
      end

      it "should render teh users' feed" do
        user.feed.each do |item|
          page.should have_selector("li##{item.id}", text: item.content)
        end
      end

      describe "follower/folloing counts" do
        let(:other_user) { FactoryGirl.create(:user)}
        before do
          other_user.follow!(user)
          visit root_path
        end

      it { should have_link("0 following", href: following_user_path(user))}
      it { should have_link("1 followers", href: followers_user_path(user))}
      end
 	  end
  end

	describe "Help page" do
      before {visit help_path}
  		it {should have_selector('h1', text: 'Help')}
  		it {should have_selector('title', text: full_title('Help'))}
  end

  describe "About page" do
      before {visit about_path}
  		it {should have_selector('h1', text: 'About')}
  		it {should have_selector('title', text: full_title('About'))}
  end

  describe "Contact page" do
      before {visit contact_path}
   		it {should have_selector('h1', text: 'Contact')}
   		it {should have_selector('title', text: full_title('Contact'))}
  end

#This
#is
#for the links on the home page

  it "should have the right links on the layout" do
    visit root_path
    click_link "Sign in"
    page.should have_selector 'title', text: full_title('Sign in')
    click_link "About"
    page.should have_selector 'title', text: full_title('About')
    click_link "Help"
    page.should have_selector 'title', text: full_title('Help')
    click_link "Contact"
    page.should have_selector 'title', text: full_title('Contact')
    click_link "Home"
    click_link "Sign up now!"
    page.should have_selector 'title', text: full_title('Sign up')
  end

end
	
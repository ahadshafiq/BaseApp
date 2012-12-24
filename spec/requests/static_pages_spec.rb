require 'spec_helper'

describe "Static pages" do
  
  	describe "Home page" do
  		it "should have the content 'Sample App'" do
  			visit '/static_pages/home' #this is the part of the cabibara which works with rspec 
  			page.should have_selector('h1', :text => 'Sample App')
  		end
  		it "should have the correct base tag" do
  			visit '/static_pages/home' #this is the part of the cabibara which works with rspec 
  			page.should have_selector('title', :text => "Twitter Sample App")
  		end
  		it "should not have a custom page title" do
  			visit '/static_pages/home' #this is the part of the cabibara which works with rspec 
  			page.should_not have_selector('title', :text => '| Home')
  		end
   	 end

	describe "Help page" do
  		it "should have the content 'Help'" do
  			visit '/static_pages/help'
  			page.should have_selector('h1', :text =>'Help')
  		end
  		it "should have the correct title tag" do
  			visit '/static_pages/help' #this is the part of the cabibara which works with rspec 
  			page.should have_selector('title', :text => "Twitter Sample App | Help")
  		end
   	 end

   	describe "About page" do
  		it "should have the content 'About'" do
  			visit '/static_pages/about'
  			page.should have_selector('h1', :text =>'About')
  		end
  		it "should have the correct title tag" do
  			visit '/static_pages/about' #this is the part of the cabibara which works with rspec 
  			page.should have_selector('title', :text => "Twitter Sample App | About")
  		end
   	end

   	describe "Contact page" do
   		it "should have the h1 Contact" do
   			visit '/static_pages/contact'
   			page.should have_selector('h1', :text => 'Contact')
   		end
   		it "should have the correct title tag" do
  			visit '/static_pages/contact' #this is the part of the cabibara which works with rspec 
  			page.should have_selector('title', :text => "Twitter Sample App | Contact")
  		end
   	end


end
	
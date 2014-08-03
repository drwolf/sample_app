require 'spec_helper'

describe "Static pages" do

  subject { page }

  shared_examples_for "all static pages" do
    it { should have_content(heading) }
    it { should have_content(full_title(page_title)) }
  end

  describe "Home page" do
    before { visit root_path }
    let(:heading)    { 'Sample App' }
    let(:page_title) { '' }

    it_should_behave_like "all static pages"
    it { should_not have_content('| Home') }
    
    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: user, content: "Lorem")
        FactoryGirl.create(:micropost, user: user, content: "Ipsum")
        sign_in user
        visit root_path
      end
      
      it "should render the user's feed" do
        user.feed.each do |item|
          page.should have_selector("li##{item.id}", text: item.content)
        end
      end
      
      describe "follower/following counts" do
        let(:other_user) { FactoryGirl.create(:user) }
          before do
            other_user.follow!(user)
            visit root_path
          end
          
          it { should have_link("0 following", href: following_user_path(user)) }
          it { should have_link("1 followers", href: followers_user_path(user)) }
      end    
    end
  end

  describe "Help page" do
    before { visit help_path }
   let(:page_title) { 'Help' }
    
  end

  describe "About page" do
   before { visit about_path }
    let(:page_title) { 'About' }
    
  end

  describe "Contact page" do
    before { visit about_path }
    let(:page_title) { 'Contact' }
    
  end
  
	it "should have the right links on the layout" do
		visit root_path
		click_link "About"  
		page.should have_content("About Us") 
		click_link "Help"
		page.should have_content("Help") 
		click_link "Contact"
		page.should have_content("Contact") 
		click_link "Home"
		click_link "Sign up now!"
		page.should have_content("Sign up") 
		click_link "sample app"
		page.should have_content("sample app") 
	  end
  
  end

require 'spec_helper'

describe 'App' do
  include Rack::Test::Methods

  describe "GET '/'" do
    it "returns a 200 status code" do
      get '/'
      expect(last_response.status).to eq(200)
    end
  end

  describe "Signing Up" do

    it "displays Sign Up Page" do
      get '/signup'
      expect(last_response.body).to include('Username:')
      expect(last_response.body).to include('Password:')
    end

    it "displays the failure page if no username is given" do
      post '/signup', {"username" => "", "password" => "hello"}
      follow_redirect!
      expect(last_response.body).to include('Flatiron Bank Error')
    end

    it "displays the failure page if no password is given" do
      post '/signup', {"username" => "username", "password" => ""}
      follow_redirect!
      expect(last_response.body).to include('Flatiron Bank Error')
    end


  end

  describe "Logging In" do
    it "displays Log In Page" do
      get '/login'
      expect(last_response.body).to include('Username:')
      expect(last_response.body).to include('Password:')
    end

    it "displays the failure page if no username is given" do
      visit '/login'
      fill_in "username", with: ""
      fill_in "password", with: "test"
      click_button "Log In"
      expect(page.body).to include('Flatiron Bank Error')
      expect{page.get_rack_session_key("user_id")}.to raise_error(KeyError)
    end

   

   
  end

  describe "GET '/logout'" do
    it "clears the session" do
      get '/logout'
      expect{page.get_rack_session_key("user_id")}.to raise_error(KeyError)
    end
  end

 

end

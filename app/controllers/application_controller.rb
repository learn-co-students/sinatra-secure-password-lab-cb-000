require "./config/environment"
require "./app/models/user"
class ApplicationController < Sinatra::Base

  configure do
    set :views, "app/views"
    enable :sessions
    set :session_secret, "password_security"
  end

  get "/" do
    erb :index
  end

  get "/signup" do
    erb :signup
  end

  post "/signup" do
    input = ["username", "password"]

    input.each do |data|
<<<<<<< HEAD
      if params[data.to_sym].match(/\s/) != nil || params[data.to_sym].empty?
=======
      if params[data.to_sym] == nil || params[data.to_sym].match(/\s/) != nil
>>>>>>> 0c0aabeb9863fff6717bcda3241e58cec1a4c07c
        redirect '/failure'
        break
      end
    end
<<<<<<< HEAD
    # password = BCrypt::Password.create(params[:password])
=======

>>>>>>> 0c0aabeb9863fff6717bcda3241e58cec1a4c07c
    @user = User.create(username: params[:username], password: params[:password])

    redirect '/login'
  end

  get '/account' do
    erb :account
  end


  get "/login" do
    erb :login
  end

  post "/login" do
    @user = User.find_by(username: params[:username]).try(:authenticate, params[:password]) 

    if (@user == nil)
      redirect '/failure'
    else
      session[:user_id] = @user.id
      redirect '/account'
    end
  end

  get "/failure" do
    erb :failure
  end

  get "/logout" do
    session.clear
    redirect "/"
  end

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end
  end

end

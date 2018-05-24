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
    #your code here
    #@user = User.new
    #@user.username = params[:username]
    #@user.password = params[:password]
    #if @user.save
    if params[:username].empty? || params[:password].empty?
      redirect "/failure"
    else
      user = User.new
      user.username = params[:username]
      user.password = params[:password]
      user.save
      redirect "/login"
    end
  end

  get '/account' do
    @user = User.find(session[:user_id])
    erb :account
  end

  patch '/account/deposit' do
    user = User.find_by_id(session[:user_id])
    user.balance += params[:deposit_amount].to_f
    user.save
    redirect :"/account"
  end

  patch '/account/withdrawal' do
    user = User.find_by_id(session[:user_id])
    if params[:withdrawal_amount].to_f > user.balance
      erb :insufficent_fund
    else
      user.balance -= params[:withdrawal_amount].to_f
      user.save
      redirect :"/account"
    end
  end

  get "/login" do
    erb :login
  end

  post "/login" do
    ##your code here
    login(params[:username], params[:password])
    if logged_in?
      redirect "/account"
    else
      redirect "/failure"
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

    def login(username, password)
      user = User.find_by(:username => username)
      if user && user.authenticate(password)
        session[:user_id] = user.id
        session[:username] = user.username
      else
        session.clear
      end
    end
  end

end

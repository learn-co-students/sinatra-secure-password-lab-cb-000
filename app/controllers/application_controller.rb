require "./config/environment"
require "./app/models/user"
class ApplicationController < Sinatra::Base

  configure do
    set :views, "app/views"
    enable :sessions
    set :session_secret, "password_security"
  end

  get "/" do
    if logged_in?
      redirect "/account"
    else
      erb :index
    end
  end

  get "/signup" do
    erb :signup
  end

  post "/signup" do
    user = User.new(
      username: params[:username],
      password: params[:password],
      balance: 0.00
    )
    if user.save
      redirect "/login"
    else
      redirect "/failure"
    end
  end

  get '/account' do
    @user = User.find(session[:user_id])
    erb :account
  end

  get "/login" do
    erb :login
  end

  post "/login" do
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect "/account"
    else
      redirect "/failure"
    end
  end

  get "/success" do
    if logged_in?
      erb :success
    else
      redirect "/login"
    end
  end

  get "/failure" do
    erb :failure
  end

  get "/deposit" do
    if logged_in?
      erb :deposit
    else
      redirect "/login"
    end
  end

  post "/deposit" do
    @user = current_user
    @user.balance += params[:amount].to_f
    @user.save

    redirect "/account"
  end

  get "/withdrawal" do
    if logged_in?
      erb :withdrawal
    else
      redirect "/login"
    end
  end

  get "/withdrawal/error" do
    erb :"withdrawal_error"
  end

  post "/withdrawal" do
    @amount = params[:amount].to_f
    @user = current_user

    if @user.balance < @amount
      redirect "/withdrawal/error"
    else
      @user.balance -= @amount
      @user.save

      redirect "/account"
    end
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

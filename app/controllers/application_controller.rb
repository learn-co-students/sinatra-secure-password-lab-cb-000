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
      if params[data.to_sym].match(/\s/) != nil || params[data.to_sym].empty?
        redirect '/failure'
        break
      end
    end

    User.new.tap do |u|
      u.first_name = params[:first_name]
      u.last_name = params[:last_name]
      u.username = params[:username]
      u.password = params[:password]
      u.save
    end

    redirect '/login'
  end

  get '/account' do
    accounts = ["checking", "savings"]
    @accounts = Account.where("user_id = ?", current_user.id)

    if @accounts.empty?
      Account.create(account_type: "checking", balance: 0, user_id: current_user.id)
      Account.create(account_type: "savings", balance: 0, user_id: current_user.id)
    end

    @accounts = Account.where("user_id = ?", current_user.id)

    erb :account
  end


  get "/login" do
    erb :login
  end

  post "/login" do
    @user = User.find_by(username: params[:username]).try(:authenticate, params[:password])

    if @user == nil
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

  # Deposit
  get '/deposit' do
    erb :deposit
  end

  post '/deposit' do
    @amount = params[:deposit_amount].to_i

    if @amount == 0
      erb :deposit_error
    else
      @user_checking = Account.find_by(account_type: "checking", user_id: current_user.id)
      @user_checking.balance += @amount
      @user_checking.save

      erb :deposit_success
    end
  end

  # Withdraw
  get '/withdraw' do
    @account = Account.find_by(account_type: "checking", user_id: current_user.id)

    erb :withdraw
  end

  post '/withdraw' do
    @amount = params[:withdraw_amount].to_i
    @user_checking = Account.find_by(account_type: "checking", user_id: current_user.id)

    if @amount > @user_checking.balance || @amount == 0
      erb :withdraw_error
    else
      @user_checking.balance -= @amount
      @user_checking.save

      erb :withdraw_success
    end
  end

  # transfer from checking to savings

  get '/checking_to_savings' do
    
  end

  post '/checking_to_savings' do

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

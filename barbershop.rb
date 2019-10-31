require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'


def get_db
	db = SQLite3::Database.new 'barbershop.db'
	db.results_as_hash = true
	return db
end

configure do
	db = get_db
	db.execute 'CREATE TABLE IF NOT EXISTS "Users" ("id" INTEGER PRIMARY KEY AUTOINCREMENT, "username" TEXT, "phone" TEXT, "date_time" TEXT, "barber" TEXT)'
end

get '/' do
	erb :index
end

get '/visit' do
	erb :visit
end

post '/visit' do

	@user_name = params[:user_name]
	@phone = params[:phone]
	@date_time = params[:date_time]
	@barber = params[:barber]

	hh = { :user_name => 'Enter your name',
		 :phone => 'Enter your phone',
		 :date_time => 'Enter Date and Time'
	}

	@visit_error = hh.select {|key,_| params[key] == ""}.values.join(", ")
	if @visit_error != ""
		return erb :visit
	end

	@title = "Thank you!"
	@message = "Dear #{@user_name}, #{@barber} call you after few minutes and confirm your request or correct it relative by shedule" 
	
	db = get_db
	get_db.execute 'insert into Users (username, phone, date_time, barber) values (?, ?, ?, ?)', [@user_name, @phone, @date_time, @barber]
	
	erb :message
end

get '/services' do
	erb :services
end

get '/about' do
	erb :about
end

get '/contacts' do
	erb :contacts
end

post '/contacts' do
	
	@contact_name = params[:contact_name]
	@contact_email = params[:contact_email]
	@contact_message = params[:contact_message]
	
	ch = { :contact_name => 'Enter your name',
		   :contact_email => 'Enter your email',
		   :contact_message => 'Enter your message'
	}


	@contact_error = ch.select {|key,_| params[key] == ""}.values.join(", ")
	if @contact_error != ""
		return erb :contacts
	end

	@title = "Thank you!"
	@message = "Dear #{@contact_name}, we will try respond your neat time" 
	

	erb :message
end

get '/showusers' do

	db = get_db
	@results = db.execute 'select * from users order by id desc' 
	
	erb :admin
end








require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'

set :database, "sqlite3:barbershop.db"

class Client < ActiveRecord::Base
	validates :name, presence: true, length: { minimum: 3 } #length чисто для понимания текущего синтаксиса 
	validates :phone, presence: true
	validates :datestamp, presence: true
	validates :barber, presence: true
end

class Contact < ActiveRecord::Base
	validates :name, presence: true
	validates :email, presence: true
	validates :message, presence: true
end


get '/' do
	erb :index
end

get '/visit' do
	@c = Client.new
	erb :visit
end

post '/visit' do

	#hh = { :user_name => 'Enter your name',
		 #:phone => 'Enter your phone',
		 #:date_time => 'Enter Date and Time'
	#}

	#@visit_error = hh.select {|key,_| params[key] == ""}.values.join(", ")
	#if @visit_error != ""
		#return erb :visit
	#end

	@c = Client.new params[:client]
	if @c.save
		erb :visit
	else
		@error = @c.errors.full_messages.first
		erb :message
	end

	#@title = "Thank you!"
	#@message = "Dear #{@user_name}, #{@barber} call you after few minutes and confirm your request or correct it relative by shedule" 
	
	#db = get_db
	#get_db.execute 'insert into Users (username, phone, date_time, barber) values (?, ?, ?, ?)', [@user_name, @phone, @date_time, @barber]
	
end

get '/services' do
	erb :services
end

get '/about' do
	erb :about
end

get '/contacts' do
	@contact_form = Contact.new
	erb :contacts
end

post '/contacts' do
	

	@contact_form = Contact.new params[:contact]
	if @contact_form.save
		erb :contacts
	else
		@error = @contact_form.errors.full_messages.first
		erb :message
	end

	#@contact_name = params[:contact_name]
	#@contact_email = params[:contact_email]
	#@contact_message = params[:contact_message]
	
	#ch = { :contact_name => 'Enter your name',
		   #:contact_email => 'Enter your email',
		   #:contact_message => 'Enter your message'
	#}


	#@contact_error = ch.select {|key,_| params[key] == ""}.values.join(", ")
	#if @contact_error != ""
		#return erb :contacts
	#end

	#@title = "Thank you!"
	#@message = "Dear #{@contact_name}, we will try respond your neat time" 
end

get '/showusers' do

	@clients = Client.order('created_at DESC')
	erb :admin

	#db = get_db
	#@results = db.execute 'select * from users order by id desc' 
end








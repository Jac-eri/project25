require 'sinatra'
require 'slim'
require 'sqlite3'
require 'sinatra/reloader'
require 'csv'
require 'bcrypt'

enable:sessions

def connect_to_db(path)
    db = SQLite3::Database.new(path)
    db.results_as_hash = true
    return db
end

def register_user()

end

def login_user(firstname, lastname)
    if firstname == "" || lastname == ""
        session[:name] = nil
    else
        session[:name] = firstname + " " + lastname
    end
    return session[:name]
end

=begin
post('/cards')

end
=end

get ('/start') do
    slim:start
end

get ('/login') do
    slim:forms
end

post ('/loggedin') do
    firstname = params[:firstname]
    lastname = params[:lastname]
    login_user(firstname, lastname)
    session[:type] = "logged in"
    redirect('/result') 
end

post ('/registered') do
    if params[:firstname] == "" || params[:lastname] == ""
        session[:name] = nil
    else
        session[:name] = params[:firstname] + " " + params[:lastname]
    end
    session[:type] = "registered"
    redirect('/result')
end

get ('/result') do
    slim:result
end

=begin
post('/profile')

end
=end


require 'sinatra'
require 'slim'
require 'sqlite3'
require 'sinatra/reloader'
require 'becrypt'

def connect_to_db(path)
    db = SQLite3::Database.new(path)
    db.results_as_hash = true
    return db
end


post('/cards')

end

get ('/start') do
    slim:start
end

get ('/login') do
    slim:forms
end

post ('/loggedin') do
    if params[:firstname] == "" || params[:lastname] == ""
        session[:name] = nil
    else
        session[:name] = params[:firstname] + " " + params[:lastname]
    end
    session[:type] = "logged in"
    redirect('/result')
end

post ('/registered') do
    if params[:firstname] == "" || params[:lastname] == ""
        session[:name] = nil
    else
        session[:name] = params[:firstname] + " " + params[:lastname]
    end
    session[:type] = "rigestered"
    redirect('/result')
end

get ('/result') do
    slim:result
end

post('/profile')

end



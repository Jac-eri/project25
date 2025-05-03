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

db = connect_to_db("db/Cardshop.db")

def register_user(username, password, password_confirmation, db)
    result = db.execute("SELECT UserId FROM Users WHERE Username=?", username)
    if result.empty?
        if password == password_confirmation
            password_digest = BCrypt::Password.create(password)
            db.execute("INSERT INTO Users(Username, Password_digest) VALUES (?, ?)", [username, password_digest])
        else
            raise "Wrong params"
        end
    else 
        raise "Username already exist"
    end
    if username == nil || password == nil || password_confirmation == nil
        set_error("Invalid credentials.")
        redirect('/error')
    end 
    session[:name] = username
    session[:UserId] = result
end

def login_user(username, password, password_confirmation, db)
    result = db.execute("SELECT UserId FROM Users WHERE Username=?", username)
    password_digest = db.execute("SELECT Password_digest FROM Users WHERE Username=?", username)
    p password_digest
    if password != password_confirmation  
        set_error("Passwords don't match.")
        redirect('/error')
    end
    if BCrypt::Password.new(password_digest) == password
        session[:name] = username
        session[:UserId] = result
    else
        raise "Incorrect password"
    end 
end

get ('/start') do
    slim:start
end

get ('/login') do
    slim:forms
end

post ('/loggedin') do
    username = params[:username]
    password = params[:password]
    password_confirmation = params[:password_confirmation]
    db = connect_to_db("db/Cardshop.db")
    login_user(username, password, password_confirmation, db)
    session[:type] = "logged in"
    session[:profile_picture] = db.execute("SELECT Profile_picture FROM Users WHERE UserId=?", session[:UserId])
    redirect('/result') 
end

post ('/registered') do
    username = params[:username]
    password = params[:password]
    password_confirmation = params[:password_confirmation]
    db = connect_to_db("db/Cardshop.db")
    register_user(username, password, password_confirmation, db)
    session[:type] = "logged in"
    session[:profile_picture] = db.execute("SELECT Profile_picture FROM Users WHERE UserId=?", session[:UserId])
    redirect('/result')
end

get ('/result') do
    slim:result
end

get ('/profile') do
    
end

=begin
post('/profile')

end
=end


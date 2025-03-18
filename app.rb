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

def register_user(username, password, password_confirmation)
    result =
    if result.empty?
        if password == password_confirmation
            password_digest = BCrypt::Password.create(password)
            db.execute("INSERT INTO Users(Username, Password_digest) VALUES (?, ?)", [username, password_digest])
            redirect()
        else
            set_error("Passwords don't match.")
            redirect('/error') 
        end
    else 
        set_error("Username already exists.")
        redirect('/error')
    end
    if username == nil || password == nil || password_confirmation == nil
        set_error("Invalid credentials.")
        redirect('/error')
    end 
    session[:UserId] = UserId
end

def login_user(username, password, password_confirmation)
    result = db.execute("SELECT UserId FROM Users WHERE Username=?", username)
    if password != password_confirmation  
        set_error("Passwords don't match.")
        redirect('/error')
    end
    if BCrypt::Password.new(Password_digest) == password
        session[:UserId] = UserId
    else
        set_error("Invalid credentials.")
        redirect('/error')
    end 
end

=begin
get ('/error')

end
=end

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


#flash[:alert] = "A card was successfully added to your profile"
#flash[:alert] = "A card was successfully added to your basket"

post ('/loggedin') do
    username = params[:username]
    password = params[:password]
    password_confirmation = params[:password_confirmation]
    login_user(username, password, password_confirmation)
    session[:type] = "logged in"
    redirect('/result') 
end

post ('/registered') do
    username = params[:username]
    password = params[:password]
    password_confirmation = params[:password_confirmation]
    register_user(username, password, password_confirmation)
    session[:type] = "logged in"
    redirect('/result')
end

get ('/result') do
    slim:result
end

get ('/profile') do
    db = connect_to_db("db/cardshop.db")
    result = db.execute()
end

=begin
post('/profile')

end
=end


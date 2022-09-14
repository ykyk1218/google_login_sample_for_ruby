require 'sinatra'
require 'sinatra/reloader'
require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'googleauth/web_user_authorizer'
require 'debug'

enable :sessions


scopes = [
  'https://www.googleapis.com/auth/structuredcontent',
  'https://www.googleapis.com/auth/content'
]
client_id = Google::Auth::ClientId.from_file('/path/to/credential.json')
token_store = Google::Auth::Stores::FileTokenStore.new(file: 'tokens.yaml')
authorizer = Google::Auth::WebUserAuthorizer.new(client_id, scopes, token_store, '/callback')
user_id = 'hoge'

get '/' do
  erb :index
end

get '/google_login' do
  redirect authorizer.get_authorization_url(login_hint: user_id, request: request)
end

get '/callback' do
  credentials, redirect_uri = authorizer.handle_auth_callback(user_id, request)
  p credentials

  erb :complete
end

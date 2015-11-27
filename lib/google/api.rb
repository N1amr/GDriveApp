require 'fileutils'
require 'google/api_client'
require 'google/api_client/client_secrets'
require 'google/api_client/auth/installed_app'
require 'google/api_client/auth/storage'
require 'google/api_client/auth/storages/file_store'

module API
  module Keys
    API_KEY = 'AIzaSyCQoB7N3u2EKGnEKJOhyyyOtRldvBdalRE'
    CLIENT_ID = '194365586116-n9ken0he959noq55nai6n530s3bf6u5j.apps.googleusercontent.com'
    CLIENT_SECRET = '21hjVr9EnStrQWK-xh6W-NP1'

    APPLICATION_NAME = 'Drive API Ruby Quickstart'
    CLIENT_SECRETS_PATH = 'data/client_secret.json'
    CREDENTIALS_PATH = File.join(Dir.home, '.credentials',"drive-ruby-quickstart.json")
    SCOPE = 'https://www.googleapis.com/auth/drive'

  end

  ##
  # Ensure valid credentials, either by restoring from the saved credentials
  # files or intitiating an OAuth2 authorization request via InstalledAppFlow.
  # If authorization is required, the user's default browser will be launched
  # to approve the request.
  #
  # @return [Signet::OAuth2::Client] OAuth2 credentials
  def self.authorize
    FileUtils.mkdir_p(File.dirname(Keys::CREDENTIALS_PATH))

    file_store = Google::APIClient::FileStore.new(Keys::CREDENTIALS_PATH)
    storage = Google::APIClient::Storage.new(file_store)
    auth = storage.authorize

    if auth.nil? || (auth.expired? && auth.refresh_token.nil?)
      app_info = Google::APIClient::ClientSecrets.load(Keys::CLIENT_SECRETS_PATH)
      flow = Google::APIClient::InstalledAppFlow.new({ :client_id => app_info.client_id, :client_secret => app_info.client_secret, :scope => Keys::SCOPE})
      auth = flow.authorize(storage)
      puts "Credentials saved to #{Keys::CREDENTIALS_PATH}" unless auth.nil?
    end
    auth
  end

  def self.get_client(auth = authorize)
    if(@client.nil?)
      @client = Google::APIClient.new(:application_name => Keys::APPLICATION_NAME)
    @client.authorization = auth
    end
    @client
  end

  def self.get_api(client = get_client)
    @drive_api = client.discovered_api('drive', 'v2') if @drive_api.nil?
    @drive_api
  end
end

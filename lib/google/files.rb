require_relative 'api'
require 'google/api_client'
require 'google/api_client/client_secrets'
require 'google/api_client/auth/installed_app'
require 'google/api_client/auth/storage'
require 'google/api_client/auth/storages/file_store'
require 'fileutils'
require'digest'

module GDrive
  class FileManager
    public
    def initialize(client = API::get_client)
      @client = client
      @drive = API::get_api(@client)
    end

    private

    def download_file(file)
      if file.download_url
        result = @client.execute(:uri => file.download_url)
        if result.status == 200
          md5 = Digest::MD5.new
        md5.update result.body

        return result.body if md5.hexdigest == file.md5Checksum
        else
          puts "An error occurred: #{result.data['error']['message']}"
        end
      else
      # The file doesn't have any content stored on Drive.
      end

      return nil
    end

    def self.save_file(file_content, path)
      File.open(path, 'wb') do |f|
        f.print file_content
      end
    end

    public

    def download_to(file, path)
      content = download_file(file)
      if content
        FileManager.save_file(content, path)
      true
      else
      false
      end
    end

    ##
    # Create a new file
    #
    # @param [Google::APIClient] client
    #   Authorized client instance
    # @param [String] title
    #   Title of file to insert, including the extension.
    # @param [String] description
    #   Description of file to insert
    # @param [String] parent_id
    #   Parent folder's ID.
    # @param [String] mime_type
    #   MIME type of file to insert
    # @param [String] file_name
    #   Name of file to upload
    # @return [Google::APIClient::Schema::Drive::V2::File]
    #   File if created, nil otherwise
    def upload_file(file_name, title = file_name.title, description = nil, mime_type = "image/jpg", parent_id = nil)
      file = @drive.files.insert.request_schema.new({
        'title' => title,
        'description' => description,
        'mimeType' => mime_type
      })
      # Set the parent folder.
      file.parents = [{'id' => parent_id}] if parent_id

      media = Google::APIClient::UploadIO.new(file_name, mime_type)
      result = @client.execute(
      :api_method => @drive.files.insert,
      :body_object => file,
      :media => media,
      :parameters => {
        'uploadType' => 'multipart',
        'alt' => 'json'})
      if result.status == 200
      return result.data
      else
        puts "An error occurred: #{result.data['error']['message']}"
        return nil
      end
    end

    def get_files(dir_id = nil, maxResults = 10)
      results = @client.execute!(:api_method => @drive.files.list,:parameters => { :maxResults => maxResults })
    end
  end

end


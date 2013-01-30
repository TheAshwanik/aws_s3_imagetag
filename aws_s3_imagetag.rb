require 'rubygems'
require 'aws/s3'

module Jekyll
  
  class S3_Image_Uploader      
    def initialize()
        bucket = ENV['AWS_BUCKET']
        access_key_id = ENV['AWS_ACCESS_KEY_ID']
        secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']
        begin
            AWS::S3::Base.establish_connection!( 
              :access_key_id => access_key_id,
              :secret_access_key => secret_access_key)
            
            s3_dir = ENV['S3_DIR']
            
            if s3_dir.empty?
              puts "Environment Variable 'S3_DIR' is not present, Could not upload to S3 bucket"
              return
            end
                  
            Dir.foreach(s3_dir) do |file|
              next if file == '.' or file == '..'
              AWS::S3::S3Object.store( file, File.open(s3_dir + "/" + file), bucket,:access => :public_read)
              puts "Uploaded #{file} to bucket=> #{bucket}!"
            end
        rescue SystemCallError, AWS::S3::ResponseError => error
          # ...
          puts "Exception Occured, Could not upload to S3 bucket => " + error.message
        end
     end
  end
  
  class AWS_S3ImageTag < Liquid::Tag

    def initialize(tag_name, text, token)
      super
      if parts = text.strip.match(/(\w+\.\w+)/)
        @file_name = parts[1].strip
      end
     
      if parts = text.strip.match(/\w*bucket:(.*)\s/)
        @bucket_name = parts[1].strip
      else
        @bucket_name = ENV['AWS_BUCKET']
      end
      
      if parts = text.strip.match(/\w*folder:(.*)/)
        @folder_name = parts[1].strip
      else
        @folder_name = ENV['AWS_BUCKET_FOLDER']
      end
      
      #@bucket_name = @bucket.nil? ? get_config('aws_bucket') : @bucket
      #@folder_name = @folder.nil? ? get_config('aws_bucket_folder') : @folder
    end

    def render(context)
      @custom_domain = ENV['AWS_CUSTOM_DOMAIN']
      
      if (@custom_domain && @folder_name && @file_name)
        "<img src='http://#{@custom_domain}/#{@folder_name}/#{@file_name}'>"
        
      elsif @file_name && @bucket_name
        "<img src='https://s3.amazonaws.com/#{@bucket_name}/#{@folder_name}/#{@file_name}'>"
        
      else
        return "Error processing input, expected syntax: {% s3_image file_name [bucket:bucket_name] [folder:@folder_name] %}"
      end
    end
    
     
    private

    def get_config(string)
      Jekyll.configuration({})[string]
    end
    
  end

end

if ENV['AWS_UPLOAD'] == "true"
  Jekyll::S3_Image_Uploader.new
end
Liquid::Template.register_tag('AWS_S3_Image', Jekyll::AWS_S3ImageTag)

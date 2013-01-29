require 'rubygems'
require 'aws/s3'

module Jekyll
  
  class S3_Image_Uploader      
    def initialize()
        bucket = ENV['AWS_BUCKET']
        access_key_id = ENV['AWS_ACCESS_KEY_ID']
        secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']
        
        AWS::S3::Base.establish_connection!( 
          :access_key_id => access_key_id,
          :secret_access_key => secret_access_key)
        
        s3_dir = ENV['S3_DIR']        
        Dir.foreach(s3_dir) do |file|
          next if file == '.' or file == '..'
          AWS::S3::S3Object.store( file, File.open(s3_dir + "/" + file), bucket,:access => :public_read)
          puts "Uploaded #{file} to bucket=> #{bucket}!"
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
 
    end

    def render(context)
      if @file_name && @bucket_name
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

Jekyll::S3_Image_Uploader.new
Liquid::Template.register_tag('AWS_S3_Image', Jekyll::AWS_S3ImageTag)

# Before run remove from gemfile 
# gem 's3'  
# comment in model photo.rb about s3
# and comment file initialized/paperclip.rb

namespace :photos do
  task :refresh_paths => :environment do
    require 'aws/s3'
    AWS::S3::DEFAULT_HOST = "s3-eu-west-1.amazonaws.com"
    
    # Load credentials
    s3_options = YAML.load_file(File.join(Rails.root, 'config/s3.yml'))[Rails.env].symbolize_keys
  
    bucket = s3_options[:bucket]
    
    # Establish S3 connection
    s3_options.delete(:bucket)
    AWS::S3::Base.establish_connection!(s3_options)
    
    styles = []
    
    # Collect all the styles, all are uploaded because `rake paperclip:refresh CLASS=Photo` is broken for mongoid
    Photo.first.photo.styles.each do |style|
      styles.push(style[0])
    end
    
    # also the :original "style"
    styles.push(:original)
    
    styles.each do |style|
      Photo.all.map{|p| [p.photo.path(style), "/photos/#{p.id}/#{style.to_s}.jpg"]}.each do |p|
        if AWS::S3::S3Object.exists? p[0], bucket
          AWS::S3::S3Object.rename p[0], p[1], bucket
        end
      end
    end

  end

  task :migrate_to_s3 => :environment do
    require 'aws/s3'
    AWS::S3::DEFAULT_HOST = "s3-eu-west-1.amazonaws.com"
    
    # Load credentials
    s3_options = YAML.load_file(File.join(Rails.root, 'config/s3.yml'))[Rails.env].symbolize_keys
  
    bucket = s3_options[:bucket]
    
    # Establish S3 connection
    s3_options.delete(:bucket)
    AWS::S3::Base.establish_connection!(s3_options)
    
    styles = []
    
    # Collect all the styles, all are uploaded because `rake paperclip:refresh CLASS=Photo` is broken for mongoid
    Photo.first.photo.styles.each do |style|
      styles.push(style[0])
    end
    
    # also the :original "style"
    styles.push(:original)
    
    # Process each attachment
    Photo.all.each_with_index do |attachment, n|
      styles.each do |style|
        begin
          path = attachment.photo.path(style)
          puts path
          file = File.new(path, 'rb')
        rescue
          next
        end
        
        begin
          AWS::S3::S3Object.store(path, file, bucket, :access => :public_read)
        rescue AWS::S3::NoSuchBucket => e
          AWS::S3::Bucket.create(bucket)
          retry
        rescue AWS::S3::ResponseError => e
          raise
        end
        
        puts "Saved #{path} to S3 (#{n}/#{Photo.count})"
      end
    end
  end
end
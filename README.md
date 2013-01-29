aws_s3_imagetag
===============
An example plugin for Octopress. 
An octopress plugin to upload files to AWS S3 account and Provide a tag to reference the files in your views.s3_image_tag

Place your files under the directory defined as your env S3_DIR (see enviroment variables below). When you generate your site the files will be 
uploaded to your S3 AWS account. and then you can use the tag 'AWS_S3_Image' which allows you reference images we just hosted on Amazon S3 
within your posts.  A bit of a contrived example, but it demonstrates the process of creating custom Liquid tags.

To use it, just host some place some images in $S3_DIR (they will be made publicly accessible) and use the tag with the syntax    
    {% AWS_S3_Image filename [bucket:bucket_name] [folder:folder_name] %}.

If you don't specify a bucket name and folder name in the view, it will look for an environment variable.


Environment Variable   
--------------------    

export AWS_BUCKET=your bucket name    
export AWS_BUCKET_FOLDER=folder name   \#if any   
export AWS_ACCESS_KEY_ID=Your S3 Access Key    
export AWS_SECRET_ACCESS_KEY=Your S3 Secret key   
export S3_DIR=source/images/TO_S3    

Example
-------
    Here is an image:  {% AWS_S3_Image ash2.jpg bucket:my.bucket folder:friends/avatars/000/000/003/original %}  
    Here is an image:  {% AWS_S3_Image myimage.jpg %}  # with configuration used form _config.yml    
    
Note that this is an extension to s3_image_tag, you can find [here](https://github.com/TheAshwanik/s3_image_tag)
and [here](https://github.com/jmartin2683/s3_image_tag)    

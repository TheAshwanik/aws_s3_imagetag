aws_s3_imagetag
--------------------    

An octopress plugin to upload files to AWS S3 account and Provide a tag to reference the files in your views.

Place your files under the directory defined as your env variable S3_DIR (see environment variables below). 
When you generate your site the files will be uploaded to your S3 AWS account. and then you can use the 
tag 'AWS_S3_Image' which allows you reference images we just hosted on Amazon S3 within your posts.   
A bit of a contrived example, but it demonstrates the process of creating custom Liquid tags.   

To use it, just place some images in $S3_DIR (they will be uploaded and made publicly accessible) and use 
the tag with the syntax:    
    
    {% AWS_S3_Image filename [bucket:bucket_name] [folder:folder_name] %}.

If you don't specify a bucket name and folder name in the view as shown above, it will look for an environment variable.


Environment Variable     
--------------------    
(I did not want to expose the credential, so using ENV variables )    

    export AWS_BUCKET=your bucket name     
    export AWS_BUCKET_FOLDER=folder name   \# if your images are under a folder inside the bucket        
    export AWS_ACCESS_KEY_ID=Your S3 Access Key     
    export AWS_SECRET_ACCESS_KEY=Your S3 Secret key     
    export S3_DIR=source/images/TO_S3   \# Directory from where the files will be uploaded     
    export AWS_UPLOAD=true    \# set false if you dont want to upload and just use the tag to refer s3 images/files    
    \# If you want to avoid referencing the annoyingly long aws s3 url, you can set your custom domain url 
    and set it as an env variable     
    export AWS_CUSTOM_DOMAIN=pics.mydomain.co.in     

Example
-------
    Here is an image:  {% AWS_S3_Image ash2.jpg bucket:my.bucket folder:friends/avatars/000/000/003/original %}  
    Here is an image:  {% AWS_S3_Image myimage.jpg %}  # with configuration used form _config.yml    
    
Note that this is an extension to s3_image_tag, you can find [here](https://github.com/TheAshwanik/s3_image_tag)
and [here](https://github.com/jmartin2683/s3_image_tag)    

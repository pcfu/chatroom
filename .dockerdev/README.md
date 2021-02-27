# How to Create New Project in Docker Container for Development

## * Note:
By default, docker commands are run as root user.  
To run command as a non-root user, add user to the `docker` user group, and restart `docker.service` .  
*(Google if you don't know how to do this)*

## Build the container images

1. Install `Docker` and `Docker Compose`

2. Open `.env` and set the project name *(this will be the name of the project directory in the container)*
```
PROJECT_NAME=<desired project name>
```

3. Build the container image
```
# docker-compose build
```

## Prepare project files

1. Start a shell to project container
```
# docker-compose run runner
```

2. Create a new rails project
```
# rails new . --skip-active-record --skip-bundle
```

    The directory (containing `docker-compose.yml`) on the **host machine** will be mounted to the project directory in the **container** .  
Hence, the project files created in the container will also be available on the host machine.  
However, they will be owned by the root user. The next step changes ownership of the files to allow editing.

3. Cd to project directory and change ownership of project files on the **host machine**
```
$ sudo chown -R <username>. .
```

4. Open `Gemfile` and add Mongoid
```
gem 'mongoid', '~> 7.2', '>= 7.2.1'
```

5. On project **container**, install required gems
```
# bundle install
```

6. Create `config/initializers/fix_mongoid_generator.rb` *(Mongoid >= 7.3 may fix this bug)*

        require 'rails/generators'
        require 'rails/generators/mongoid/config/config_generator'  
  
        Mongoid::Generators::ConfigGenerator.class_eval do
          def app_name
            Rails::Application.subclasses.first.module_parent_name.underscore
          end
        end

7. Configure Mongoid
```
# rails g mongoid:config  
```
Open `config/mongoid.yml` and change all hosts to:

        hosts:
          - <%= ENV['DATABASE_URL'] %>

8. Install webpacker
```
# rails webpacker:install
```


## Start Server
1. Start server process from the host machine
```
# docker-compose run --service-ports rails
```  

## References
- https://docs.docker.com/get-started/
- https://evilmartians.com/chronicles/ruby-on-whales-docker-for-ruby-rails-development
- https://www.bmc.com/blogs/mongodb-docker-container/

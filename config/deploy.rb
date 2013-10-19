require 'mina/git'
require 'mina/bundler'

# Basic settings:
set :domain, '173.255.244.61'
set :port, '22'
set :deploy_to, '/var/www/db/mongodb'
set :repository, 'https://github.com/pasviegas/vagrant-precise64-mongodb.git'
set :branch, 'master'

# Optional settings:
set :user, 'root'    # Username in the server to SSH to.
set :term_mode, :system

# This task is the environment that is loaded for most commands, such as
task :environment do
end

# Put any custom mkdir's in here for when `mina setup` is ran.
task :setup => :environment do
    queue! %[mkdir -p "#{deploy_to}/shared/log"]
    queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/log"]
    
    queue! %[mkdir -p "#{deploy_to}/shared/config"]
    queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/config"]
end

desc "Starts the mongo vm"
task :up => :environment do
    queue 'bundle exec vagrant up'
end

desc "Stops the mongo vm"
task :down => :environment do
    queue 'bundle exec vagrant destroy'
end

desc "Deploys the current version to the server."
task :deploy => :environment do
    deploy do
        invoke :'git:clone'
        invoke :'bundle:install'
        invoke :up
        
        to :launch do
            queue "touch #{deploy_to}/tmp/restart.txt"
        end
    end
end

require "rubygems"
require 'rake'
require 'yaml'
require 'time'

server = "oceania"
compose_file = "docker-composer.prod.yml"
image_tag = "easyappointments:latest"
image_tar = "easyappointments.tar"
destination_path = "/var/www/easyappointments"

desc "Init"
task :init do
  system "scp .env #{server}:#{destination_path}"
  system "scp #{compose_file} #{server}:#{destination_path}/docker-compose.yml"
end

desc "Deploy"
task :deploy do
  puts "Building image ..."
  exec "docker-compose -f docker-compose.prod.yml build"
  puts "Saving image ..."
  system "docker save -o #{image_tar} #{image_tag}"
  puts "Transferring image ..."
  system "scp #{image_tar} #{server}:#{destination_path}"
  puts "Importing image into remote docker ..."
  system "ssh #{server} -C docker load -i #{destination_path}/#{image_tar}"
end

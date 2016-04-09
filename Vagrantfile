# encoding: utf-8
# This file originally created at http://rove.io/d0d3f9b9942b49cf97fed0627856516e

# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "opscode-ubuntu-12.04_chef-11.4.0"
  config.vm.box_url = "https://opscode-vm-bento.s3.amazonaws.com/vagrant/opscode_ubuntu-12.04_chef-11.4.0.box"
  config.ssh.forward_agent = true

  config.vm.network :forwarded_port, guest: 3000, host: 3000

   config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048"
   end

  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = ["cookbooks"]
    chef.add_recipe :apt
    chef.add_recipe 'postgresql::server'
    chef.add_recipe 'rvm::vagrant'
    chef.add_recipe 'rvm::system'
    chef.add_recipe 'git'
    chef.add_recipe 'nodejs'
    chef.json = {
      :postgresql => {
        :config   => {
          :listen_addresses => "*",
          :port             => "5432"
        },
        :pg_hba   => [
          {
            :type   => "local",
            :db     => "postgres",
            :user   => "postgres",
            :addr   => nil,
            :method => "trust"
          },
          {
            :type   => "host",
            :db     => "all",
            :user   => "all",
            :addr   => "0.0.0.0/0",
            :method => "md5"
          },
          {
            :type   => "host",
            :db     => "all",
            :user   => "all",
            :addr   => "::1/0",
            :method => "md5"
          }
        ],
        :password => {
          :postgres => "password"
        }
      },
      :rvm => {
        :rubies => [
          "2.2.2"
        ],
        :default_ruby => "2.2.2",
        :global_gems => [
          { :name => "bundler" }
        ]
      },
      :git        => {
        :prefix => "/usr/local"
      }
    }
  end

  config.vm.provision :shell, path: "vagrant_scripts/after_script.sh"
end

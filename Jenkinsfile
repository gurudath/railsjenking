#!/usr/bin/env groovy

pipeline {

  agent any

  options {
    timeout(time: 90, unit: 'MINUTES')
  }

  environment {
    LANG="C"
    LC_ALL="en_US.UTF-8"
  }

  stages {
    stage('PreReqs') {
      steps {
        cleanWs()
        checkout scm
        ansiColor('RSpec') {
          echo 'Setting Up The RSpec Requirements'
          sh 'gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB'
          sh 'curl -sSL https://get.rvm.io | bash'
          sh 'curl -sSL https://get.rvm.io | bash -s stable --ruby'
          sh 'source ~/.rvm/scripts/rvm'
          sh 'gem install bundle'
          sh 'bundle install'
        }
      }
    }
    stage('SetupRails') {
      steps {
        ansiColor('RSpec') {
          echo 'Setting up the Rails Migration'
          sh 'bundle exec rake db:drop db:create db:migrate db:seed RAILS_ENV=test'
        }
      }
    }
    stage('ValidateRuboCop') {
      steps {
        ansiColor('RSpec') {
          echo 'Running RSPEC'
          sh 'bundle exec rspec'
        }
      }
    }
  }
}

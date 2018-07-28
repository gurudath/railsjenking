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
          sh 'sudo chmod 777 -R /var/lib/gems/2.3.0'
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

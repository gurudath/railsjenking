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
          sh 'export RAILS_ENV=test'
          sh 'source $HOME/.bashrc'
          sh 'cd .''
          sh 'rvmsudo gem install bundle'
          sh 'bundle install'
        }
      }
    }
    stage('SetupRails') {
      steps {
        ansiColor('RSpec') {
          sh 'bundle exec rake db:drop db:create db:migrate db:seed RAILS_ENV=test'
        }
      }
    }
    stage('ValidateRuboCop') {
      steps {
        ansiColor('RSpec') {
          sh 'bundle exec rspec'
        }
      }
    }
  }
}

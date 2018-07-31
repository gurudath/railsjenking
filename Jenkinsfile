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
          echo 'Setting Up The RSpec Requirements Final'
          sh 'gem install bundle'
          sh 'bundle install'
        }
      }
    }
    stage('SetupRails') {
      steps {
        ansiColor('RSpec') {
          echo 'Setting up the Rails Migration Final'
          sh 'bundle exec rake db:drop db:create db:migrate db:seed RAILS_ENV=test'
        }
      }
    }
    stage('ValidateRuboCop') {
      steps {
        ansiColor('RSpec') {
          echo 'Running RSPEC Final '
          sh 'bundle exec rspec'
        }
      }
    }
    stage('Docker Build') {
      when {
        branch 'master'
      }
      steps {
        script {
          app = docker.build("gurudath/jenkinstest")
          app.inside {
            sh 'echo $(curl localhost:3000)'
          }
        }
      }
    }
    stage('Docker Hub Push') {
      when {
        branch 'master'
      }
      steps {
        script {
              docker.withRegistry('https://registry.hub.docker.com','DockerHub') {
              app.push("${env.BUILD_NUMBER}")
              app.push("latest")
            }
          }
        }
      }
      stage('DeployToProduction') {
          when {
              branch 'master'
          }
          steps {
              input 'Deploy to Production?'
              milestone(1)
              withCredentials([usernamePassword(credentialsId: 'gurudathbn1.mylabserver.com', usernameVariable: 'user', passwordVariable: 'gurudath')]) {
                  script {
                      sh "sshpass -p gurudath -v ssh -o StrictHostKeyChecking=no user@$prod_ip \"docker pull gurudath/jenkinstest:${env.BUILD_NUMBER}\""
                      try {
                          sh "sshpass -p gurudath -v ssh -o StrictHostKeyChecking=no user@$prod_ip \"docker stop jenkinstestprod\""
                          sh "sshpass -p gurudath -v ssh -o StrictHostKeyChecking=no user@$prod_ip \"docker rm jenkinstestprod\""
                      } catch (err) {
                          echo: 'caught error: $err'
                      }
                      sh "sshpass -p 'gurudath' -v ssh -o StrictHostKeyChecking=no $USERNAME@$prod_ip \"docker run --restart always --name jenkinstestprod -p 3000:3000 -d gurudath/jenkinstest:${env.BUILD_NUMBER}\""
                  }
              }
          }
      }
    }
}

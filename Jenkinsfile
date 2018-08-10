#!/usr/bin/env groovy

pipeline {

  agent any

  options {
    timeout(time: 90, unit: 'MINUTES')
  }

  environment {
      DOCKER_IMAGE_NAME = "gurudath/jenkinstest"
  }

  stages {
    stage('PreReqs') {
      steps {
        cleanWs()
        checkout scm
        ansiColor('RSpec') {
          echo 'Setting Up The RSpec Requirements Final'
        }
      }
    }
    stage('Docker Build') {
      when {
        branch 'local'
      }
      steps {
        script {
          app = docker.build("gurudath/jenkinstest")
          app.inside {
            sh 'echo Hello World'
            sh 'echo $(curl localhost:30000)'
          }
        }
      }
    }
    stage('Docker Hub Push') {
      when {
        branch 'local'
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
              branch 'local'
          }
          steps {
              input 'Deploy to Production?'
              milestone(1)
              kubernetesDeploy(
                  kubeconfigId: 'kubeconfig',
                  configs: 'rails-jenkins-kube.yml',
                  enableConfigSubstitution: true
              )
          }
      }
    }
}

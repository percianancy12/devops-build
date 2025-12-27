pipeline {
  agent any

  environment {
    DOCKERHUB_CREDENTIALS = credentials('dockerhub-creds')
  }

  stages {
    stage('Build Docker Image') {
      steps {
        sh 'bash build.sh'
      }
    }

    stage('Push to DockerHub') {
      steps {
        script {
          if (env.BRANCH_NAME == 'dev') {
            sh """
              echo ${DOCKERHUB_CREDENTIALS_PSW} | docker login -u ${DOCKERHUB_CREDENTIALS_USR} --password-stdin
              docker tag react-app:latest percianancy/dev:latest
              docker push percianancy/dev:latest
            """
          } else if (env.BRANCH_NAME == 'main') {
            sh """
              echo ${DOCKERHUB_CREDENTIALS_PSW} | docker login -u ${DOCKERHUB_CREDENTIALS_USR} --password-stdin
              docker tag react-app:latest percianancy/prod:latest
              docker push percianancy/prod:latest
            """
          }
        }
      }
    }

    stage('Deploy') {
      steps {
        script {
          if (env.BRANCH_NAME == 'dev') {
            sh 'bash deploy.sh dev'
          } else if (env.BRANCH_NAME == 'main') {
            sh 'bash deploy.sh prod'
          }
        }
      }
    }
  }
}
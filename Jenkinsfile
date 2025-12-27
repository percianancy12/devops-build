pipeline {
  agent any

  environment {
    DOCKERHUB_CREDENTIALS = credentials('dockerhub-creds')
  }

  parameters {
    choice(name: 'ENVIRONMENT', choices: ['dev', 'prod'], description: 'Select environment to deploy')
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
          if (params.ENVIRONMENT == 'dev') {
            sh """
              docker login -u ${DOCKERHUB_CREDENTIALS_USR} -p ${DOCKERHUB_CREDENTIALS_PSW}
              docker tag react-app:latest percianancy/dev:latest
              docker push percianancy/dev:latest
            """
          } else {
            sh """
              docker login -u ${DOCKERHUB_CREDENTIALS_USR} -p ${DOCKERHUB_CREDENTIALS_PSW}
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
          if (params.ENVIRONMENT == 'dev') {
            sh 'bash deploy.sh dev'
          } else {
            sh 'bash deploy.sh prod'
          }
        }
      }
    }
  }
}
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
          // Detect branch name from GIT_BRANCH (e.g., "origin/dev" or "origin/main")
          def branch = env.GIT_BRANCH?.replaceFirst(/^origin\//, '')

          if (branch == 'dev') {
            sh """
              echo ${DOCKERHUB_CREDENTIALS_PSW} | docker login -u ${DOCKERHUB_CREDENTIALS_USR} --password-stdin
              docker tag react-app:latest percianancy/dev:latest
              docker push percianancy/dev:latest
            """
          } else if (branch == 'main') {
            sh """
              echo ${DOCKERHUB_CREDENTIALS_PSW} | docker login -u ${DOCKERHUB_CREDENTIALS_USR} --password-stdin
              docker tag react-app:latest percianancy/prod:latest
              docker push percianancy/prod:latest
            """
          } else {
            echo "Branch ${branch} not handled"
          }
        }
      }
    }

    stage('Deploy') {
      steps {
        script {
          def branch = env.GIT_BRANCH?.replaceFirst(/^origin\//, '')

          if (branch == 'dev') {
            sh 'bash deploy.sh dev'
          } else if (branch == 'main') {
            sh 'bash deploy.sh prod'
          } else {
            echo "Branch ${branch} not handled"
          }
        }
      }
    }
  }
}
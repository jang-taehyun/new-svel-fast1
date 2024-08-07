pipeline {
  agent any
  environment {
    GITNAME = 'jang-taehyun'
    GITMAIL = 'jth0202@naver.com'
    GITWEBADD = 'https://github.com/jang-taehyun/fast-code.git'
    GITSSHADD = 'git@github.com:jang-taehyun/deployment.git'
    GITCREDENTIAL = 'git_cre'
    DOCKERHUB = 'ajduxj/fast'
    DOCKERHUBCREDENTIAL = 'docker_cre'
  }

  stages {
    stage('start') {
      steps {
	    sh "echo Hello jenkins!!"
      }
      post {
	    failure { sh "echo failed" }
	    success { sh "echo success"}
      }
    }

    stage('check out github') {
      steps {
        checkout([$class: 'GitSCM', branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[credentialsId: GITCREDENTIAL, url: GITWEBADD]]])
      }
      post {
        failure { sh "echo git clone failed" }
        success { sh "echo git clone success"}
      }
    }

    stage('build docker image') {
      steps {
            sh "docker build -t ${DOCKERHUB}:${currentBuild.number} ."
            sh "docker build -t ${DOCKERHUB}:latest ."
      }
      post {
        failure { sh "echo docker build failed" }
        success { sh "echo docker build success"}
      }
    }

    stage('docker image push') {
      steps {
           withDockerRegistry(credentialsId: DOCKERHUBCREDENTIAL, url: '') {
                    sh "docker push ${DOCKERHUB}:${currentBuild.number}"
                    sh "docker push ${DOCKERHUB}:latest"
            }
      }
      post {
        failure {
          sh "echo docker image push failed"
          sh "docker image rm -f ${DOCKERHUB}:${currentBuild.number}"
          sh "docker image rm -f ${DOCKERHUB}:latest"
          }
        success {
          sh "echo docker image push success"
          sh "docker image rm -f ${DOCKERHUB}:${currentBuild.number}"
          sh "docker image rm -f ${DOCKERHUB}:latest"
          }
      }
    }

    stage('EKS manifest file update') {
      steps {
          git credentialsId: GITCREDENTIAL, url: GITSSHADD, branch: 'main'
          sh "git config --global user.email ${GITMAIL}"
          sh "git config --global user.name ${GITNAME}"
          sh "sed -i 's@${DOCKERHUB}:.*@${DOCKERHUB}:${currentBuild.number}@g' fast.yml"

          sh "git add ."
          sh "git branch -M main"
          sh "git commit -m 'fixed tag ${currentBuild.number}'"
          sh "git remote remove origin"
          sh "git remote add origin ${GITSSHADD}"
          sh "git push origin main"

          slackSend (
                    channel: '#dep-qwer',
                    color: '#FFFF00',
                    message: "STARTED: ${currentBuild.number}"
                )

      }
      post {
        failure {
          sh "echo manifest file update failed"
          }
        success {
          sh "echo manifest file update success"
          }
      }
    }
  }
}

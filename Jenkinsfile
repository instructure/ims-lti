pipeline {
  agent {
    label 'docker'
  }

  stages {
    stage('Deploy') {
      // when {
      //   allOf {
      //     expression { GIT_BRANCH == "master" }
      //   }
      // }
      steps {
        lock( // only one build enters the lock
          resource: "${env.JOB_NAME}" // use the job name as lock resource to make the mutual exclusion only for builds from the same branch/tag
        ) {
          withCredentials([string(credentialsId: 'rubygems-rw', variable: 'GEM_HOST_API_KEY')]) {
            sh 'docker-compose run -e GEM_HOST_API_KEY --rm app /bin/bash -lc "./bin/publish.sh"'
          }
        }
      }
    }
  }
}

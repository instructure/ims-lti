pipeline {
  agent { label 'docker' }

  stages {
    stage('Test') {
      matrix {
        agent { label 'docker' }
        axes {
          axis {
            name 'RUBY_VERSION'
            values '2.7', '3.0', '3.1'
          }
        }
        stages {
          stage('Build') {
            steps {
              timeout(10) {
                sh "docker-compose build --pull --build-arg RUBY_VERSION=${RUBY_VERSION} app"
                sh 'docker-compose run --rm app rspec --tag \\~slow'
              }
            }
          }
        }
      }
    }
    stage('Deploy') {
      when {
        allOf {
          expression { GIT_BRANCH == "1.2.x" }
        }
      }
      steps {
        lock( // only one build enters the lock
          resource: "${env.JOB_NAME}" // use the job name as lock resource to make the mutual exclusion only for builds from the same branch/tag
        ) {
          withCredentials([string(credentialsId: 'rubygems-rw', variable: 'GEM_HOST_API_KEY')]) {
            sh 'docker-compose build'
            sh 'docker-compose run -e GEM_HOST_API_KEY --rm app /bin/bash -lc "./bin/publish.sh"'
          }
        }
      }
    }
  }
}

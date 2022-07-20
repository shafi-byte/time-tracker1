pipeline {
    agent any
  tools{
    maven '3.8.6'
  }
    stages {
        stage('Checkout Git Code') {
            steps {
                git branch: 'develop', url: 'https://github.com/ErAdarshChauhan/time-tracker.git'
            }
        }
        stage('clean, install and build') {
            steps {
                bat 'mvn clean install'
            }
        }
         stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube Server'){
                    bat 'mvn sonar:sonar'
                }
            }
        }
      stage('packaging') {
            steps {
                bat 'mvn package'
            }
        }
        stage('Server') {
            steps {
              rtServer (
               id: "Artifactory",
               url: 'https://javalearners.jfrog.io/artifactory',
              username: '<jfrog_user_username>',
               password: '<jfrog_user_pasword>',
               bypassProxy: true,
               timeout: 300
              )
            }
        }
      
      stage('upload artifactory') {
            steps {
              rtUpload (
               serverId: "Artifactory",
                 spec: '''{
                        "files": [
                            {
                              "pattern": "*.war",
                              "target": "javalearners-libs-snapshot-local"
                            }
                         ]
                 }'''
              )
            }
        }
      stage('publish build info') {
            steps {
              rtPublishBuildInfo (
                     serverId: 'Artifactory'
                 )
              }
        }
    }
}

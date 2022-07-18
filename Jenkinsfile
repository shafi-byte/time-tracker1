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
               username: 'jfroguser',
               password: 'Jfrog@12345',
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

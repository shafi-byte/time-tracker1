pipeline {
  agent any
  tools {
    maven 'maven-3.9.6' 
  }
  stages {
    stage ('Build') {
      steps {
        sh 'mvn clean package'
      }
    } 
    stage ('Test')  {
      steps {
        echo ('Testing done')
      }  
    }
     stage ('Deploy')  {
      steps {
        echo ('deploying')
      }  
    }
     
  }
}
  

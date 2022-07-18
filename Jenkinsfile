pipeline {
  agent any
  tools {
    maven 'Maven'
  }
  stages {
    stage ('Initialize') {
      steps {
        sh '''
              echo "PATH = ${PATH}"
              echo "M2_HOME = ${M2_HOME}"
           '''   
      }
    }
     stage ('Build') {
      steps {
      sh 'mvn clean package'
       }
    }
    stage ('Deploy-To-Tomcat') {
      steps{
        sshagent(['Tomcat']) {
          sh 'scp -o StrictHostKeyChecking=no target/*.war ubuntu@65.0.21.164:/home/ubuntu/prod/apache-tomcat-9.0.64/webapps/webapp.war'
        }
      }

  }
}

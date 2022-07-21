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
    
    stage ('Check-Git-Secrets') {
      steps {
        sh 'rm trufflehog || true'
        sh 'docker run gesellix/trufflehog --json https://github.com/janardanpari/devsecops-test-2.git > trufflehog'
        sh 'cat trufflehog'
      }
    }
    
    stage ('Source Composition Analysis') {
      steps {
        
         dependencyCheck additionalArguments: 'scan="https://github.com/janardanpari/devsecops-test-2" --format HTML', odcInstallation: 'OWASP-Dependency-Check'
        
//          sh 'rm owasp* || true'
//          sh 'wget "https://raw.githubusercontent.com/janardanpari/devsecops-test-2/master/owasp-dependency-check.sh" '
//          sh 'chmod +x owasp-dependency-check.sh'
//          sh 'bash owasp-dependency-check.sh'
//          sh 'cat /var/lib/jenkins/OWASP-Dependency-Check/reports/dependency-check-report.xml'
        
      }
    }
   
    
     stage ('Build') {
      steps {
      sh 'mvn clean package'
       }
    }
    
    stage('SonarQube analysis'){
      steps{
        withSonarQubeEnv('sonarqube'){
          sh "mvn sonar:sonar"
        }
      }
    }
    
    stage ('Deploy-To-Tomcat') {
      steps{
        sshagent(['Tomcat']) {
          sh 'scp -o StrictHostKeyChecking=no target/*.war ubuntu@65.0.21.164:/prod/apache-tomcat-9.0.64/webapps/webapp.war'
          sh 'scp -o StrictHostKeyChecking=no /var/lib/jenkins/workspace/DevSecOps-1/./dependency-check-report.html ubuntu@65.0.21.164:/prod/apache-tomcat-9.0.64/webapps/'
        }
      }
    }
  }
}

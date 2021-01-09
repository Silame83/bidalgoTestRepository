pipeline {


  agent { label 'lamp' }

  stages {
    
    stage('Execute command') {
      steps{
        sh 'pip3 install pymysql'
        sh 'python3 commitLogger.py'
      }
    }

  }

}

pipeline {
    agent any
    stages {
        stage('Checkout Stage') {
            steps {
                git branch: 'main', credentialsId: 'DoctorpatientPortal', url: 'https://github.com/Abhilash-1201/Doctor-Patient-Portal.git'
            }
        }
        stage('Code Quality Check Via SonarQube'){
            steps{
                script{
                    sh "/opt/sonar-scanner/bin/sonar-scanner"
                } 
            }
        }
    }
}


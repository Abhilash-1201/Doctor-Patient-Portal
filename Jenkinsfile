pipeline {
    agent any
     tools {maven "MAVEN"}
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
        stage('Email Notification') {
            steps {
                script {
                    def qg = sh(returnStdout: true, script: 'curl -s -u admin:abhi "http://3.19.70.196:9000/api/qualitygates/project_status?projectKey=DoctorPatientPortal" | jq -r .projectStatus.status').trim()
           
                    if (qg == 'ERROR' || qg == 'OK') {
                    mail to: "rlabhilashabhi07@gmail.com",
                    subject: "SonarQube Analysis Notification",
                    body: qg == 'ERROR' ? "SonarQube analysis passed \n\n\n Hi Team,\n\n\nPlease find the SonarQube Analysis Report with credentials below\n\n\nSonarQube Analysis Report : http://3.17.12.228:9000/dashboard?id=DoctorPatientPortal\n\n\n login=admin\npassword=abhi\n\n\nRegards\nAbhilash" :
                                          "SonarQube analysis failed \n\n\n Hi Team,\n\n\nPlease find the SonarQube Analysis Report with credentials below\n\n\nSonarQube Analysis Report : http://3.17.12.228:9000/dashboard?id=DoctorPatientPortal\n\n\nlogin=admin\npassword=abhi\n\n\nRegards\nAbhilash"
                    }
                }
            }
        }
        stage("Build") {
          steps {
            git branch: 'main', credentialsId: 'DoctorpatientPortal', url: 'https://github.com/Abhilash-1201/Doctor-Patient-Portal.git'
            withMaven(maven: 'MAVEN') {
              sh "mvn clean package"
            } // withMaven will discover the generated Maven artifacts, JUnit Surefire & FailSafe reports and FindBugs reports
          }
        }
    }
}


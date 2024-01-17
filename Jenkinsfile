pipeline {
    agent any
     tools {maven "MAVEN"}
     environment { 
        SCANNER_HOME = tool 'SonarQubeScanner'
        devregistry = "nayab786/testrepo:${env.BUILD_NUMBER}"
        // This can be nexus3 or nexus2
        NEXUS_VERSION = "nexus3"
        // This can be http or https
        NEXUS_PROTOCOL = "http"
        // Where your Nexus is running
        NEXUS_URL = "3.138.244.213:8081"
        // Repository where we will upload the artifact
        NEXUS_REPOSITORY = "DoctorPortal"
        // Jenkins credential id to authenticate to Nexus OSS
        NEXUS_CREDENTIAL_ID = "nexusCredential"
        ARTIFACT_VERSION = "${BUILD_NUMBER}"
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials')
        APP_NAME = "testrepo"
        RELEASE = "1.0.0"
        DOCKER_USER = "nayab786"
        DOCKER_PASS = 'nayab786'
        IMAGE_NAME = "${DOCKER_USER}" + "/" + "${APP_NAME}"
        IMAGE_TAG = "${RELEASE}-${BUILD_NUMBER}"
	    JENKINS_API_TOKEN = credentials("JENKINS_API_TOKEN")
        DOCKERHUB_USERNAME = "nayab786"
        DOCKERHUB_PASSWORD = "nayab786"
    }
    stages {
        stage("Cleanup Workspace"){
                steps {
                cleanWs()
                }
        }
        stage('Checkout Stage') {
            steps {
                git branch: 'main', credentialsId: 'GitHub-CREDS', url: 'https://github.com/Abhilash-1201/Doctor-Patient-Portal.git'
            }
        }
        stage('Code Quality Check Via SonarQube'){
            steps{
              withSonarQubeEnv(installationName: 'SonarQube',credentialsId: 'sonartoken'){
                sh "mvn sonar:sonar"
              }
            }
        }
        //previous or old  stage
//        stage('Code Quality Check Via SonarQube'){
//            steps{
//                script{
//                    sh "/opt/sonar-scanner/bin/sonar-scanner"
//                } 
//            }
//        }
        stage('Email Notification') {
            steps {
                script {
                    def qg = sh(returnStdout: true, script: 'curl -s -u admin:abhi "http://3.144.221.6:9000/api/qualitygates/project_status?projectKey=DoctorPatientPortal" | jq -r .projectStatus.status').trim()
           
                    if (qg == 'ERROR' || qg == 'OK') {
                    mail to: "rlabhilashabhi07@gmail.com",
                    subject: "SonarQube Analysis Notification",
                    body: qg == 'ERROR' ? "SonarQube analysis passed \n\n\n Hi Team,\n\n\nPlease find the SonarQube Analysis Report with credentials below\n\n\nSonarQube Analysis Report : http://18.219.165.229:9000/dashboard?id=DoctorPatientPortal\n\n\n login=admin\npassword=abhi\n\n\nRegards\nAbhilash" :
                                          "SonarQube analysis failed \n\n\n Hi Team,\n\n\nPlease find the SonarQube Analysis Report with credentials below\n\n\nSonarQube Analysis Report : http://18.219.165.229:9000/dashboard?id=DoctorPatientPortal\n\n\nlogin=admin\npassword=abhi\n\n\nRegards\nAbhilash"
                    }
                }
            }
        }
        stage("Build") {
          steps {
            git branch: 'main', credentialsId: 'GitHub-CREDS', url: 'https://github.com/Abhilash-1201/Doctor-Patient-Portal.git'
            withMaven(maven: 'MAVEN') {
              sh "mvn clean package"
            } // withMaven will discover the generated Maven artifacts, JUnit Surefire & FailSafe reports and FindBugs reports
          }
        }

//                      nexus  stage            //


        stage('Build docker image to dev ecr')  {
            steps{
                script{
                myImage = docker.build("nayab786/testrepo:${env.BUILD_NUMBER}")
                }
            }
        }

         stage('Pushing built docker image to Dev') {
            steps{  
                script {

                   sh "docker login -u ${DOCKERHUB_USERNAME} -p ${DOCKERHUB_PASSWORD}"

                sh "docker push nayab786/testrepo:${env.BUILD_NUMBER}"
             }   
          } 
        }
        //stage("Trivy Scan") {
        //   steps {
        //       script {
	    //        sh ('docker run -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy image nayab786/testrepo:latest --no-progress --scanners vuln  --exit-code 0 --severity HIGH,CRITICAL --format table')
        //       }
        //   }
       //}

       stage("Trigger CD Pipeline") {
    steps {
        script {
            def jenkinsUrl = 'ec2-18-225-55-91.us-east-2.compute.amazonaws.com:8080'
            def jobName = 'Doctor-Patient-Portal-CD'
            def authToken = "${JENKINS_API_TOKEN}"

            echo "Triggering Jenkins job ${jobName} on ${jenkinsUrl} with token ${authToken}"

            sh "curl -v -k --user abhi:${authToken} -X POST -H 'cache-control: no-cache' -H 'content-type: application/x-www-form-urlencoded' --data 'IMAGE_TAG=${IMAGE_TAG}' '${jenkinsUrl}/job/${jobName}/buildWithParameters?token=argocd'"
        }
    }
}
    

    }
}


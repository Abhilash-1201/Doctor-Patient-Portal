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
    }
    stages {
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
                    def qg = sh(returnStdout: true, script: 'curl -s -u admin:abhi "http://18.224.137.97:9000/api/qualitygates/project_status?projectKey=DoctorPatientPortal" | jq -r .projectStatus.status').trim()
           
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


        stage("Build & Push Docker Image") {
            steps {
                script {
                    docker.withRegistry('',DOCKER_PASS) {
                        docker_image = docker.build "${IMAGE_NAME}"
                    }

                    docker.withRegistry('',DOCKER_PASS) {
                        docker_image.push("${IMAGE_TAG}")
                        docker_image.push('latest')
                    }
                }
            }

       }
        ///stage("Trivy Scan") {
        //   steps {
        //       script {
	    //        sh ('docker run -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy image nayab786/testrepo:latest --no-progress --scanners vuln  --exit-code 0 --severity HIGH,CRITICAL --format table')
        //       }
        //   }
       //}

        stage ('Cleanup Artifacts') {
           steps {
               script {
                    sh "docker rmi ${IMAGE_NAME}:${IMAGE_TAG}"
                    sh "docker rmi ${IMAGE_NAME}:latest"
               }
          }
       }

       stage("Trigger CD Pipeline") {
            steps {
                script {
                    sh "curl -v -k --user clouduser:${JENKINS_API_TOKEN} -X POST -H 'cache-control: no-cache' -H 'content-type: application/x-www-form-urlencoded' --data 'IMAGE_TAG=${IMAGE_TAG}' 'ec2-13-232-128-192.ap-south-1.compute.amazonaws.com:8080/job/gitops-register-app-cd/buildWithParameters?token=gitops-token'"
                }
            }
       }
    

    }
}


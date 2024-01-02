pipeline {
    agent any
     tools {maven "MAVEN"}
     environment { 
        devregistry = "519852036875.dkr.ecr.us-east-2.amazonaws.com/demo-repo:${env.BUILD_NUMBER}"
        // This can be nexus3 or nexus2
        NEXUS_VERSION = "nexus3"
        // This can be http or https
        NEXUS_PROTOCOL = "http"
        // Where your Nexus is running
        NEXUS_URL = "3.145.60.125:8081"
        // Repository where we will upload the artifact
        NEXUS_REPOSITORY = "DoctorPortal"
        // Jenkins credential id to authenticate to Nexus OSS
        NEXUS_CREDENTIAL_ID = "nexusCredential"
        ARTIFACT_VERSION = "${BUILD_NUMBER}"
    }
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
                    def qg = sh(returnStdout: true, script: 'curl -s -u admin:abhi "http://18.222.176.246:9000/api/qualitygates/project_status?projectKey=DoctorPatientPortal" | jq -r .projectStatus.status').trim()
           
                    if (qg == 'ERROR' || qg == 'OK') {
                    mail to: "rlabhilashabhi07@gmail.com",
                    subject: "SonarQube Analysis Notification",
                    body: qg == 'ERROR' ? "SonarQube analysis passed \n\n\n Hi Team,\n\n\nPlease find the SonarQube Analysis Report with credentials below\n\n\nSonarQube Analysis Report : http://3.128.247.190:9000/dashboard?id=DoctorPatientPortal\n\n\n login=admin\npassword=abhi\n\n\nRegards\nAbhilash" :
                                          "SonarQube analysis failed \n\n\n Hi Team,\n\n\nPlease find the SonarQube Analysis Report with credentials below\n\n\nSonarQube Analysis Report : http://3.128.247.190:9000/dashboard?id=DoctorPatientPortal\n\n\nlogin=admin\npassword=abhi\n\n\nRegards\nAbhilash"
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
        stage("publish artifact to nexus repository..") {
            steps {
                script {
                    // Read POM xml file using 'readMavenPom' step , this step 'readMavenPom' is included in: https://plugins.jenkins.io/pipeline-utility-steps
                    pom = readMavenPom file: "pom.xml";
                    // Find built artifact under target folder
                    filesByGlob = findFiles(glob: "target/*.${pom.packaging}");
                    // Print some info from the artifact found
                    echo "${filesByGlob[0].name} ${filesByGlob[0].path} ${filesByGlob[0].directory} ${filesByGlob[0].length} ${filesByGlob[0].lastModified}"
                    // Extract the path from the File found
                    artifactPath = filesByGlob[0].path;
                    // Assign to a boolean response verifying If the artifact name exists
                    artifactExists = fileExists artifactPath;

                    if(artifactExists) {
                        echo "*** File: ${artifactPath}, group: ${pom.groupId}, packaging: ${pom.packaging}, version ${pom.version}";

                        nexusArtifactUploader(
                            nexusVersion: NEXUS_VERSION,
                            protocol: NEXUS_PROTOCOL,
                            nexusUrl: NEXUS_URL,
                            groupId: pom.groupId,
                            version: ARTIFACT_VERSION,
                            repository: NEXUS_REPOSITORY,
                            credentialsId: NEXUS_CREDENTIAL_ID,
                            artifacts: [
                                // Artifact generated such as .jar, .ear and .war files.
                                [artifactId: pom.artifactId,
                                classifier: '',
                                file: artifactPath,
                                type: pom.packaging]
                            ]
                        );

                    } else {
                        error "*** File: ${artifactPath}, could not be found";
                    }
                }
            }
        }
        stage('Build docker image to dev ecr')  {
            steps{
                script{
                myImage = docker.build devregistry
                }
            }
        }
        stage('Pushing built docker image to Dev') {
            steps{  
                script {
                   sh 'aws ecr get-login-password --region us-east-2 | docker login --username AWS --password-stdin 519852036875.dkr.ecr.us-east-2.amazonaws.com'
                   sh 'docker push ${devregistry}'
                }
           }   
        }  
        stage('Update Deployment File') {
    environment {
        GIT_REPO_NAME = "Doctor-Patient-Portal"
        GIT_USER_NAME = "Abhilash-1201"
    }
    steps {
        withCredentials([gitUsernamePassword(credentialsId: 'GitHub_Token', gitToolName: 'Default')]) {
            script {
                def gitEmail = sh(script: 'git config user.email', returnStdout: true).trim()
                def gitName = sh(script: 'git config user.name', returnStdout: true).trim()

                // Configure git user email and name for the Jenkins job
                sh 'git config user.email "rlabhilash1201@gmail.com"'
                sh 'git config user.name "Abhilash-1201"'

                // Add changes to the Git index
                sh 'git add manifest/deployment.yml'
                sh 'git add -u'  // Add updated and deleted files to the Git index

                // Commit changes
                sh 'git commit -m "Update deployment image to version ${BUILD_NUMBER}"'

                // Push changes to the remote repository
                sh "git push https://${GITHUB_TOKEN}@github.com/${GIT_USER_NAME}/${GIT_REPO_NAME} HEAD:main"

                // Restore original git config values
                sh "git config user.email '${gitEmail}'"
                sh "git config user.name '${gitName}'"
            }
        }
     }
}


    }
}


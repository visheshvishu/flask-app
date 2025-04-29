@Library('Shared') _

pipeline {
    agent { label 'gcp' }

    // triggers {
    //     cron('H/5 * * * *')  // Runs every 5 minutes
    // }

    environment {
        scannerHome = tool 'sonar' 
    }

    stages {

        stage('Clean Workspace') {
            steps {
                cleanWs()
            }
        }

        stage('Clone from GitHub') {
            steps {
                script{
                     // git branch: 'main', url: 'https://github.com/visheshvishu/flask-app.git'
                    git_checkout("https://github.com/visheshvishu/flask-app.git","main")
                }
            }
        }

        stage('SonarQube Scan') {
            steps {
                script {
                    sonar_scan("$ScannerHome", "sonar", "flask-app", "flask-app", "v1", ".")
                }
            }
        }

        // stage('Quality Gate') {
        //     steps {
        //         script {
        //             waitForQualityGate abortPipeline: false, credentialsId: 'sonar'
        //         }
        //     }
        // }    
        
        // stage('OWASP Dependency Check') {
        //     steps {
        //         dependencyCheck additionalArguments: ''' 
        //             -o './'
        //             -s './'
        //             -f 'ALL' 
        //             --prettyPrint''', odcInstallation: 'owasp'
        
        // dependencyCheckPublisher pattern: 'dependency-check-report.xml'
        //     }
        // }
        
        stage('Build Docker Image') {
            steps {
                script {
                    docker_build('flask-app', 'latest')
                }
            }
        }
        
         stage('push to dockerhub') {
            steps {
                script{
                     docker_push('flask-app', 'visheshvishu', 'dockerhub', 'latest')
                }
            }        
        }
        
        stage('Run with Docker Compose') {
            steps {
                deploy_build()
            }
        }
        
    } //end of stages
        

    // post {
    //     success {
    //         echo 'pipeline completed successfully.'
    //     }
    //     failure {
    //         echo 'pipeline failed. Check logs for details.'
    //     }
    // }

    post {
    success {
      emailext(
        subject: "SUCCESS: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
        body: "Job Succeeded: ${env.BUILD_URL}",
        to: 'atif.hasan@oodles.io'
      )
    }
    failure {
      emailext(
        subject: "FAILURE: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
        body: "Job Failed: ${env.BUILD_URL}",
        to: 'atif.hasan@oodles.io'
      )
    }
  }
    
} //end of pipeline

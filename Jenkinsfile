Jenkinsfile:
pipeline { 
    agent { 
        label 'docker-agent' 
    } 
    environment { 
        DOCKERHUB_CREDENTIALS = credentials('docker-creds') 
    } 
    parameters { 
        string(name: 'VERSION', defaultValue: 'v5', description: 'Docker image version tag') 
    } 
    stages { 
        stage('Checkout') { 
            steps { 
                // Checkout the source code from the repository 
                checkout scm 
            } 
        } 
        stage('Check Workspace') { 
            steps { 
                // List files in the root workspace to verify the structure 
                sh 'ls -al' 
            } 
        } 
        stage('Build') { 
            steps { 
                // Navigate to the directory containing the Dockerfile and build the Docker image with the specified version 
                dir('day3') { 
                    sh "docker build -t beccaagem/jenkins-aws:${params.VERSION} ." 
                } 
            } 
        } 
        stage('Login') { 
            steps { 
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin' 
            } 
        } 
        stage('Verify Login') { 
            steps { 
                sh 'docker info' 
            } 
        } 
        stage('Push an image to Docker Hub') { 
            steps { 
                sh "docker push beccaagem/jenkins-aws:${params.VERSION}" 
            } 
        } 
        stage('Stop Existing Container') { 
            steps { 
                script { 
                    def containerExists = sh(script: 'docker ps -q -f name=jenkins-app', returnStatus: true) == 0 
                    if (containerExists) { 
                        sh 'docker stop jenkins-app' 
                    } 
                } 
            } 
        } 
        stage('Remove Existing Container') { 
            steps { 
                script { 
                    def containerExists = sh(script: 'docker ps -a -q -f name=jenkins-app', returnStatus: true) == 0 
                    if (containerExists) { 
                        sh 'docker rm jenkins-app' 
                    } 
                } 
            } 
        } 
        stage('Run New Container') { 
            steps { 
                sh "docker run -d --name jenkins-app -p 8080:8080 beccaagem/jenkins-aws:${params.VERSION}" 
            } 
        } 
        stage('Verify Container') { 
            steps { 
                sh 'docker logs jenkins-app' 
            } 
        } 
    } 
    post { 
        always { 
            sh 'docker logout' 
        } 
    } 
}
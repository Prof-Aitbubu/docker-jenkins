pipeline {
    agent { label 'docker' }

    parameters {
        string(name: 'VERSION', defaultValue: 'latest', description: 'Docker Image Version')
    }

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-creds') // Ensure this ID exists in Jenkins
        DOCKER_IMAGE = 'aitbubu/sonnet-scenes'
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/Prof-Aitbubu/docker-jenkins.git', credentialsId: 'github-credentials' // Ensure this ID exists in Jenkins
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${env.DOCKER_IMAGE}:${params.VERSION}")
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', DOCKERHUB_CREDENTIALS) {
                        docker.image("${env.DOCKER_IMAGE}:${params.VERSION}").push()
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'Docker image has been pushed to DockerHub successfully.'
        }
        failure {
            echo 'There was an error during the build/push process.'
        }
    }
}

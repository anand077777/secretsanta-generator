pipeline {
    agent any
    tools {
        jdk 'jdk17'
        maven 'maven3'
    }
    environment {
        SCANNER_HOME = tool 'sonar-scanner'
    }

    stages {
        stage('Git Checkout') {
            steps {
                git 'https://github.com/anand077777/secretsanta-generator.git'
            }
        }

        stage('Code Compile') {
            steps {
                sh "mvn clean compile"
            }
        }

        stage('Unit Tests') {
            steps {
                sh "mvn test"
            }
        }

        stage('Sonar Analysis') {
            steps {
                withSonarQubeEnv('sonar') {
                    sh """
                        ${SCANNER_HOME}/bin/sonar-scanner \
                        -Dsonar.projectName=Santa \
                        -Dsonar.java.binaries=target/classes \
                        -Dsonar.projectKey=Santa
                    """
                }
            }
        }

        stage('Code Build') {
            steps {
                sh "mvn clean install" // Changed to `mvn install` to ensure dependencies are included.
            }
        }

        stage('Docker Build') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'docker-cred') {
                        sh "docker build -t santa123 ."
                    }
                }
            }
        }

        stage('Docker Push') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'docker-cred') {
                        sh "docker tag santa123 anands07777/santa123:latest"
                        sh "docker push anands07777/santa123:latest"
                    }
                }
            }
        }

        stage('Docker Run') { // Renamed this stage to avoid duplication
            steps { 
                script {
                    withDockerRegistry(credentialsId: 'docker-cred') {
                        sh "docker run -d -p 8081:8080 anands07777/santa123"
                    }
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline execution completed.'
        }
        failure {
            echo 'Pipeline failed.'
        }
    }
}

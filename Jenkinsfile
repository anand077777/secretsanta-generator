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
                sh "mvn clean install" // Builds the code and packages it into a JAR/WAR
            }
        }

        stage('Docker Build') {
            steps {
                script {
                    def imageTag = "${env.BUILD_NUMBER}" // Use Jenkins BUILD_NUMBER for unique tagging
                    sh "docker build -t anands07777/santa:${imageTag} ."
                }
            }
        }

        stage('Docker Push') {
            steps {
                script {
                    def imageTag = "${env.BUILD_NUMBER}" // Ensure consistency in tag
                    withDockerRegistry(credentialsId: 'docker-cred') {
                        sh "docker push anands07777/santa:${imageTag}"
                    }
                }
            }
        }

        stage('Docker Run') {
            steps {
                script {
                    def imageTag = "${env.BUILD_NUMBER}" // Consistent tag for running the container
                    sh """
                        docker stop santa-container || true && docker rm santa-container || true
                        docker run -d -p 8081:8080 --name santa-container anands07777/santa:${imageTag}
                    """
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

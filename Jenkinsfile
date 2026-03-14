pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-cred') // Jenkins Credentials ID
        IMAGE_NAME = "devsecops-app1"
        IMAGE_TAG  = "latest"
        DOCKERHUB_REPO = "${DOCKERHUB_CREDENTIALS_USR}/${IMAGE_NAME}:${IMAGE_TAG}"
    }

    stages {

        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
            }
        }

        stage('Trivy Security Scan') {
            steps {
                sh "trivy image --exit-code 1 --severity HIGH,CRITICAL ${IMAGE_NAME}:${IMAGE_TAG} || true"
            }
        }

        stage('Docker Hub Login & Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-cred', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${DOCKER_USER}/${IMAGE_NAME}:${IMAGE_TAG}
                        docker push ${DOCKER_USER}/${IMAGE_NAME}:${IMAGE_TAG}
                    '''
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                // Use Jenkins secret file for kubeconfig
                withCredentials([file(credentialsId: 'kubeconfig-secret', variable: 'KUBECONFIG')]) {
                    sh '''
                        kubectl apply -f k8s/
                    '''
                }
            }
        }
    }

    post {
        always {
            sh 'docker logout'
        }
        success {
            echo "Deployment Successful! 🚀"
        }
        failure {
            echo "Pipeline Failed ❌"
        }
    }
}
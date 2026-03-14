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
                // HIGH/CRITICAL vulnerabilities warn but don't fail pipeline
                sh "trivy image --exit-code 1 --severity HIGH,CRITICAL ${IMAGE_NAME}:${IMAGE_TAG} || echo 'Security scan completed with warnings'"
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
                withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')]) {
                    sh '''
                        kubectl apply -f k8s/
                        kubectl get pods
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
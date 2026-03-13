pipeline {
    agent any

    environment {
        DOCKERHUB_USERNAME = credentials('iamakshayjagtap') // Jenkins credential ID
        DOCKERHUB_PASSWORD = credentials('Asj@97662112') // Jenkins credential ID
        IMAGE_NAME = "devsecops-app"
        IMAGE_TAG  = "latest"
        DOCKERHUB_REPO = "${DOCKERHUB_USERNAME}/${IMAGE_NAME}:${IMAGE_TAG}"
    }

    stages {

        stage('Clone Repository') {
            steps {
                git 'https://github.com/IamAkshayjagtap/CI-CD-Pipeline-with-Automated-Docker-Security-Scanning-and-Deployment-to-Kubernetes.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
            }
        }

        stage('Trivy Security Scan') {
            steps {
                sh "trivy image --exit-code 1 --severity HIGH,CRITICAL ${IMAGE_NAME}:${IMAGE_TAG}"
            }
        }

        stage('Docker Hub Login & Push') {
            steps {
                sh """
                echo "${DOCKERHUB_PASSWORD}" | docker login -u "${DOCKERHUB_USERNAME}" --password-stdin
                docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${DOCKERHUB_REPO}
                docker push ${DOCKERHUB_REPO}
                """
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh 'kubectl apply -f k8s/'
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

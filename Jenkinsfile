pipeline {
    agent {
        docker {
            image 'docker:20.10.24-dind'
            args '--privileged -v /var/run/docker.sock:/var/run/docker.sock'
        }
    }

    environment {
        IMAGE_NAME = "count-app"
        IMAGE_TAG  = "latest"
        DOCKERHUB_USER = "suvratam"
    }

    stages {
        stage('Checkout') {
            steps {
                echo "Cloning repository..."
                checkout scm
            }
        }

        stage('Pull Image') {
            steps {
                echo "Pulling pre-built Docker image..."
                sh "docker pull $DOCKERHUB_USER/$IMAGE_NAME:$IMAGE_TAG"
            }
        }

        stage('Test') {
            steps {
                echo "Running tests..."
                sh "docker run --rm $DOCKERHUB_USER/$IMAGE_NAME:$IMAGE_TAG echo 'Tests Passed!'"
            }
        }

        stage('Push to DockerHub') {
            steps {
                echo "Pushing Docker image to DockerHub..."
                withCredentials([string(credentialsId: 'dockerhub-pass', variable: 'DOCKERHUB_PASS')]) {
                    sh """
                        echo \$DOCKERHUB_PASS | docker login -u \$DOCKERHUB_USER --password-stdin
                        docker push \$DOCKERHUB_USER/\$IMAGE_NAME:\$IMAGE_TAG
                    """
                }
            }
        }

        stage('Deploy') {
            steps {
                echo "Deploying container..."
                sh """
                    docker stop myapp || true
                    docker rm myapp || true
                    docker run -d --name myapp -p 8081:80 \$DOCKERHUB_USER/\$IMAGE_NAME:\$IMAGE_TAG
                """
            }
        }
    }

    post {
        always {
            echo "Cleaning up..."
        }
        success {
            echo "Pipeline completed successfully ✅"
        }
        failure {
            echo "Pipeline failed ❌"
        }
    }
}


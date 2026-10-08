pipeline {
    agent any

    environment {
        APP_NAME = "jenkins-ci-demo"
        IMAGE_NAME = "jenkins-ci-demo"
        SERVICE_NAME = "jenkins-ci-demo"
        DEPLOY_PORT = "8082"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                sh '''
                    chmod +x app.sh
                    bash -n app.sh
                    echo "Application build validation successful"
                '''
            }
        }

        stage('Test') {
            steps {
                sh '''
                    chmod +x test.sh
                    ./test.sh
                '''
            }
        }

        stage('Docker Build') {
            steps {
                sh '''
                    docker build \
                      -t ${IMAGE_NAME}:${BUILD_NUMBER} \
                      -t ${IMAGE_NAME}:latest .
                '''
            }
        }

        stage('Deploy') {
            steps {
                sh '''
                    if ! docker service ls --format '{{.Name}}' | grep -q "^${SERVICE_NAME}$"; then
                        docker service create \
                          --name ${SERVICE_NAME} \
                          --replicas 2 \
                          --publish published=${DEPLOY_PORT},target=8080 \
                          --update-parallelism 1 \
                          --update-delay 5s \
                          --update-order start-first \
                          --update-failure-action rollback \
                          ${IMAGE_NAME}:${BUILD_NUMBER}
                    else
                        docker service update \
                          --image ${IMAGE_NAME}:${BUILD_NUMBER} \
                          --update-parallelism 1 \
                          --update-delay 5s \
                          --update-order start-first \
                          ${SERVICE_NAME}
                    fi
                '''
            }
        }

        stage('Verify') {
            steps {
                sh '''
                    sleep 10
                    docker service ls
                    docker service ps ${SERVICE_NAME}

                    curl --fail http://localhost:${DEPLOY_PORT}

                    echo "Deployment verification successful"
                '''
            }
        }
    }

    post {
        success {
            echo 'CI/CD pipeline completed successfully.'
        }

        failure {
            echo 'Pipeline failed. Investigate deployment and rollback if required.'
        }
    }
}

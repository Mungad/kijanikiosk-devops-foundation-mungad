pipeline {
    agent {
        docker {
            image 'node:20'
            args '-u root'
        }
    }

    environment {
        APP_DIR = 'week5/friday/kijanikiosk-payments'
        BUILD_DIR = 'dist'
        NODE_ENV = 'test'

        NEXUS_URL = 'http://172.17.0.1:8081/repository/npm-hosted/'
        NEXUS_CREDENTIALS = 'nexus-credentials'
    }

    options {
        timeout(time: 10, unit: 'MINUTES')
        disableConcurrentBuilds()
        buildDiscarder(logRotator(numToKeepStr: '10'))
    }

    stages {

        stage('Lint') {
            steps {
                dir("${APP_DIR}") {
                    sh '''
                        npm ci
                        npm run lint
                    '''
                }
            }
        }

        stage('Build') {
            steps {
                dir("${APP_DIR}") {
                    sh '''
                        npm run build
                        test -d ${BUILD_DIR}
                    '''
                }
            }
        }

        stage('Verify') {
            parallel {

                stage('Test') {
                    steps {
                        dir("${APP_DIR}") {
                            sh 'npm test'
                        }
                    }
                }

                stage('Security Audit') {
                    steps {
                        dir("${APP_DIR}") {
                            sh 'npm audit --audit-level=high || true'
                        }
                    }
                }
            }
        }

        stage('Archive') {
            steps {
                dir("${APP_DIR}") {
                    archiveArtifacts artifacts: 'dist/**', fingerprint: true
                }
            }
        }

        stage('Publish') {
            steps {
                dir("${APP_DIR}") {
                    withCredentials([
                        usernamePassword(
                            credentialsId: "${NEXUS_CREDENTIALS}",
                            usernameVariable: 'NEXUS_USER',
                            passwordVariable: 'NEXUS_PASS'
                        )
                    ]) {

                        sh '''
                            echo "Packaging application..."
                            npm pack

                            PACKAGE=$(ls *.tgz)

                            echo "Uploading ${PACKAGE} to Nexus..."

                            curl --fail -v \
                              -u "$NEXUS_USER:$NEXUS_PASS" \
                              --upload-file "$PACKAGE" \
                              "${NEXUS_URL}${PACKAGE}"

                            echo "Upload completed."
                        '''
                    }
                }
            }
        }
    }

    post {

        always {
            cleanWs()
        }

        success {
            echo "Pipeline completed successfully."
        }

        failure {
            echo "Pipeline failed. Check the build log."
        }

        changed {
            echo "Pipeline status changed."
        }
    }
}

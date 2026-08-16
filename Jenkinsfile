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

        NEXUS_URL = "http://172.17.0.2:8081/repository/npm-hosted/"
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
                        set -e

                        trap 'rm -f .npmrc' EXIT

                        echo "Preparing package version..."

                        SHORT_SHA=$(git rev-parse --short HEAD)
                        npm version "1.0.0-${SHORT_SHA}" --no-git-tag-version

                        echo "Creating temporary .npmrc..."

cat > .npmrc <<EOF
registry=${NEXUS_URL}
//172.17.0.2:8081/repository/npm-hosted/:username=${NEXUS_USER}
//172.17.0.2:8081/repository/npm-hosted/:_password=$(printf "%s" "${NEXUS_PASS}" | base64 -w0)
//172.17.0.2:8081/repository/npm-hosted/:email=jenkins@example.com
//172.17.0.2:8081/repository/npm-hosted/:always-auth=true
EOF

                        echo "Publishing package..."
                        npm publish

                        echo "Package published successfully."
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
            echo "Artifact available in Nexus."
        }

        failure {
            echo "Pipeline failed. Check logs and fix before merging."
        }

        changed {
            echo "Pipeline status changed from previous run."
        }
    }
}

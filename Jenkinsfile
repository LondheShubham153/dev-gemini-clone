@Library('Shared')_

pipeline {
    agent { label 'dev-server' }
    
    environment {
        SONAR_HOME = tool "Sonar"
        DOCKER_IMAGE  = "geminiamit"
        GIT_REPO      = "https://github.com/Amitabh-DevOps/dev-gemini-clone.git"
        GIT_BRANCH    = "DevOps"
        DOCKERHUB_USERNAME = "amitabhdevops"
        DOCKER_IMAGE_NAME = "${DOCKERHUB_USERNAME}/${DOCKER_IMAGE}"
    }
    parameters {
        string(name: 'GEMINI_DOCKER_TAG', defaultValue: 'v1', description: 'Setting docker image for latest push')
    }
    stages {
        stage("Clean Workspace") {
            steps {
                cleanWs()
            }
        }
        stage("Code") {
            steps {
                // Use GIT_REPO and GIT_BRANCH from environment variables
                clone("${GIT_REPO}", "${GIT_BRANCH}")
                echo "Code cloning done from ${GIT_REPO} branch ${GIT_BRANCH}."
            }
        }
        stage("Prepare Environment File") {
            steps {
                prepareEnvFile('.env.local', '.env.local')
            }
        }
        stage("Build") {
            steps {
                dockerbuild("${DOCKER_IMAGE}", "${params.GEMINI_DOCKER_TAG}")
                echo "Docker image ${DOCKER_IMAGE}:${params.GEMINI_DOCKER_TAG} built successfully."
            }
        }
        stage("SonarQube Quality Analysis") {
            steps {
                sonarqube_analysis('Sonar', "${DOCKER_IMAGE}", "${DOCKER_IMAGE}")
            }
        }
        stage("OWASP : Dependency Check") {
            steps {
                owasp_dependency()
            }
        }
        stage("Sonar Quality Gate Scan") {
            steps {
                sonarqube_code_quality()
            }
        }
        stage("Docker Image Security Scan (Trivy)") {
            steps {
                dockerScanTrivy("${DOCKER_IMAGE}", "${params.GEMINI_DOCKER_TAG}")
                echo "Trivy scan completed for ${DOCKER_IMAGE}:${params.GEMINI_DOCKER_TAG}."
            }
        }
        stage("Push to DockerHub") {
            steps {
                dockerpush("dockerHub", "${DOCKER_IMAGE}", "${params.GEMINI_DOCKER_TAG}")
                echo "Pushed ${DOCKERHUB_USERNAME}/${DOCKER_IMAGE}:${params.GEMINI_DOCKER_TAG} to DockerHub."
            }
        }
        // Uncommented and updated the "Run Container" stage to use environment variables
        // stage("Run Container") {
        //     steps {
        //         dockerRunApp("${DOCKER_IMAGE}", "${params.GEMINI_DOCKER_TAG}", "env_local", "${DOCKER_IMAGE}", "--env-file .env.local -p 3000:3000")
        //         echo "Container started using ${DOCKER_IMAGE}:${DOCKER_TAG} with container name '${DOCKER_IMAGE}'."
        //     }
        // }
        stage("Cleanup Docker Images") {
            steps {
                script {
                    sh "docker rmi ${DOCKER_IMAGE}:${params.GEMINI_DOCKER_TAG} || true"
                    sh "docker rmi ${DOCKERHUB_USERNAME}/${DOCKER_IMAGE}:${params.GEMINI_DOCKER_TAG} || true"
                    sh "docker image prune -f"
                }
                echo "Cleaned up Docker image: ${DOCKERHUB_USERNAME}/${DOCKER_IMAGE}:${params.GEMINI_DOCKER_TAG}."
            }
        }
    }
    post {
        success {
            archiveArtifacts artifacts: 'kubernetes/gemini-deployment.yml', followSymlinks: false
            build job: "Gemini-CD", parameters: [
                string(name: 'GEMINI_DOCKER_TAG', value: "${params.GEMINI_DOCKER_TAG}")
            ]
            echo "Pipeline completed successfully!"
            emailext (
                subject: "SUCCESS: Jenkins Pipeline for ${DOCKER_IMAGE}",
                body: """
                    <div style="font-family: Arial, sans-serif; padding: 20px; border: 2px solid #4CAF50; border-radius: 10px;">
                        <h2 style="color: #4CAF50;">🎉 Pipeline Execution: SUCCESS 🎉</h2>
                        <p style="font-size: 16px; color: #333;">
                            Hello Team,
                        </p>
                        <p style="font-size: 16px; color: #333;">
                            The Jenkins CI pipeline for <strong style="color: #4CAF50;">${DOCKER_IMAGE}</strong> completed <strong style="color: #4CAF50;">successfully</strong>!
                        </p>
                        <table style="width: 100%; border-collapse: collapse; margin-top: 20px;">
                            <tr style="background-color: #f2f2f2;">
                                <th style="text-align: left; padding: 8px; border: 1px solid #ddd;">Details</th>
                                <th style="text-align: left; padding: 8px; border: 1px solid #ddd;">Values</th>
                            </tr>
                            <tr>
                                <td style="padding: 8px; border: 1px solid #ddd;">Git Repository</td>
                                <td style="padding: 8px; border: 1px solid #ddd;">${GIT_REPO}</td>
                            </tr>
                            <tr>
                                <td style="padding: 8px; border: 1px solid #ddd;">Branch</td>
                                <td style="padding: 8px; border: 1px solid #ddd;">${GIT_BRANCH}</td>
                            </tr>
                            <tr>
                                <td style="padding: 8px; border: 1px solid #ddd;">Docker Image</td>
                                <td style="padding: 8px; border: 1px solid #ddd;">${DOCKERHUB_USERNAME}/${DOCKER_IMAGE}:${params.GEMINI_DOCKER_TAG}</td>
                            </tr>
                        </table>
                        <p style="font-size: 16px; color: #333; margin-top: 20px;">
                            Visit <a href="${BUILD_URL}" style="color: #4CAF50;">Pipeline Logs</a> for more details.
                        </p>
                        <p style="font-size: 16px; color: #333; margin-top: 20px;">
                            Thanks,<br>
                            <strong>Jenkins</strong>
                        </p>
                    </div>
                """,
                to: "amitabhdevops2024@gmail.com",
                from: "jenkins@example.com",
                mimeType: 'text/html',
                attachmentsPattern: '**/table-report.html'
            )
        }
        failure {
            echo "Pipeline failed. Please check the logs."
            emailext (
                subject: "FAILURE: Jenkins Pipeline for ${DOCKER_IMAGE}",
                body: """
                    <div style="font-family: Arial, sans-serif; padding: 20px; border: 2px solid #F44336; border-radius: 10px;">
                        <h2 style="color: #F44336;">🚨 Pipeline Execution: FAILURE 🚨</h2>
                        <p style="font-size: 16px; color: #333;">
                            Hello Team,
                        </p>
                        <p style="font-size: 16px; color: #333;">
                            Unfortunately, the Jenkins CI pipeline for <strong style="color: #F44336;">${DOCKER_IMAGE}</strong> has <strong style="color: #F44336;">failed</strong>.
                        </p>
                        <table style="width: 100%; border-collapse: collapse; margin-top: 20px;">
                            <tr style="background-color: #f2f2f2;">
                                <th style="text-align: left; padding: 8px; border: 1px solid #ddd;">Details</th>
                                <th style="text-align: left; padding: 8px; border: 1px solid #ddd;">Values</th>
                            </tr>
                            <tr>
                                <td style="padding: 8px; border: 1px solid #ddd;">Git Repository</td>
                                <td style="padding: 8px; border: 1px solid #ddd;">${GIT_REPO}</td>
                            </tr>
                            <tr>
                                <td style="padding: 8px; border: 1px solid #ddd;">Branch</td>
                                <td style="padding: 8px; border: 1px solid #ddd;">${GIT_BRANCH}</td>
                            </tr>
                            <tr>
                                <td style="padding: 8px; border: 1px solid #ddd;">Docker Image</td>
                                <td style="padding: 8px; border: 1px solid #ddd;">${DOCKERHUB_USERNAME}/${DOCKER_IMAGE}:${params.GEMINI_DOCKER_TAG}</td>
                            </tr>
                        </table>
                        <p style="font-size: 16px; color: #333; margin-top: 20px;">
                            Visit <a href="${BUILD_URL}" style="color: #F44336;">Pipeline Logs</a> for more details.
                        </p>
                        <p style="font-size: 16px; color: #333; margin-top: 20px;">
                            Thanks,<br>
                            <strong>Jenkins</strong>
                        </p>
                    </div>
                """,
                to: "amitabhdevops2024@gmail.com",
                from: "jenkins@example.com",
                mimeType: 'text/html',
                attachmentsPattern: '**/table-report.html'
            )
        }
    }
}
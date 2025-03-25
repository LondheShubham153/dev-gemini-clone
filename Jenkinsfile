@Library('Shared')_

pipeline {
    agent any
    
    environment {
        SONAR_HOME = tool "Sonar"
        DOCKER_IMAGE  = "gemini"
        GIT_REPO      = "https://github.com/Amitabh-DevOps/dev-gemini-clone.git"
        GIT_BRANCH    = "main"
    }
    stages {
        stage("Clean Workspace") {
            steps {
                cleanWs()
            }
        }
        stage("Code") {
            steps {
                clone("https://github.com/Amitabh-DevOps/dev-gemini-clone.git","main")
                echo "Code cloning done."
            }
        }
        stage("Build") {                                                             
            steps {
                dockerbuild("gemini","latest")
                echo "Code build done."
            }
        }
        stage("SonarQube Quality Analysis") {
            steps {
                sonarqube_analysis('Sonar', 'gemini', 'gemini')
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
                // Scan the Docker image with Trivy using a shared library function.
                // The options can be customized to specify severity levels, etc.
                dockerScanTrivy("gemini", "latest")
                echo "Trivy scan completed."
            }
        }
        stage("Push to DockerHub") {
            steps {
                dockerpush("dockerHub","gemini","latest")
                echo "Push to DockerHub done."
            }
        }
        stage("Run Container") {
            steps {
                // Call the shared library function
                // Parameters: image, tag, credential ID for .env.local, container name, and docker run options.
                dockerRunApp("gemini", "latest", "env_local", "gemini", "--env-file .env.local -p 3000:3000")
                echo "Container started using .env.local file with container name 'gemini'."
            }
        }
    }
    post {
        success {
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
                            The Jenkins pipeline for <strong style="color: #4CAF50;">${DOCKER_IMAGE}</strong> completed <strong style="color: #4CAF50;">successfully</strong>!
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
                attachmentsPattern: '**/table-report.html'  // This will pick up the report from the workspace
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
                            Unfortunately, the Jenkins pipeline for <strong style="color: #F44336;">${DOCKER_IMAGE}</strong> has <strong style="color: #F44336;">failed</strong>.
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
                attachmentsPattern: '**/table-report.html'  // This will pick up the report from the workspace
            )
        }
    }
}
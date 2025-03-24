@Library('Shared')_

pipeline {
    agent any
    
    environment {
        SONAR_HOME = tool "Sonar"
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
}

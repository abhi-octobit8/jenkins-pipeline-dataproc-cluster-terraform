pipeline {
    agent any

    environment {
        GOOGLE_APPLICATION_CREDENTIALS = credentials('GOOGLE_APPLICATION_CREDENTIAL')
        GCP_PROJECT = 'devops-training-402109'
        TERRAFORM_VERSION = '0.14.10' // Specify your Terraform version
    }

    stages {
        stage('Checkout Code') {
            steps {
                // Checkout your Terraform configuration from your version control system
                checkout scm
            }
        }

        stage('Initialize Terraform') {
            steps {
               bat "terraform init"
            }
        }

        stage('Terraform Apply') {
            steps {
                // Apply the Terraform configuration to provision the Dataproc cluster
                withCredentials([file(credentialsId: 'GOOGLE_APPLICATION_CREDENTIAL', variable: 'GOOGLE_APPLICATION_CREDENTIALS')]) {
                    bat "terraform apply -auto-approve"
                }
            }
        }

        stage('Clean Up') {
            steps {
                // If desired, you can add a stage to destroy the Dataproc cluster after use
                input("Destroy dataproc cluster?")                
                withCredentials([file(credentialsId: 'GOOGLE_APPLICATION_CREDENTIAL', variable: 'GOOGLE_APPLICATION_CREDENTIALS')]) {
                    bat "terraform destroy -auto-approve"
                }
            }
        }
    }

    post {
        success {
            echo "Dataproc cluster provisioned successfully!"
        }
        failure {
            echo "Failed to provision the Dataproc cluster."
        }
    }
}

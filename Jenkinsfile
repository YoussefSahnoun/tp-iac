pipeline {
    agent any

    environment {
        TF_IN_AUTOMATION = "true"
        // DB password injected from Jenkins Credentials (ID: DB_PASSWORD)
    }

    stages {
        
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Inject Secrets') {
            steps {
                withCredentials([string(credentialsId: 'DB_PASSWORD', variable: 'DB_PASSWORD')]) {
                    sh '''
                        echo "TF_VAR_db_password=${DB_PASSWORD}" > .tfenvvars
                    '''
                }
            }
        }

        stage('Terraform Init') {
            steps {
                sh '''
                    set -o allexport
                    . .tfenvvars
                    set +o allexport

                    terraform --version
                    terraform init -input=false
                '''
            }
        }


        stage('Terraform Plan') {
            steps {
                sh '''
                    set -o allexport
                    . .tfenvvars
                    set +o allexport

                    terraform plan -out=tfplan -input=false
                    terraform show -no-color tfplan > plan.txt
                '''
            }
            post {
                success {
                    archiveArtifacts artifacts: 'plan.txt', fingerprint: true
                    archiveArtifacts artifacts: 'tfplan', fingerprint: true
                }
            }
        }


        stage('Terraform Apply') {
            when { branch 'main' }
            steps {
                sh '''
                    set -o allexport
                    . .tfenvvars
                    set +o allexport

                    terraform apply -auto-approve tfplan
                '''
            }
        }

    }

    post {
        failure {
            echo "Pipeline failed."
        }
        success {
            echo "Terraform apply completed successfully."
        }
    }
}

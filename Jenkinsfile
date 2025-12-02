pipeline {
    agent any
    
    environment {
        TF_IN_AUTOMATION = "true"
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
                    script {
                        // Export Terraform variable into environment
                        env.TF_VAR_db_password = DB_PASSWORD
                    }
                }
            }
        }

        stage('Terraform Init') {
            steps {
                sh '''
                    terraform --version
                    terraform init -input=false
                '''
            }
        }

        stage('Terraform Plan') {
            steps {
                sh '''
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
            when {
                branch 'main'
            }
            steps {
                sh '''
                    terraform apply -auto-approve tfplan
                '''
            }
        }
    }

    post {
        success {
            echo "Terraform pipeline succeeded."
        }
        failure {
            echo "Terraform pipeline failed."
        }
    }
}

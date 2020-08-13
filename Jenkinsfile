


pipeline {
    agent any

    stages {
        stage ('init') {

            steps {
                bat 'terraform init'
                bat 'terraform plan -auto-approve'
                bat 'terraform apply'
                }
            }
        }

       }
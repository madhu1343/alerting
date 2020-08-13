


pipeline {
    agent any

    stages {
        stage ('init') {

            steps {
                bat 'terraform init'
                bat 'terraform plan'
                bat 'terraform apply -auto-approve'
                }
            }
        }

       }

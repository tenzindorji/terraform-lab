pipeline {
    agent any
    environment {
        AWS_DEFAULT_REGION = "us-eat-2"
        GIT_REPO = 'https://github.com/tenzindorji/terraform-lab.git'
        TF_DIR   = 'environments/dev'
    }
    stages {
        stage('Clean Workspace') {
            steps {
                deleteDir()
            }
        }
        stage('Checkout') {
            steps {
                git branch: 'master',
                    url: "${GIT_REPO}"
            }
        }
        stage('Install Terraform') {
            steps {
                sh '''
                    apt-get update
                    apt-get install -y wget unzip
                    wget https://releases.hashicorp.com/terraform/1.13.5/terraform_1.13.5_linux_amd64.zip
                    unzip terraform_1.13.5_linux_amd64.zip
                    chmod +x terraform
                    ./terraform version
                '''
  }
}
        stage('Verify') {
            steps {
                sh ''' 
                    pwd
                    ls -ltr
                    ../../terraform version
                '''
            }
        }
        stage('Terraform init') {
            steps {
                dir("${TF_DIR}")
                    sh '../../terraform init'
            }
        }
        stage('Terraform validate') {
            steps {
                dir("${TF_DIR}")
                    sh '../../terraform validate'
            }
        }
        stage('Terraform plan') {
            steps {
                dir("${TF_DIR}")
                    sh '../../terraform plan -out=tfplan'
            }
        }
        stage('Approval') {
            steps {
                input 'Apply tf changes?'
            }
        }
        stage('TF Apply') {
            steps {
                dir("${TF_DIR}")
                    withCredentials([
                        string(credentialsId: 'aws-access-key', variable: 'AWS_ACCESS_KEY_ID'),
                        string(credentialsId: 'aws-secret-key', variable: 'AWS_SECRET_ACCESS_KEY')
                        ]) {
                            sh '../../terraform apply -auto-approve tfplan'
                         }
            }
        

        }
    }
    post {
        always {
            cleanWs()
        }
    }
}
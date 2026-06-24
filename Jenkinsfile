pipeline {
    agent {
    kubernetes {
      yaml '''
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: terraform
    image: hashicorp/terraform:1.13
    command:
    - cat
    tty: true
'''
    }
  }
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
        stage('Verify') {
            steps {
                container('terraform') {
                sh ''' 
                    pwd
                    ls -ltr
                    terraform version
                '''
            }
            }
        }
        stage('Terraform validate and plan') {
            steps {
                container('terraform') {
                dir("${TF_DIR}") 
                    withCredentials([
                            string(credentialsId: 'aws-access-key', variable: 'AWS_ACCESS_KEY_ID'),
                            string(credentialsId: 'aws-secret-key', variable: 'AWS_SECRET_ACCESS_KEY')
                            ]) {
                                sh 'terraform init'
                                sh 'terraform validate'
                                sh 'terraform plan -out=tfplan'
                                }
                            }
                }
            }
        stage('Approval') {
            steps {
                input 'Apply tf changes?'
            }
        }
        stage('TF Apply') {
            steps {
                container('terraform') {
                    dir("${TF_DIR}")
                        withCredentials([
                            string(credentialsId: 'aws-access-key', variable: 'AWS_ACCESS_KEY_ID'),
                            string(credentialsId: 'aws-secret-key', variable: 'AWS_SECRET_ACCESS_KEY')
                            ]) {
                                sh 'terraform apply -auto-approve tfplan'
                            }
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
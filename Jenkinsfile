pipeline {
    agent any

    parameters {
        choice(name: 'ENV', choices: ['dev', 'staging'], description: 'Select environment to deploy')
    }

    environment {
        AWS_REGION = 'us-east-1'
        AWS_CREDENTIALS = credentials('aws-jenkins-creds')
        ECR_REPO = '141559732042.dkr.ecr.us-east-1.amazonaws.com/mywebsite' #your ecr repo
        IMAGE_TAG = "v${BUILD_NUMBER}"
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main', credentialsId: 'git', url: 'https://github.com/yourname/ecs-aurora-website.git'
            }
        }

        stage('Terraform Init & Validate') {
            steps {
                dir('terraform') {
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-jenkins-creds']]) {
                        sh '''
                        terraform init -input=false
                        terraform validate
                        terraform workspace select ${ENV} || terraform workspace new ${ENV}
                        '''
                    }
                }
            }
        }

        stage('Terraform Plan & Apply Infra') {
            steps {
                dir('terraform') {
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-jenkins-creds']]) {
                        sh '''
                        terraform plan -input=false -out=tfplan -var="env=${ENV}"
                        terraform apply -input=false -auto-approve tfplan
                        '''
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                    cd app
                    docker build -t ${ECR_REPO}:${IMAGE_TAG} .
                    '''
                }
            }
        }

        stage('Push Docker Image to ECR') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-jenkins-creds']]) {
                    sh '''
                    aws ecr get-login-password --region ${AWS_REGION} | \
                    docker login --username AWS --password-stdin ${ECR_REPO}
                    docker push ${ECR_REPO}:${IMAGE_TAG}
                    '''
                }
            }
        }

        stage('Deploy to ECS') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-jenkins-creds']]) {
                    sh '''
                    aws ecs update-service \
                        --cluster ${ENV}-ecs-cluster \
                        --service ${ENV}-web-service \
                        --force-new-deployment \
                        --region ${AWS_REGION}
                    '''
                }
            }
        }

        stage('Verify Deployment') {
            steps {
                script {
                    echo "✅ Deployment completed for ${ENV} environment!"
                    echo "Website: https://${ENV}.example.com"
                }
            }
        }
    }

    post {
        success {
            echo "🎉 ${ENV} deployment successful!"
        }
        failure {
            echo "❌ Deployment failed. Check logs in Jenkins & CloudWatch."
        }
    }
}

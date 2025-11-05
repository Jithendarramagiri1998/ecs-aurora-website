pipeline {
    agent any

    parameters {
        choice(name: 'ENV', choices: ['dev', 'staging'], description: 'Select environment to deploy')
    }

    environment {
        AWS_REGION      = 'us-east-1'
        AWS_CREDENTIALS = credentials('aws-jenkins-creds')
        ECR_REPO        = '141559732042.dkr.ecr.us-east-1.amazonaws.com/mywebsite'
        IMAGE_TAG       = "v${BUILD_NUMBER}"
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main', credentialsId: 'git', url: 'https://github.com/Jithendarramagiri1998/ecs-aurora-website.git'
            }
        }

        stage('Terraform Init & Validate') {
            steps {
                script {
                    def terraformRoot = "${env.WORKSPACE}/terraform"
                    def backendPath   = "${terraformRoot}/global/backend"
                    def envPath       = "${terraformRoot}/envs/${params.ENV}"

                    dir(envPath) {
                        sh '''
                        if ! aws s3api head-bucket --bucket my-terraform-states-1234 2>/dev/null; then
                            echo "🚀 Creating backend S3 & DynamoDB..."
                            cd ../../global/backend
                            terraform init -input=false
                            terraform apply -auto-approve
                            cd -
                        else
                            echo "✅ Backend S3 bucket already exists."
                        fi

                        terraform init \
                          -backend-config="bucket=my-terraform-states-1234" \
                          -backend-config="key=${ENV}/terraform.tfstate" \
                          -backend-config="region=us-east-1" \
                          -backend-config="dynamodb_table=terraform-locks" \
                          -input=false

                        terraform validate
                        terraform workspace select ${ENV} || terraform workspace new ${ENV}
                        '''
                    }
                }
            }
        }

        stage('Terraform Plan & Apply Infra') {
            steps {
                dir("terraform/envs/${params.ENV}") {
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-jenkins-creds']]) {
                        sh '''
                        echo "📦 Running Terraform Plan for ${ENV}..."
                        terraform plan -input=false -out=tfplan -var="env=${ENV}"
                        echo "🚀 Applying Terraform Changes..."
                        terraform apply -input=false -auto-approve tfplan
                        '''
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo "🔧 Building Docker image with app code..."
                    sh '''
                    cd app
                    echo "📁 Checking files inside app/"
                    ls -l
                    echo "🐳 Building Docker image..."
                    docker build -t ${ECR_REPO}:${IMAGE_TAG} .
                    echo "✅ Docker image built successfully!"
                    '''
                }
            }
        }

        stage('Push Docker Image to ECR') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-jenkins-creds']]) {
                    sh '''
                    echo "🔐 Logging in to Amazon ECR..."
                    aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REPO}
                    echo "🚀 Pushing Docker image to ECR..."
                    docker push ${ECR_REPO}:${IMAGE_TAG}
                    '''
                }
            }
        }

        stage('Deploy to ECS') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-jenkins-creds']]) {
                    sh '''
                    echo "🚀 Registering new ECS task definition revision with updated image..."

                    TASK_NAME="${ENV}-app-task"

                    # Fetch current task definition JSON
                    TASK_DEF_JSON=$(aws ecs describe-task-definition --task-definition $TASK_NAME --region ${AWS_REGION})

                    # Update the image URI inside container definitions
                        NEW_TASK_DEF=$(echo $TASK_DEF_JSON | jq --arg IMAGE "${ECR_REPO}:${IMAGE_TAG}" '
                            .taskDefinition
                            | {
                                family: .family,
                                networkMode: .networkMode,
                                executionRoleArn: .executionRoleArn,
                                containerDefinitions: (.containerDefinitions | map(.image = $IMAGE)),
                                requiresCompatibilities: .requiresCompatibilities,
                                cpu: .cpu,
                                memory: .memory
                            }
                            # Include taskRoleArn only if it's not null
                            | if .taskRoleArn == null then del(.taskRoleArn) else . end
                        ')

                    # Save JSON and register new revision
                    echo $NEW_TASK_DEF > new-task-def.json

                    aws ecs register-task-definition \
                        --cli-input-json file://new-task-def.json \
                        --region ${AWS_REGION}

                    echo "🚀 Updating ECS Service with latest task definition..."
                    aws ecs update-service \
                        --cluster ${ENV}-ecs-cluster \
                        --service ${ENV}-ecs-service \
                        --force-new-deployment \
                        --region ${AWS_REGION}
                    '''
                }
            }
        }
        stage('Verify Deployment') {
            steps {
                script {
                    echo "✅ Deployment completed for ${params.ENV} environment!"
                    echo "🌐 Check website URL after Route53 setup: https://${params.ENV}.yourdomain.com"
                }
            }
        }
    }

    // The post block must be inside the pipeline { } block
    post {
        success {
            echo "🎉 ${params.ENV} deployment successful!"
            mail to: 'ramagirijithendar1998@gmail.com',
                 subject: "✅ Jenkins Build Success: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                 body: "The build succeeded!\nCheck details: ${env.BUILD_URL}"
        }
        failure {
            echo "❌ Deployment failed. Check Jenkins logs and CloudWatch for details."
            mail to: 'ramagirijithendar1998@gmail.com',
                 subject: "❌ Jenkins Build Failed: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                 body: "The build failed.\nPlease check console output: ${env.BUILD_URL}"
        }
    }
}

pipeline {
    agent any
    environment{
        AWS_REGION = "${env.AWS_REGION_KL}"
        AWS_ACCOUNT_ID          = "${env.AWS_ID_KL}"
        AWS_ACCESS_KEY_ID = credentials("aws_access_key_id_KL")
        AWS_SECRET_ACCESS_KEY = credentials("aws_secret_access_key_kl")
    }
    stages {
        stage ('Maven Test') {
            steps {
                sh 'mvn clean test'
            }
        }
        stage("SonarQube Analysis") {
            steps {
                withSonarQubeEnv("SonarServer") {
                    sh "mvn verify sonar:sonar"
                }  
            }
        }
        stage("Quality Gate") {
            steps {
                waitForQualityGate abortPipeline: true
            }
        }
        stage("Build") {
            steps {
                sh  'mvn clean install -DskipTests'
            }
        }
        stage("Containerize") {
            steps {
                sh "docker context use default"
                sh  "docker build -t ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/aline-user-kl:latest . --no-cache"
            }
        }
        stage("AWS Login") {
            steps {
                withAWS(credentials: 'AWS_Credientials_KL', region: "${AWS_REGION}") {
                    sh "docker login -u AWS -p \$(aws ecr get-login-password) ${AWS_ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com"
                }
            }
        }
        stage("Push to Repository") {
            steps {
                sh "docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/aline-user-kl:latest"
            }
        }
        stage("Create Context") {
            steps {
                withAWS(credentials: 'AWS_Credientials_KL', region: "${AWS_REGION}") {
                    sh 'if [ -z "$(docker context ls | grep "jenkins-ecs")" ]; then docker context create ecs jenkins-ecs --from-env; fi'
                    sh 'docker context use jenkins-ecs'
                }
            }
        }
        stage("Deploy ECS") {
            environment {
                PROJECT_NAME = "Aline-Financial-KL"
                DB_PORT = "3306"
                DB_NAME = "alinedb"
                DB_USERNAME = credentials("DB_USERNAME_KL")
                DB_PASSWORD = credentials("DB_PASSWORD_KL")
                ENCRYPT_SECRET_KEY = credentials("ENCRYPT_SECRET_KEY_KL")
                JWT_SECRET_KEY = credentials("JWT_SECRET_KEY_KL")
                LOADBALANCER_ARN = credentials("LOADBALANCER_ARN_KL")
            }
            steps {
                sh "cd ecs/ecs-compose && docker compose -p ${PROJECT_NAME} up -d"
            }
        }
    }
    post { 
            cleanup { 
                sh "docker context use default"
                sh "docker container prune -f && docker image prune --all -f"
            }
    }
}

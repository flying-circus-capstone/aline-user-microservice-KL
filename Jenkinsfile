pipeline {
    agent any
    environment{
        APP_PORT =            ''
        DB_USERNAME =         ''
        DB_PASSWORD =         ''
        DB_HOST =             ''
        DB_PORT =             ''
        DB_NAME =             ''
        ENCRIPT_SECRET_KEY =  ''
        JWT_SECRET_KEY =      ''
        AWS_BUCKET = 'klinsmoothstack/Jenkins'
        AWS_REGION = 'us-west-1'
    }

    stages {
        stage("Build") {
            steps {
                powershell  '''
                git submodule add --force https://github.com/flying-circus-capstone/core.git
                git submodule update
                mvn clean install -DskipTests
                '''
            }
        }
        stage("Archive") {
            steps {
                archiveArtifacts artifacts: 'user-microservice/target/*.jar', 
                allowEmptyArchive: false,
                caseSensitive: false,
                fingerprint: true,
                followSymlinks: false 
            }
        }
        stage("Containerize") {
            steps {
                powershell  "docker build -t klinsmoothstack/user . --no-cache"
            }
        }
        stage("Deploy") {
            steps {
                s3Upload consoleLogLevel: 'INFO',
                dontSetBuildResultOnFailure: false,
                dontWaitForConcurrentBuildCompletion: false,
                entries: [[bucket: AWS_BUCKET, excludedFile: '', flatten: false, gzipFiles: true, keepForever: false, managedArtifacts: false, noUploadOnFailure: true, selectedRegion: AWS_REGION, showDirectlyInBrowser: false, sourceFile: 'user-microservice/target/*.jar', storageClass: 'STANDARD', uploadFromSlave: false, useServerSideEncryption: false]], pluginFailureResultConstraint: 'FAILURE', profileName: 'AWS S3', userMetadata: []
            }
        }
    }
}

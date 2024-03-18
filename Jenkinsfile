pipeline {
    agent any

    environment {
        // Docker 이미지 이름과 태그 설정
        IMAGE_NAME = 'Simchengonge_spring'
        IMAGE_TAG = 'latest'
    }


    stages {
        stage('Check Changes') {
            steps {
                script {
                // 마지막 성공한 빌드 이후 변경된 파일 목록을 가져옴
                def changedFiles = sh(script: "git diff --name-only HEAD \$(git rev-parse HEAD~1)", returnStdout: true).trim()
                // 변경된 파일이 백엔드 디렉토리 내에 있는지 확인
                env.BUILD_FE = changedFiles.contains("simcheonge_front/") ? "true" : "false"
                // 변경된 파일이 프론트엔드 디렉토리 내에 있는지 확인
                env.BUILD_BE = changedFiles.contains("simcheonge_server/") ? "true" : "false"
                }
            }
        }

        stage('Spring Env Prepare') {
                when {
                    expression { env.BUILD_BE == "true" }
                }
                steps {
                    // Secret File Credential을 사용하여 설정 파일을 임시 경로로 복사
                    withCredentials([file(credentialsId: 'Spring_Env', variable: 'properties')]) {
                    script{
                        sh 'pwd'
                        sh 'ls simcheonge_server/src/'
                        sh 'ls simcheonge_server/src/main/'
                        sh 'ls simcheonge_server/src/main/resources/'

                        // 설정 파일을 현재 작업 디렉토리로 복사
                        sh 'cp $properties simcheonge_server/src/main/resources/application-env.properties'
                    }
                }   
            }
        }

        stage('Build Spring Code') {
            when {
                expression { env.BUILD_BE == "true" }
            }
            steps {
                script {
                    dir('simcheonge_server') {
                        // Gradle을 사용하여 Spring 애플리케이션 빌드
                        sh 'chmod +x ./gradlew' // 실행 권한 추가
                        sh './gradlew build'
                        echo "Spring Build finished"
                    }
                }
            }
        }

        stage('Build Spring Image ') {
          when {
                expression { env.BUILD_BE == "true" }
            }
            steps {
                // Docker 이미지 빌드
                script {
                    dir('simcheonge_server') {
                    sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
                    }
                }
            }
        }

        stage('Run Spring Container') {
            when {
                expression { env.BUILD_BE == "true" }
            }
            steps {
                // Docker 컨테이너 실행
                script {
                    sh "docker run -d --name my-spring-app ${IMAGE_NAME}:${IMAGE_TAG}"
                }
            }
        }
    }

    post {
        always {
            echo 'Build process completed.'
        }
    }
}

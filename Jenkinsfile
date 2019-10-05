node() {
def workspace = pwd()
def remote = [:]
remote.name = "master"
remote.host = "192.168.86.100"
remote.allowAnyHosts = true

 stage('Clone') {
    echo "1.Clone Stage"
    deleteDir()
    checkout scm
    script {
            build_tag = sh(returnStdout: true, script: 'git rev-parse --short HEAD').trim()
            if (env.BRANCH_NAME != 'master') {
                            build_tag = "${env.BRANCH_NAME}-${build_tag}"
             }
        }
    }
  stage('Test') {
        echo "2.Test Stage"
        withMaven(maven: 'maven3.6.2'){
            sh 'mvn  -U clean install -Dmvn.test.skip=true -Ptest'
        }

  }
  stage('Build') {
        echo "3.Build Docker Image Stage"
        withCredentials([usernamePassword(credentialsId: 'ssh', passwordVariable: 'sshPassword', usernameVariable: 'sshUserName')]) {
            remote.user = "${sshUserName}"
            remote.password = "${sshPassword}"
            sshCommand remote: remote, command: "cd /data/k8s/jenkins2/workspace/k8s-jenkins_${env.BRANCH_NAME}/ && docker build -t zhugeaming/jenkins-demo:${build_tag} ."

        }
    }
  stage('Push') {
        echo "4.Push Docker Image Stage"
        withCredentials([usernamePassword(credentialsId: 'dockerHub', passwordVariable: 'dockerHubPassword', usernameVariable: 'dockerHubUser')]) {
            sshCommand remote: remote, command: "docker login -u ${dockerHubUser} -p ${dockerHubPassword}"
            sshCommand remote: remote, command: "docker push zhugeaming/jenkins-demo:${build_tag}"
        }
    }

   stage('Deploy') {
        echo "5. Deploy Stage"
        echo "This is a deploy step to ${env.BRANCH_NAME}"
         if (env.BRANCH_NAME == 'master') {
                    input "确认要部署线上环境吗？"
                }
        sshCommand remote: remote, command: "cd /data/k8s/jenkins2/workspace/k8s-jenkins_${env.BRANCH_NAME}/ && sed -i 's/<BUILD_TAG>/${build_tag}/' k8s.yaml"
        sshCommand remote: remote, command: "cd /data/k8s/jenkins2/workspace/k8s-jenkins_${env.BRANCH_NAME}/ && sed -i 's/<BRANCH_NAME>/${env.BRANCH_NAME}/' k8s.yaml"
        sshCommand remote: remote, command: "cd /data/k8s/jenkins2/workspace/k8s-jenkins_${env.BRANCH_NAME}/ && kubectl apply -f k8s.yaml"
    }
}
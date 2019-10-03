node() {
def workspace = pwd()
def remote = [:]
remote.name = "master"
remote.host = "192.168.86.100"
remote.allowAnyHosts = true
  
 stage('Clone') {
    echo "1.Clone Stage"
    deleteDir()
    git url: "https://github.com/limingios/k8s-jenkins.git"
    script {
            build_tag = sh(returnStdout: true, script: 'git rev-parse --short HEAD').trim()
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
            sshCommand remote: remote, command: "cd /data/k8s/jenkins2/workspace/pipline-test/ && docker build -t zhugeaming/jenkins-demo:${build_tag} ."
    
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
        def userInput = input(
            id: 'userInput',
            message: 'Choose a deploy environment',
            parameters: [
                [
                    $class: '选择版本',
                    choices: "Dev\nQA\nProd",
                    name: 'Env'
                ]
            ]
        )
        echo "This is a deploy step to ${userInput}"
        sshCommand remote: remote, command: "cd /data/k8s/jenkins2/workspace/pipline-test/ && sed -i 's/<BUILD_TAG>/${build_tag}/' k8s.yaml"
        sshCommand remote: remote, command: "cd /data/k8s/jenkins2/workspace/pipline-test/ && sed -i 's/<BRANCH_NAME>/${env.BRANCH_NAME}/' k8s.yaml"
        if (userInput == "Dev") {
            // deploy DEV操作
        } else if (userInput == "QA"){
            // deploy QA操作
        } else {
            // deploy prod操作
        }
        sshCommand remote: remote, command: "cd /data/k8s/jenkins2/workspace/pipline-test/ && kubectl apply -f k8s.yaml"
    } 
}
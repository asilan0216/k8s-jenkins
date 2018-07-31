pipeline {
 agent {
   label '95ceebfb6166'
        }
 stages {
   stage('compile stage') {
     steps{
       withMaven(maven: 'maven')
       sh 'mvn compile'
        }
     }
  stage('testing stage') {
    steps{
      withMaven(maven: 'maven')
      sh 'mvn test'
       }
    }
  stage('install stage') {
    steps{
      withMaven(maven: 'maven')
      sh 'mvn install'
}
}
}	  
}

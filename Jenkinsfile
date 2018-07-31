pipeline {
 agent any
 stages {
   stage('clean stage') {
     steps {
      withMaven(maven: 'maven')
      sh 'mvn clean'
	}
     }
   stage('compile stage') {
     steps {
       withMaven(maven: 'maven')
       sh 'mvn compile'
        }
     }
  stage('testing stage') {
    steps {
      withMaven(maven: 'maven')
      sh 'mvn test'
       }
    }
  stage('install stage') {
    steps {
      withMaven(maven: 'maven')
      sh 'mvn install'
	}
    }
}
}



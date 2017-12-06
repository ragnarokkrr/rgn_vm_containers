// Test
node {

  stage('Configure') {
    env.PATH = "${tool 'maven-3.3.9'}/bin:${env.PATH}"
    env.JAVA_HOME="${tool 'oracle_jdk_8u131'}"
    env.PATH="${env.JAVA_HOME}/bin:${env.PATH}"
    sh 'java -version'

  }

  stage('Checkout') {
    git 'https://github.com/bertjan/spring-boot-sample'
  }

  stage('Build') {
    sh 'mvn -B -V -U -e clean package'
  }

  stage('Archive') {
    junit allowEmptyResults: true, testResults: '**/target/**/TEST*.xml'
  }

}

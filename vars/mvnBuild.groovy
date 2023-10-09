def build() {
  sh 'cd /var/lib/jenkins/workspace/shared-library/java-spring-boot-app && mvn clean package'
}

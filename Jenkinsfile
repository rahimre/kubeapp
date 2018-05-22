#!groovy​
podTemplate(label: 'kubeapp', containers: [
    containerTemplate(name: 'maven', image: 'maven', ttyEnabled: true, command: 'cat'),
    containerTemplate(name: 'kubectl', image: 'kubectl', ttyEnabled: true, command: 'cat',
        volumes: [secretVolume(secretName: 'kube-config', mountPath: '/home/cloudslip/.kube')]),
    containerTemplate(name: 'docker', image: 'docker', ttyEnabled: true, command: 'cat',
        volumes: [hostPathVolume(hostPath: '/var/run/docker.sock', mountPath: '/var/run/docker.sock')]),
        
  ]) {

    node('kubeapp') {

        def DOCKER_HUB_ACCOUNT = 'dckreg:5000'
        def DOCKER_IMAGE_NAME = 'kubeapp'
        def K8S_DEPLOYMENT_NAME = 'kubeapp'
        def BUILD_NUMBER = sh (script: "git log -n 1 --pretty=format:'%H'", returnStdout: true)

        stage('Clone kubeapp Repository') {
            checkout scm
 
            container('maven') {
                stage('Maven Build') {
                    sh ("mvn clean install")
                }
            }

            container('docker') {
                stage('Docker Build & Push Current & Latest Versions') {
                    sh ("docker build -t ${DOCKER_HUB_ACCOUNT}/${DOCKER_IMAGE_NAME}:${BUILD_NUMBER} .")
                    sh ("docker push ${DOCKER_HUB_ACCOUNT}/${DOCKER_IMAGE_NAME}:${BUILD_NUMBER}")
                    sh ("docker tag ${DOCKER_HUB_ACCOUNT}/${DOCKER_IMAGE_NAME}:${BUILD_NUMBER} ${DOCKER_HUB_ACCOUNT}/${DOCKER_IMAGE_NAME}:latest")
                    sh ("docker push ${DOCKER_HUB_ACCOUNT}/${DOCKER_IMAGE_NAME}:latest")
                }
            }

        }        
    }
}

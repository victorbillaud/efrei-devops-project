node('custom-docker-slave') {
    stage('Checkout') {
        git url: 'https://github.com/victorbillaud/portfolio-next', branch: 'main'
    }
    stage('Build') {
        sh 'docker stop portfolio-next || true && docker rm portfolio-next || true'
        sh 'docker build -t portfolio-next:${BUILD_NUMBER} .'
        sh 'docker tag portfolio-next:${BUILD_NUMBER} portfolio-next:latest'
    }
    stage('Test') {
        sh 'docker run --rm portfolio-next:latest npm run run-tests'
    }
    stage('Deploy') {
        sh 'docker run -d -p 3000:3000 --name=portfolio-next portfolio-next:latest'
    }
}

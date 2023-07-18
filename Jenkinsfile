def sendDiscordNotifer(message, footer) {
    discordSend description: message, footer: footer, link: env.BUILD_URL, result: currentBuild.currentResult, title: JOB_NAME, webhookURL: "https://discord.com/api/webhooks/1130779978473152594/atG0OMY1qC-MH4MGW6maAnoRv9ZKBJR_CCjS9KcWdpyXrGm9EXjTdYg0lquV8kOpYh1W"
}

node('custom-docker-slave') {
    stage('Checkout') {
        git url: 'https://github.com/victorbillaud/portfolio-next', branch: 'main'
        sendDiscordNotifer("Checkout", "Checkout")
    }
    stage('Build') {
        sh 'docker stop portfolio-next || true && docker rm portfolio-next || true'
        sh 'docker build -t portfolio-next:${BUILD_NUMBER} .'
        sh 'docker tag portfolio-next:${BUILD_NUMBER} portfolio-next:latest'
        sendDiscordNotifer("Build", "Build")
    }
    stage('Test') {
        sh 'docker run --rm portfolio-next:latest npm run run-tests'
        sendDiscordNotifer("Test", "Test")
    }
    stage('Deploy') {
        sh 'docker run -d -p 3000:3000 --name=portfolio-next portfolio-next:latest'
        sendDiscordNotifer("Deploy", "Deploy")
    }
}

// https://discord.com/api/webhooks/1130779978473152594/atG0OMY1qC-MH4MGW6maAnoRv9ZKBJR_CCjS9KcWdpyXrGm9EXjTdYg0lquV8kOpYh1W
pipeline{
    agent any
    // {
    //     node {
    //         label 'agent-1'
    //     }
    // }

    // environment {
    //     GREETING = 'hello jenkins'
    // }
    // options {
    //     timeout(time: 1, unit: 'SECONDS')
    //     disableConcurrentBuild()  // this will stops if again and again building the same pipelins
    // }

    stages{
        stage('Init') {
            steps {
                sh """

                cd 01-vpc
                terrraform init -reconfigure

                """
            }

        } 
        stage('Plan') {
            steps {
                sh """

                cd 01-vpc
                terrraform plan

                """
            }
        }
        stage('Deploy') {
            input {
                message "Should we continue"
                ok "yes ,we should "
            }
            steps {
                steps {
                    sh """

                    cd 01-vpc
                    terraform apply -auto-approve

                    """


                }
                
            }
        }
        
    }
}

// post build

// post {
//     always {
//         echo 'it will always say hello again'
//     }
//     failure {
//         echo ' it will run when pipline is failed, used generally to send alrets '
//     }
//     success{
//         echo ' ur pipe is success'
//     }
// }
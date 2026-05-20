pipeline{

    agent any
    

    // agent any
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
    //     disableConcurrentBuild()
    //   // this will sxtops if again and again building the same pipelins
           // ansiColor('Xterm') >> to enable colours in jenkins
    // }

    // options {
    //     ansiColor('xterm')

    // }

    // parameters {

    //     choice(name: 'action',choices: ['apply','destroy'],description: 'pick something')
    // }

    stages{
        stage('VPC') {
            steps {
                sh """

                cd 1-vpc
                terraform init -reconfigure
                terraform apply -auto-approve

                """
            }

        } 
        stage('SG') {
            steps {
                sh """

                cd 2-sg
                terraform init -reconfigure
                terraform apply -auto-approve

                """
            }

        } 
        stage('VPN') {
            steps {
                sh """

                cd 3-vpn
                terraform init -reconfigure
                terraform apply -auto-approve

                """
            }

        } 
        stage('DB ALB') {
            parallel{
                stage('DB'){
                    steps {
                        sh """
                        cd 4-database
                        terraform init -reconfigure
                        terraform apply -auto-approve

                        """
                    }
                }
                stage('app-alb'){
                    steps {
                        sh """

                        cd 5-app-alb
                        terraform init -reconfigure
                        terraform apply -auto-approve

                        """

                    
                    }
                }
            }
        }
        // stage('Plan') {
        //     steps {
        //         sh """

        //         cd 1-vpc
        //         terrraform plan

        //         """
        //     }
        // }
        // stage('Deploy') {
        //     when {
        //        expression{
        //             params.action == 'apply'
                   

        //         }
        //     }
        //     input {
        //         message "Should we continue"
        //         ok "yes ,we should "
        //     }
        //     steps {
        //         steps {
        //             sh """

        //             cd 1-vpc
        //             terraform apply -auto-approve

        //             """


        //         }
                
        //     }
        // }
        // stage('Destroy') {
        //     when {
        //        expression{
        //             params.action == 'destroy'
                   

//                 }
//             }
//             input {
//                 message "Should we continue"
//                 ok "yes ,we should "
//             }
//             steps {
//                 steps {
//                     sh """

//                     cd 1-vpc
//                     terraform destroy -auto-approve

//                     """


//                 }
                
//             }

        
//     }
// }
// }
//post build

post {
    always {
        echo 'it will always say hello again'
    }
    failure {
        echo ' it will run when pipline is failed, used generally to send alrets '
    }
    success{
        echo ' ur pipe is success'
    }
    deleteDir() // we run multiple pipline we in every pipeling after complilation 
            //we removing the directories
    cleanWs() 
}
    

}
}
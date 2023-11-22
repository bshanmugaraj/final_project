node {
    stage "Checkout" 
    projectRootDirectory = pwd()
    println ("project root: " + projectRootDirectory)
    println ("cleaning project root: " + projectRootDirectory)
    sh "sudo rm -rf ${projectRootDirectory} || true ; mkdir -p ${projectRootDirectory}"
    checkout scm
    withCredentials([string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY'),
                     string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_KEY')]) {
    

    stage('Terraform Plan') {
        // List of Terraform files to Plan
        def terraformFiles = ['tim.tf', 'grid.tf']

        // Loop through each Terraform file and apply
        terraformFiles.each { file ->
            echo "Applying Terraform configuration in $file"
            
            // Run Terraform init and apply for each file
            sh "terraform init -input=false -backend-config=backend.config -var-file=variables.tfvars"
            sh "terraform plan -var 'file=$file'"
         }
      }
   }
}

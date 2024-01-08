node {
    stage "Checkout"
    projectRootDirectory = pwd()
    println ("project root: " + projectRootDirectory)
    println ("cleaning project root: " + projectRootDirectory)
    sh "sudo rm -rf ${projectRootDirectory} || true ; mkdir -p ${projectRootDirectory}"
    checkout scm
    withCredentials([string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY'),
                     string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_KEY')]) {
        parameters {
            string(name: 'SERVICE', defaultValue: 'grid', description: 'Specify the Service name to run')
            string(name: 'prod_fo_as2', defaultValue: '', description: 'Target Record')
            string(name: 'prod_fo_ch2', defaultValue: '', description: 'Target Record')
            string(name: 'prod_fo_ho2', defaultValue: '', description: 'Target Record')
            string(name: 'prod_fo_us_east_1', defaultValue: '', description: 'Target Record')
            string(name: 'prod_fo_us_west_2a', defaultValue: '', description: 'Target Record')
        }
        stage('Update Weight') {
            def SERVICE_NAME = params.SERVICE
            sh '''
                #!/bin/bash
                update_file (){
                    local file_path="$1"
                    local target_string="$2"
                    local new_weight="$3"
                    local service="$4"

                    # Search for the target string and its associated weight
                    while IFS= read -r line; do
                        if [[ "$line" == *"$target_string"* ]]; then
                            # If the target string is found, find the weight in the previous lines
                            #echo $line
                            line_number=$(grep -n "$target_string" "$file_path" | cut -d: -f1)
                            while [ "$line_number" -gt 1 ]; do
                                line_number=$((line_number - 1))
                                previous_line=$(sed -n "${line_number}p" "$file_path")
                                if [[ "$previous_line" == *weight* ]]; then
                                    current_weight=$(echo "$previous_line" | grep -o '[[:digit:]]*')
                                    sed -i -e "${line_number}s/${current_weight}/${new_weight}/1" "$file_path"

                                    echo "Weight updated from $current_weight to $new_weight in $service $target_string"
                                    break
                                fi
                            done
                        fi
                    done < "$file_path"
            }

            if [ ! -z ${prod_fo_as2} ]; then
                target_string="prod-fo-as2.test.com"
                new_weight="${prod_fo_as2}"
                #echo $new_weight
                update_file "${SERVICE}-rr.tf" $target_string $new_weight $SERVICE
            fi

            if [ ! -z ${prod_fo_ch2} ]; then
                target_string="prod-fo-ch2.test.com"
                new_weight="${prod_fo_ch2}"
                #echo $new_weight
                update_file "${SERVICE}-rr.tf" $target_string $new_weight $SERVICE
            fi

            if [ ! -z ${prod_fo_ho2} ]; then
                target_string="prod-fo-ho2.test.com"
                new_weight="${prod_fo_ho2}"
                #echo $new_weight
                update_file "${SERVICE}-rr.tf" $target_string $new_weight $SERVICE
            fi

            if [ ! -z ${prod_fo_us_east_1} ]; then
                target_string="prod-fo-us-east-1.test.com"
                new_weight="${prod_fo_us_east_1}"
                #echo $new_weight
                update_file "${SERVICE}-rr.tf" $target_string $new_weight $SERVICE
            fi

            if [ ! -z ${prod_fo_us_west_2a} ]; then
                target_string="${SERVICE}-prod-fo-us-west-2a.r53.test.com"
                new_weight="${prod_fo_us_west_2a}"
                #echo $new_weight
                update_file "${SERVICE}-rr.tf" $target_string $new_weight $SERVICE
            fi
            '''
            
      }
        stage('Plan') {
            // Enforce a 5 min timeout on init. TF init has a tendency to hang trying to download the aws provider plugin.
            timeout(5) {
                // init the configured s3 backend
                sh "terraform init -backend=true"
            }
            // get the current remote state:
            sh "terraform get"
            
            // run a plan, save its output in a file, exit with detailed 0,1,2 codes
            sh "set +e; terraform plan -out=plan.out -detailed-exitcode; echo \$? > status"
            def exitCode = readFile('status').trim()
            echo "Terraform Plan Exit Code: ${exitCode}"
        }
        stage('Approval') {
            // Manual approval step
            input 'Proceed with Terraform apply?'
        }

        
        stage('Commit GIT') {
            catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
            withCredentials([sshUserPrivateKey(credentialsId: 'eeadb089-6f96-412c-96f8-0e7b2f348d49', keyFileVariable: 'jenkins')]) {
            sh "git config user.email shanmugarajb.97@gmail.com"
            sh "git config user.name bshanmugaraj"
            sh "git pull git@github.com:bshanmugaraj/final_project.git HEAD:master"
            sh "git add ."
            sh "git commit -m 'Commited on Traffic shaping triggered Build: ${env.BUILD_NUMBER}'"   
            sh "git push git@github.com:bshanmugaraj/final_project.git HEAD:master"     
            }
        }
     }
   }
}

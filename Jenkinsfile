pipeline {

agent any 

environment {
  WORK_DIR = "${env.WORKSPACE}"
  Ansible_Playbook_Path='/home/ansible/pushdockercomposefile.yml'
} 
tools{
  maven "localmaven"
}
stages {
    stage(codecheckout) {
	  steps {
	   git credentialsId: '0cf1bb77-dee7-4696-8f56-b212a635be3a', url: 'https://github.com/DevOps-Traning/AddressBook.git'
	  }
	}
    stage(codecoverage) {
	  steps {
	   sh "mvn sonar:sonar -Dsonar.host.url=http://65.0.107.192:9000 -Dsonar.login=squ_492e921370b7e66c1d9b8403e4dd15c2a5884b44"
	  }
	}
    stage(mavenbuild) {
	  steps {
	   sh "mvn clean deploy"
	  }
	}
    stage(dockerbuild) {
	  steps {
	   sh """
	   echo "containerising the application"   
	   cd $WORK_DIR 
	   docker build -t devops715/addressbookdemo ."""
	  }
	}
	stage("dockerimageupload") {
    steps {
        withCredentials([usernamePassword(
            credentialsId: 'dockerhub-creds',
            usernameVariable: 'DOCKER_USER',
            passwordVariable: 'DOCKER_PASS'
        )]) {
            sh '''
                echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                docker push devops715/addressbookdemo
            '''
        }
    }
}
    stage(copydockercomposefile) {
	  steps {
	   sh """
	   echo "copying the compose file to the target server" 
       scp 	$WORK_DIR/docker-compose.yml ansible@13.203.220.64:/home/ansible  
       """
	  }
	}
	stage('invokeansibleplaybook') {
      steps {
        sh '''
            ssh -o StrictHostKeyChecking=no ansible@13.203.220.64 \
            "ansible-playbook ${Ansible_Playbook_Path}"
        '''
    }
}
 }
}

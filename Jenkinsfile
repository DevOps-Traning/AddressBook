pipeline {
    agent any

tools{
  maven 'linuxmaven'
}

environment{
  Ansible_Playbook_Path='/home/ansible/pushdockercompfile.yaml'
}
 
 stages {
   stage ("codecheckout"){
     steps {
     git credentialsId: 'c37ffed3-819e-4d9b-a85b-fe6c9414b30c', url: 'https://github.com/DevOps-Traning/AddressBook.git'
    }
   }
   stage ("codecoverage"){
     steps {
     sh 'mvn sonar:sonar -Dsonar.login=squ_536a507a4c77fcc7b2350630ccc5a927c5dec830'
    }
   }
   stage ("mavenbuild"){
     steps {
     sh 'mvn clean deploy'
    }
   }
   stage ("dockerbuild"){
     steps {
	 sh """
            echo "Building Docker image from workspace: ${env.WORKSPACE}"
            cd ${env.WORKSPACE}
            docker build -t devops715/addrbookdemo .
        """
    }
   }
   stage ("dockerimageupload"){
     steps {
        sh 'docker login -u devops715 -p Drithi@1321'
		sh 'docker push devops715/addrbookdemo'
    }
   }
   stage('copy-docker-compose') {
    steps {
        sh """
            echo "Copying docker-compose.yml to remote server..."
            scp ${env.WORKSPACE}/docker-compose.yml ansible@3.110.140.163:/home/ansible/
        """
    }
    }
    stage('invoke-ansible-playbook') {
    steps {
        sh """
            ssh -o StrictHostKeyChecking=no ansible@3.110.140.163 \
            "ansible-playbook ${Ansible_Playbook_Path}"
        """
    }
    }
  }
}

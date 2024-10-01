# This script uses SSH to run the Ansible playbook on the VM
$vmUser = "azureuser"  # Replace with your VM username
$vmIP = "X.X.X.X"      # Replace with the public IP address of your VM
$sshKeyPath = "~/.ssh/mykey"  # Path to your SSH key file

# Command to run the Ansible playbook
$ansibleCommand = "ansible-playbook /path/to/automation-playbook.yml"

# Run the playbook via SSH
ssh -i $sshKeyPath $vmUser@$vmIP "$ansibleCommand"

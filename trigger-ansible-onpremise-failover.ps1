# Retrieve the SSH Username and Password from Key Vault using Managed Identity
$vaultName = "MyKeyVault"
$sshUsername = (Get-AzKeyVaultSecret -VaultName $vaultName -Name "ssh-username").SecretValueText
$sshPassword = (Get-AzKeyVaultSecret -VaultName $vaultName -Name "ssh-password").SecretValueText

# Create a secure string for the password
$secpasswd = ConvertTo-SecureString $sshPassword -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential ($sshUsername, $secpasswd)

# SSH into the VM or Hybrid Worker using the retrieved credentials
$vmIP = "X.X.X.X"
$sshKeyPath = "~/.ssh/mykey"

# Command to run the Ansible playbook for on-premise to East US failover
$ansibleCommand = "ansible-playbook /path/to/automation-playbook-onpremise-to-eastus.yml"

# Execute the playbook via SSH
ssh -i $sshKeyPath $sshUsername@$vmIP "$ansibleCommand"

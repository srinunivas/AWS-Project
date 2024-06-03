#-------------------------------------------------------------
#                   Private - EC2 - Windows - No Encryption 
#-------------------------------------------------------------

module "private_ec2_windows1" {
  source                      = "../Modules/EC2"
  image_id                    = "ami-02db44a38cfb5d753"
  availability_zone           = "us-east-2a"
  associate_public_ip_address = false
  instance_name = "ec2-nlb-pri-web-001"
  instance_type = "t2.micro"
  subnet_id     = module.vpc.private_subnet_id_1
  sg_id         = module.vpc.default_security_group_id
  key_pair = "ec2-key"
  root_block_device = {
    delete_on_termination = true
    encrypted             = false
    tags = {
      "key" = "root"
    }
    volume_size = 40
    volume_type = "gp2"
  }

  ebs_block_devices = [
    {
      delete_on_termination = true
      device_name           = "/dev/sdf"
      encrypted             = false
      tags                  = local.tags
      volume_size           = 20
      volume_type           = "gp2"
    },
    {
      delete_on_termination = true
      device_name           = "/dev/sdg"
      encrypted             = false
      tags                  = local.tags
      volume_size           = 40
      volume_type           = "gp3"
    }
  ]

  user_data = <<-EOF
    <powershell>
    Add-WindowsFeature Web-Server
    Set-Content -Path "C:\\inetpub\\wwwroot\\index.html" -Value "<html><body><h1>Hello, World!</h1></body></html>"
    Start-Service W3SVC
    </powershell>
  EOF

  tags = local.tags
  org_name = "safemarch"
  project_name = "demo"
  env = "prod"
  region = "us-east-2"
}

output "private_ec2_windows1_id" {
  value = module.private_ec2_windows1.instance_id
}

#-------------------------------------------------------------
#                   Private - EC2 - Windows - CMK Encryption 
#-------------------------------------------------------------

module "private_ec2_windows2" {
  source                      = "../Modules/EC2"
  image_id                    = "ami-02db44a38cfb5d753"
  availability_zone           = "us-east-2a"
  associate_public_ip_address = false
  instance_name = "ec2-nlb-pri-web-002"
  instance_type = "t2.micro"
  subnet_id     = module.vpc.private_subnet_id_1
  sg_id         = module.vpc.default_security_group_id
  key_pair = "ec2-key"
  root_block_device = {
    delete_on_termination = true
    encrypted             = true
    tags = {
      "key" = "root"
    }
    volume_size = 40
    volume_type = "gp2"
  }

  ebs_block_devices = [
    {
      delete_on_termination = true
      device_name           = "/dev/sdf"
      encrypted             = true
      tags                  = local.tags
      volume_size           = 20
      volume_type           = "gp2"
      kms_key_id            = module.kms-private.kms_id
    },
    {
      delete_on_termination = true
      device_name           = "/dev/sdg"
      encrypted             = true
      tags                  = local.tags
      volume_size           = 40
      volume_type           = "gp3"
      kms_key_id            = module.kms-private.kms_id
    }
  ]

  user_data = <<-EOF
    <powershell>
    Add-WindowsFeature Web-Server
    Set-Content -Path "C:\\inetpub\\wwwroot\\index.html" -Value "<html><body><h1>Hello, World!</h1></body></html>"
    Start-Service W3SVC
    </powershell>
  EOF

  tags = local.tags
  org_name = "safemarch"
  project_name = "demo"
  env = "prod"
  region = "us-east-2"
}

output "private_ec2_windows2_id" {
  value = module.private_ec2_windows2.instance_id
}

#-------------------------------------------------------------
#                   Public - EC2 - Windows - No Encryption 
#-------------------------------------------------------------

module "public_ec2_windows1" {
  source                      = "../Modules/EC2"
  image_id                    = "ami-02db44a38cfb5d753"
  availability_zone           = "us-east-2a"
  associate_public_ip_address = true
  instance_name = "ec2-nlb-pub-web-003"
  instance_type = "t2.micro"
  subnet_id     = module.vpc.public_subnet_id_1
  sg_id         = module.security_group.sg_id
  key_pair = "ec2-key"
  root_block_device = {
    delete_on_termination = true
    encrypted             = false
    tags = {
      "key" = "root"
    }
    volume_size = 40
    volume_type = "gp2"
  }

  ebs_block_devices = [
    {
      delete_on_termination = true
      device_name           = "/dev/sdf"
      encrypted             = false
      tags                  = local.tags
      volume_size           = 20
      volume_type           = "gp2"
    },
    {
      delete_on_termination = true
      device_name           = "/dev/sdg"
      encrypted             = false
      tags                  = local.tags
      volume_size           = 40
      volume_type           = "gp3"
    }
  ]

  user_data = <<-EOF
    <powershell>
    Add-WindowsFeature Web-Server
    Set-Content -Path "C:\\inetpub\\wwwroot\\index.html" -Value "<html><body><h1>Hello, World!</h1></body></html>"
    Start-Service W3SVC
    Write-Output 'This is some example data for file1.' | Out-File -FilePath C:\file1.txt
    Write-Output 'This is some example data for file2.' | Out-File -FilePath C:\file2.txt
    Invoke-WebRequest -Uri "https://dlptest.com/sample-data.pdf" -OutFile "C:\PII-sample-data.pdf"
    </powershell>
  EOF

  tags = local.tags
  org_name = "safemarch"
  project_name = "demo"
  env = "prod"
  region = "us-east-2"
}

output "public_ec2_windows1_id" {
  value = module.public_ec2_windows1.instance_id
}

#-------------------------------------------------------------
#                   Public - EC2 - Windows - CMK Encryption 
#-------------------------------------------------------------

module "public_ec2_windows2" {
  source                      = "../Modules/EC2"
  image_id                    = "ami-02db44a38cfb5d753"
  availability_zone           = "us-east-2a"
  associate_public_ip_address = true
  instance_name = "ec2-nlb-pub-web-004"
  instance_type = "t2.micro"
  subnet_id     = module.vpc.public_subnet_id_1
  sg_id         = module.security_group.sg_id
  key_pair = "ec2-key"
  root_block_device = {
    delete_on_termination = true
    encrypted             = true
    tags = {
      "key" = "root"
    }
    volume_size = 40
    volume_type = "gp2"
  }

  ebs_block_devices = [
    {
      delete_on_termination = true
      device_name           = "/dev/sdf"
      encrypted             = true
      tags                  = local.tags
      volume_size           = 20
      volume_type           = "gp2"
      kms_key_id            = module.kms-public.kms_id
    },
    {
      delete_on_termination = true
      device_name           = "/dev/sdg"
      encrypted             = true
      tags                  = local.tags
      volume_size           = 40
      volume_type           = "gp3"
      kms_key_id            = module.kms-public.kms_id
    }
  ]

  user_data = <<-EOF
    <powershell>
    Add-WindowsFeature Web-Server
    Set-Content -Path "C:\\inetpub\\wwwroot\\index.html" -Value "<html><body><h1>Hello, World!</h1></body></html>"
    Start-Service W3SVC
    Write-Output 'This is some example data for file1.' | Out-File -FilePath C:\file1.txt
    Write-Output 'This is some example data for file2.' | Out-File -FilePath C:\file2.txt
    Invoke-WebRequest -Uri "https://dlptest.com/sample-data.pdf" -OutFile "C:\PII-sample-data.pdf"
    </powershell>
  EOF

  tags = local.tags
  org_name = "safemarch"
  project_name = "demo"
  env = "prod"
  region = "us-east-2"
}

output "public_ec2_windows2_id" {
  value = module.public_ec2_windows2.instance_id
}
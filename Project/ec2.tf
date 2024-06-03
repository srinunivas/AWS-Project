#-------------------------------------------------------------
#                   Private - EC2 - Linux - No Encryption
#-------------------------------------------------------------
module "private_ec2_linux" {
  source                      = "../Modules/EC2"
  image_id                    = "ami-0b8b44ec9a8f90422"
  availability_zone           = "us-east-2a"
  associate_public_ip_address = false
  instance_name = "ec2-pri-webserver-001"
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
      encrypted             = false
      tags = {
        "volumetype" = "volume1"
      }
      volume_size = 20
      volume_type = "gp2"
    },
    {
      delete_on_termination = true
      device_name           = "/dev/sdg"
      encrypted             = false
      tags = {
        "volumetype" = "volume2"
      }
      volume_size = 40
      volume_type = "gp3"
    }
  ]

  user_data = <<-EOF
  #!/bin/bash
  sudo apt-get update
  sudo apt-get install apache2 -y
  sudo service apache2 start
  echo "<!DOCTYPE html>
  <html>
  <head>
  <title>Hello, World!</title>
  </head>
  <body>
  <h1>Hello, World!</h1>
  <p>This is a simple 'Hello, World!' webpage served by Apache2 on an AWS EC2 instance.</p>
  </body>
  </html>" | sudo tee /var/www/html/index.html
  EOF

  tags = local.tags
  org_name = "safemarch"
  project_name = "demo"
  env = "prod"
  region = "us-east-2"

}

output "private_ec2_linux_id" {
  value = module.private_ec2_linux.instance_id
}

#-------------------------------------------------------------
#                   Public - EC2 - Linux - No Encryption - Static IP
#-------------------------------------------------------------

resource "aws_eip" "public_ec2_linux_eip" {
  instance = module.public_ec2_linux.instance_id
}

module "public_ec2_linux" {
  source                      = "../Modules/EC2"
  image_id                    = "ami-0b8b44ec9a8f90422"
  availability_zone           = "us-east-2a"
  associate_public_ip_address = true
  instance_name = "ec2-pub-sip-webserver-001"
  instance_type = "t2.micro"
  subnet_id     = module.vpc.public_subnet_id_1
  sg_id         = module.security_group.sg_id
  key_pair = "ec2-key"
  root_block_device = {
    delete_on_termination = true
    encrypted             = false
    tags                  = local.tags
    volume_size           = 40
    volume_type           = "gp2"
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
#!/bin/bash
sudo apt-get update
sudo apt-get install apache2 -y
sudo service apache2 start
echo "<!DOCTYPE html>
<html>
<head>
<title>Hello, World!</title>
</head>
<body>
<h1>Hello, World!</h1>
<p>This is a simple 'Hello, World!' webpage served by Apache2 on an AWS EC2 instance.</p>
</body>
</html>" | sudo tee /var/www/html/index.html
echo "This is some example data for file1." > /home/ubuntu/file1.txt
echo "This is some example data for file2." > /home/ubuntu/file2.txt
mkfs.ext4 /dev/xvdf
mkdir /mnt/ebs
mount /dev/xvdf /mnt/ebs
echo "This is some example data for file1." > /mnt/ebs/Sample.txt 
wget -O /mnt/ebs/PII-sample-data.pdf "https://dlptest.com/sample-data.pdf"
  EOF

  tags = local.tags
  org_name = "safemarch"
  project_name = "demo"
  env = "prod"
  region = "us-east-2"

  depends_on = [module.s3_pubic_default_kms]
}

output "public_ec2_linux_id" {
  value = module.public_ec2_linux.instance_id
}

#-------------------------------------------------------------
#                   Public - EC2 - Windows - No Encryption - Static IP
#-------------------------------------------------------------

resource "aws_eip" "public_ec2_windows_eip" {
  instance = module.public_ec2_windows.instance_id
}

module "public_ec2_windows" {
  source                      = "../Modules/EC2"
  image_id                    = "ami-02db44a38cfb5d753"
  availability_zone           = "us-east-2a"
  associate_public_ip_address = true
  instance_name = "ec2-pub-sip-webserver-001"
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
      encrypted             = true
      tags                  = local.tags
      volume_size           = 20
      volume_type           = "gp2"
    },
    {
      delete_on_termination = true
      device_name           = "/dev/sdg"
      encrypted             = true
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

output "public_ec2_windows_id" {
  value = module.public_ec2_windows.instance_id
}

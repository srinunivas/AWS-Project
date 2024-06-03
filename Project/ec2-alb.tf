#-------------------------------------------------------------
#                   Private - EC2 - Linux - No Encryption
#-------------------------------------------------------------
module "private_ec2_linux1" {
  source                      = "../Modules/EC2"
  image_id                    = "ami-0b8b44ec9a8f90422"
  availability_zone           = "us-east-2a"
  associate_public_ip_address = false
  instance_name = "ec2-alb-pri-web-001"
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

output "private_ec2_linux1_id" {
  value = module.private_ec2_linux1.instance_id
}


#-------------------------------------------------------------
#                   Private - EC2 - Linux - CMK Encryption
#-------------------------------------------------------------
module "private_ec2_linux2" {
  source                      = "../Modules/EC2"
  image_id                    = "ami-0b8b44ec9a8f90422"
  availability_zone           = "us-east-2a"
  associate_public_ip_address = false
  instance_name = "ec2-alb-pri-web-002"
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
      tags = {
        "volumetype" = "volume1"
      }
      volume_size = 20
      volume_type = "gp2"
      kms_key_id  = module.kms-private.kms_id
    },
    {
      delete_on_termination = true
      device_name           = "/dev/sdg"
      encrypted             = true
      tags = {
        "volumetype" = "volume2"
      }
      volume_size = 40
      volume_type = "gp3"
      kms_key_id  = module.kms-private.kms_id
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

output "private_ec2_linux2_id" {
  value = module.private_ec2_linux2.instance_id
}

#-------------------------------------------------------------
#                   Public - EC2 - Linux - No Encryption
#-------------------------------------------------------------
module "public_ec2_linux1" {
  source                      = "../Modules/EC2"
  image_id                    = "ami-0b8b44ec9a8f90422"
  availability_zone           = "us-east-2a"
  associate_public_ip_address = false
  instance_name = "ec2-alb-pub-web-003"
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

}

output "public_ec2_linux1_id" {
  value = module.public_ec2_linux1.instance_id
}

#-------------------------------------------------------------
#                   Public - EC2 - Linux - CMK Encryption
#-------------------------------------------------------------
module "public_ec2_linux2" {
  source                      = "../Modules/EC2"
  image_id                    = "ami-0b8b44ec9a8f90422"
  availability_zone           = "us-east-2a"
  associate_public_ip_address = true
  instance_name = "ec2-alb-pub-web-004"
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

}

output "public_ec2_linux2_id" {
  value = module.public_ec2_linux2.instance_id
}
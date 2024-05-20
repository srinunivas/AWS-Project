resource "aws_launch_template" "example" {
  name          = var.launch_template_name # "example-launch-template"
  image_id      = var.ami_id
  instance_type = var.instance_type # "t2.micro"
  key_name      = var.key_name      # "aws-key1"
  #associate_public_ip_address = var.associate_public_ip_address
  block_device_mappings {
    device_name = var.ebs_device_name
    ebs {
      volume_size = var.ebs_volume_size
    }
  }

  network_interfaces {
    associate_public_ip_address = var.network_interface_associate_public_ip
    delete_on_termination       = var.delete_on_termination
    security_groups             = var.security_groups # ["sg-06645d621b14f6f5a"]
    subnet_id                   = var.subnet_id       # "subnet-0c4d2733b57ab57d4"
  }

  tag_specifications {
    resource_type = var.resource_type_tags # "instance"
    tags          = var.tags
  }

  monitoring {
    enabled = var.cw_monitoring
  }

}
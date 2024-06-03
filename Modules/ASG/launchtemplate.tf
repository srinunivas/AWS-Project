resource "aws_launch_template" "example" {
  name          = "${var.org_name}-${var.project_name}-${var.env}-${var.region}-${var.launch_template_name}"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  block_device_mappings {
    device_name = var.ebs_device_name
    ebs {
      volume_size = var.ebs_volume_size
    }
  }

  network_interfaces {
    associate_public_ip_address = var.network_interface_associate_public_ip
    delete_on_termination       = var.delete_on_termination
    security_groups             = var.security_groups
    subnet_id                   = var.subnet_id
  }

  tag_specifications {
    resource_type = var.resource_type_tags
    tags          = var.tags
  }

  monitoring {
    enabled = var.cw_monitoring
  }

}
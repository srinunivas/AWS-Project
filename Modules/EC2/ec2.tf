resource "aws_instance" "instance" {
  ami                         = var.image_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  availability_zone           = var.availability_zone
  associate_public_ip_address = var.associate_public_ip_address
  vpc_security_group_ids      = [var.sg_id]
  key_name                    = var.key_pair

  root_block_device {
    delete_on_termination = var.root_block_device.delete_on_termination
    encrypted             = var.root_block_device.encrypted
    volume_size           = var.root_block_device.volume_size
    volume_type           = var.root_block_device.volume_type
    kms_key_id            = var.root_block_device.kms_key_id
  }

  dynamic "ebs_block_device" {
    for_each = var.ebs_block_devices
    content {
      device_name           = ebs_block_device.value.device_name
      delete_on_termination = ebs_block_device.value.delete_on_termination
      encrypted             = ebs_block_device.value.encrypted
      volume_size           = ebs_block_device.value.volume_size
      volume_type           = ebs_block_device.value.volume_type
      kms_key_id            = ebs_block_device.value.kms_key_id
    }
  }

  user_data = var.user_data
  tags      = merge(var.tags, local.instance_name)
}

locals {
  instance_name = {
    Name = "${var.org_name}-${var.project_name}-${var.env}-${var.region}-${var.instance_name}"
  }
}

### Bastion Instance #####


resource "aws_instance" "bastion_ec2" {
  ami           = var.instance_ami
  instance_type = var.instance_type
  key_name = var.key_name
  security_groups = var.security_groups
  subnet_id = var.public_subnet
  private_ip = var.pre_assign_privateip
 
  # root disk
  root_block_device {
    volume_size           = var.volume_size
    volume_type           = "gp2"
    encrypted             = true
    # kms_key_id            = aws_kms_key.kopi-kms-key.key_id    
    delete_on_termination = true
    tags = {
        Name        = "Root-${var.environment}-bastion_EBS"
    }
  }
  depends_on = [aws_efs_mount_target.efs-mt]
  connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key = file(var.private_key_path)
    host     = aws_instance.bastion_ec2.public_ip
  }
  provisioner "file" {
    source = "scripts/${var.environment}-script.sh"
    destination = "/tmp/${var.environment}-script.sh"
  }
    provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/${var.environment}-script.sh",
      "/tmp/${var.environment}-script.sh ${aws_efs_file_system.efs.dns_name}",
    ]
  }

  provisioner "file" {
    source = "nginx-conf/"
    destination = "mount-ecs/nginx/config"
  }
  lifecycle {
    ignore_changes = [
      security_groups,
    ]
  }
  tags = {
    Name = "${var.environment}-BastionHost"
  }

}

######## EFS ##########
resource "aws_efs_file_system" "efs" {
  creation_token   = "${var.environment}-efs-ecs"
  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"
  encrypted        = "true"
  tags = {
    Name = "EFS-${var.environment}"
  }
}


resource "aws_efs_mount_target" "efs-mt" {
  count           = 2
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = var.private_subnets[count.index]
  security_groups = var.security_groups_efs
}
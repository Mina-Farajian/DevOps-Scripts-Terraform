
resource "aws_security_group" "efs" {
  name        = "efs-sg"
  description = "Allos inbound efs traffic from ec2"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    security_groups = [aws_security_group.ec2.id]
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
  }

  egress {
    security_groups = [aws_security_group.ec2.id]
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
  }
}
resource "aws_instance" "my_server" {
  ami             = "ami-00874d747dde814fa"
  instance_type   = "t2.micro"
  placement_group = "web"
  user_data       = <<-EOF
            #!/bin/bash
              sudo apt update -y
              sudo install apache2 -y
              sudo systemctl enable apache2
              EOF

  tags = {
    Name = "encrypted-ami"
  }
}

resource "aws_network_interface" "ENI-test" {
  subnet_id       = aws_subnet.my_subnet.id
  private_ips     = ["10.10.0.50"]
  security_groups = [aws_security_group.ec2.id]

  attachment {
    instance     = aws_instance.my_server.id
    device_index = 1
  }
}

resource "aws_efs_file_system" "efs-test" {
  creation_token   = "efs"
  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"
  encrypted        = "true"
}

resource "aws_efs_mount_target" "efs-mt" {
  #	count = length(data.aws_availability_zones.available.names)
  file_system_id  = aws_efs_file_system.efs-test.id
  subnet_id       = aws_subnet.my_subnet.id
  security_groups = [aws_security_group.efs.id]
}


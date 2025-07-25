locals {
  sensor_script = templatefile("${path.module}/sensor_upload.py", {
    s3_bucket_name = var.s3_bucket_name
  })
}

# EC2 Instance 

# EC2 Instance 
resource "aws_instance" "ec2_instance" {
  ami                    = "ami-0c101f26f147fa7fd"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  iam_instance_profile        = aws_iam_instance_profile.ec2_instance_profile.name
  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y python3 python3-pip cronie aws-cli 
    pip3 install boto3
    systemctl start crond
    systemctl enable crond

    # Write the Python script 
    cat > /home/ec2-user/sensor_upload.py << EOPY
    ${local.sensor_script}
    EOPY

    # Set the correct ownership 
    chown ec2-user:ec2-user /home/ec2-user/sensor_upload.py

    # Create the cron job to run every minute 
    echo "* * * * *  ec2-user python3 /home/ec2-user/sensor_upload.py" > /etc/cron.d/sensor_cron
    chmod 0644 /etc/cron.d/sensor_cron
  EOF

  tags = {
    Name = "sensor-ec2"
  }
}

#EC2 Security Group 
resource "aws_security_group" "ec2_sg" {
  name        = "ec2_sg"
  description = "security group for ec2 instance"
  vpc_id      = aws_vpc.main.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  tags = {
    Name = "ec2_sg"
  }
}

# EC2 instance with security group 

# EC2 Instance 
resource "aws_instance" "ec2_instance" {
  ami                         = "ami-0c101f26f147fa7fd"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  iam_instance_profile        = aws_iam_instance_profile.ec2_s3_upload_profile.name
  associate_public_ip_address = true

  tags = {
    Name = "ec2-instance"
  }
}

# EC2 Security Group 
resource "aws_security_group" "ec2_sg" {
  name        = "ec2-sg"
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
    Name = "ec2-sg"
  }
}

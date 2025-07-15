# EC2 instance with security group 

# EC2 Instance 
resource "aws_instance" "ec2_instance" {
  ami                         = "ami-0c101f26f147fa7fd"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public.id
  security_groups             = []
  iam_instance_profile        = aws_iam_instance_profile.ec2_s3_upload_profile.name
  associate_public_ip_address = true

  tags = {
    Name = "ec2-instance"
  }
}


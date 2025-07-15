# EC2 instance with security group 

# EC2 Instance 
resource "aws_instance" "ec2_instance" {
  ami           = "ami-0c101f26f147fa7fd"
  instance_type = "t2.micro"

}

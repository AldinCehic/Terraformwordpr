# Setup for a wordpress instance
# Make sure install_wp.sh is available on same directory level

resource "aws_instance" "ec2_instance" {
  ami                     = var.ami
  instance_type           = "t3.micro"
  subnet_id               = aws_subnet.public_subnet.id
  vpc_security_group_ids  = [aws_security_group.allow_http_ssh_access.id]
  key_name                = var.key
  associate_public_ip_address = true
  user_data = "${file("install_wp.sh")}"

  tags = {
    Name = "WP_EC2"
  }
}

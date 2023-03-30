# Setup for necessary security group

resource "aws_security_group" "allow_http_ssh_access" {
  name        = "allow_http__ssh_access"
  vpc_id      = aws_vpc.nf_vpc.id

# Allow inbound access/ingress from ports 80 & 22
  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = var.CIDR
  }

  ingress {
    description      = "allow SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = var.CIDR
  }

# Allow outbound/egress to anywhere
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = var.CIDR
  }

# Allow outbound via 3306 to connect with database
  egress {
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = ["10.0.1.0/24"]
  }

  tags = {
    Name = "allow_http__ssh_access"
  }
}

# Allow ingress on aurora db via 3306
resource "aws_security_group" "allow_aurora_access" {
  name        = "allow_aurora_access"
  vpc_id = aws_vpc.nf_vpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.allow_http_ssh_access.id] 
  }

  tags = {
    Name = "aurora-stack-allow-aurora-MySQL"
  }
}
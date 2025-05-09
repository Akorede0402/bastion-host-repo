# create security group for the public instance
# terraform aws create security group
resource "aws_security_group" "jump-host_sg" {
  name        = "jump-host_sg"
  description = "Allow SSH to jump server port 22"
  vpc_id      = aws_vpc.tribalchief_vpc.id

  ingress {
    description = "Allow SSH to jump server port 22"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["50.101.215.59/32"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Web Server Security Group"
  }
}
# create security group for the private instance
# terraform aws create security group
resource "aws_security_group" "tribalchief_private_instance_sg" {
  name        = "private_instance_sg"
  description = "Allow SSH access from jump host"
  vpc_id      = aws_vpc.tribalchief_vpc.id

  ingress {
    description     = "Allow SSH access from jump host"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.jump-host_sg.id]
  }
  ingress {
    description = "Allow SSH access from jump host"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Private-Instance Security Group"
  }
}

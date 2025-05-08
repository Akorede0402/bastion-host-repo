# This is to create an instance in the public subnet(jump host)
resource "aws_instance" "tribal_chief_jump_host_instance" {
  ami                         = "ami-085386e29e44dacd7" # This AMI value is unique per region (US-EAST-1). Ensure to use the AMI ID for the region you are deploying to.
  instance_type               = "t2.micro"
  key_name                    = "patty-moore-key" # Ensure to put your own unique key pair name. 
  subnet_id                   = aws_subnet.tribalchief_public_subnet-az1a.id
  vpc_security_group_ids      = [aws_security_group.jump-host_sg.id]
  associate_public_ip_address = true


  tags = {
    Name = "tribalchief_jump_host_public_instance"
  }
}

# This is to create an instance in the private subnet 
resource "aws_instance" "tribal_chief__private_instance" {
  ami                         = "ami-085386e29e44dacd7" # This AMI value is unique per region (US-EAST-1). Ensure to use the AMI ID for the region you are deploying to.
  instance_type               = "t2.micro"
  key_name                    = "patty-moore-key" # Ensure to put your own unique key pair name. 
  subnet_id                   = aws_subnet.tribalchief_private_app_subnet-az1a.id
  vpc_security_group_ids      = [aws_security_group.tribalchief_private_instance_sg.id]
  associate_public_ip_address = false


  tags = {
    Name = "tribalchief_jump_host_private_instance"
  }
}
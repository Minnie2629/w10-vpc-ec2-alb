resource "aws_instance" "elb-server" {
  ami               = "ami-03972092c42e8c0ca"
  instance_type     = "t2.micro"
  availability_zone = "us-east-1a"
  subnet_id         = aws_subnet.priv1.id
  #security_groups = aws_security_group.elb-sg1.id
  vpc_security_group_ids = [aws_security_group.elb-sg1.id]
  #key_name      = aws_key_pair.aws_key.key_name
  user_data = file("setup.sh")

}

resource "aws_instance" "elb-server1" {
  ami               = "ami-03972092c42e8c0ca"
  instance_type     = "t2.micro"
  availability_zone = "us-east-1b"
  subnet_id         = aws_subnet.priv2.id
  #security_groups = aws_security_group.elb-sg1.id
  vpc_security_group_ids = [aws_security_group.elb-sg1.id]
  #key_name      = aws_key_pair.aws_key.key_name
  user_data = file("setup.sh")

}
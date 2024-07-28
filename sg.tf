resource "aws_security_group" "elb-sg" {
  name        = "elb-sg"
  description = "Allow  http"
  vpc_id      = aws_vpc.elb-vpc.id

  ingress {
    description = "allow http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    env = "Dev"
  }
  depends_on = [aws_vpc.elb-vpc]
}



resource "aws_security_group" "elb-sg1" {
  name        = "elb-sg1"
  description = "Allow  http"
  vpc_id      = aws_vpc.elb-vpc.id


  ingress {
    description     = "allow http"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.elb-sg.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    env = "Dev"
  }
  depends_on = [aws_vpc.elb-vpc, aws_security_group.elb-sg]
}
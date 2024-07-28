resource "aws_lb_target_group" "tg1" {
  name     = "elb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.elb-vpc.id

  health_check {
    enabled             = true
    healthy_threshold   = 3
    interval            = 100
    matcher             = 200
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 6
    unhealthy_threshold = 3
  }
}
resource "aws_lb_target_group_attachment" "at1" {
  target_group_arn = aws_lb_target_group.tg1.arn
  target_id        = aws_instance.elb-server.id
  port             = 80
}
resource "aws_lb_target_group_attachment" "at2" {
  target_group_arn = aws_lb_target_group.tg1.arn
  target_id        = aws_instance.elb-server1.id
  port             = 80
}
resource "aws_lb_listener" "lt1" {
  load_balancer_arn = aws_lb.lb1.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg1.arn
  }
}
resource "aws_lb" "lb1" {
  name                       = "alb-project"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.elb-sg1.id]
  subnets                    = [aws_subnet.pub1.id, aws_subnet.pub2.id]
  enable_deletion_protection = false
}

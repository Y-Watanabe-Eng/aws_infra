resource "aws_lb" "web_alb" {
  name = "web-alb"
  load_balancer_type = "application"
  security_groups = [ aws_security_group.alb_sg.id ]
  subnets = [ aws_subnet.public01.id, aws_subnet.public02.id ]
  tags = {
    Name = "tf-demo"
    env  = "dev"
  }
}
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.web_alb.arn
  port = "80"
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
  tags = {
    Name = "tf-demo"
    env  = "dev"
  }
}
resource "aws_lb_target_group" "web_tg" {
  name = "web-tg"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.main.id

  health_check {
    path = "/"
    protocol = "HTTP"
    matcher = "200"
    interval = 30
    timeout = 5
    healthy_threshold = 2
    unhealthy_threshold = 2
  }
  tags = {
    Name = "tf-demo"
    env  = "dev"
  }
}
resource "aws_lb_target_group_attachment" "web_tg_attachment" {
  target_group_arn = aws_lb_target_group.web_tg.arn
  target_id = aws_instance.multi.id
  port = 80  
}
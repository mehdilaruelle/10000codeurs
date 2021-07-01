resource "aws_security_group" "elb" {
  name        = "${var.project_name}-elb"
  description = "Allow HTTP communication on port 80."
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = var.front_elb_port
    to_port     = var.front_elb_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_elb" "front" {
  name    = var.project_name
  subnets = aws_subnet.public.*.id

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = var.front_elb_port
    lb_protocol       = var.front_elb_protocol
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  security_groups           = [aws_security_group.elb.id]
  cross_zone_load_balancing = true
  connection_draining       = true

  tags = {
    Name = var.project_name
  }
}

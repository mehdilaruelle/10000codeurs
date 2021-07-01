data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]


  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

resource "aws_security_group" "back" {
  name        = "${var.project_name}-back"
  description = "Allow HTTP communication."
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.elb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "template_file" "init" {
  template = <<EOT
    #! /bin/bash
    yum update
    amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
    yum install -y httpd mariadb-server
    systemctl start httpd
    systemctl enable httpd
    echo "<h1>Deployed via Terraform</h1>" >> /var/www/html/index.html
EOT
}

resource "aws_launch_template" "back" {
  image_id      = data.aws_ami.amazon-linux-2.id
  instance_type = var.back_instance_type

  vpc_security_group_ids = [aws_security_group.back.id]

  user_data = base64encode(data.template_file.init.rendered)

  tags = {
    Name = var.project_name
  }
}

resource "aws_autoscaling_group" "back" {
  name             = "back_instances"
  desired_capacity = var.back_instance_number
  max_size         = var.back_instance_number + 1
  min_size         = var.back_instance_number

  health_check_grace_period = 300
  health_check_type         = "ELB"
  vpc_zone_identifier       = aws_subnet.private.*.id

  load_balancers = [aws_elb.front.id]

  launch_template {
    id      = aws_launch_template.back.id
    version = "$Latest"
  }
}

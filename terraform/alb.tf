resource "aws_alb" "main" {
  name            = "${var.environment}-${var.service}-alb"
  subnets         = module.vpc.public_subnets
  security_groups = [aws_security_group.microblog_alb_sg.id]
}

resource "aws_alb_target_group" "microblog" {
  name        = "${var.environment}-${var.service}-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "/"
    unhealthy_threshold = "2"
  }
}

resource "aws_alb_listener" "http_listener_id" {
  load_balancer_arn = aws_alb.main.id
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.microblog.id
  }
}

resource "aws_security_group" "microblog_alb_sg" {
  name        = "${var.environment}-${var.service}-alb-sg"
  description = "SG for ${var.environment}-${var.service}-alb"
  vpc_id      = module.vpc.vpc_id
  tags        = local.tags
}

resource "aws_security_group_rule" "microblog_alb_allow_http" {
  type              = "ingress"
  description       = "Allow traffic from HTTP"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.microblog_alb_sg.id
}

resource "aws_security_group_rule" "microblog_alb_outbound_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.microblog_alb_sg.id
}

#############
#Security group rules to allow inbound connections
#adds rules to ALB Security Group
#############
resource "aws_security_group_rule" "allow_http" {
  count       = "${var.use_http}"
  type        = "ingress"
  from_port   = "${var.http_port}"
  to_port     = 0
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${var.security_group_id}"
}

resource "aws_security_group_rule" "allow_https" {
  count       = "${var.use_https}"
  type        = "ingress"
  from_port   = "${var.https_port}"
  to_port     = 0
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${var.security_group_id}"
}

resource "aws_security_group_rule" "allow_outbound" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${var.security_group_id}"
}

######
#Creates the target group to put your listeners in
#####
resource "aws_lb_target_group" "alb_target_group" {
  name                 = "${var.service_name}"
  port                 = "${var.target_port}"
  protocol             = "HTTP"
  vpc_id               = "${var.vpc_id}"
  deregistration_delay = "${var.connection_draining_delay}"

  health_check {
    interval            = "${var.health_check_interval}"
    path                = "${var.health_check_path}"
    port                = "${var.health_check_port}"
    protocol            = "${var.health_check_protocol}"
    timeout             = "${var.health_check_timeout}"
    healthy_threshold   = "${var.health_check_healthy_threshold}"
    unhealthy_threshold = "${var.health_check_unhealthy_threshold}"
    matcher             = "${var.health_check_matcher}"
  }

  stickiness {
    type            = "lb_cookie"
    cookie_duration = "${var.cookie_duration}"
    enabled         = "${var.stickiness_enabled}"
  }
}

#SSL Listener
resource "aws_lb_listener" "front_end_https" {
  count             = "${var.use_https}"
  load_balancer_arn = "${var.alb_arn}"
  port              = "${var.https_port}"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "${var.ssl_certificate_id}"

  default_action {
    target_group_arn = "${aws_alb_target_group.alb_target_group.arn}"
    type             = "forward"
  }
}

resource "aws_lb_listener_rule" "https_path_rule" {
  count        = "${var.https_path_rule_enabled}"
  listener_arn = "${aws_lb_listener.front_end_https.arn}"
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.alb_target_group.arn}"
  }

  condition {
    field  = "path-pattern"
    values = "${var.path_list}"
  }
}

resource "aws_lb_listener_rule" "https_host_rule" {
  count        = "${var.https_host_rule_enabled}"
  listener_arn = "${aws_lb_listener.front_end_https.arn}"
  priority     = 99

  action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.alb_target_group.arn}"
  }

  condition {
    field  = "host-header"
    values = "${var.host_list}"
  }
}

#Plain text listener
resource "aws_lb_listener" "front_end_http" {
  count             = "${var.use_http}"
  load_balancer_arn = "${var.alb_arn}"
  port              = "${var.http_port}"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.alb_target_group.arn}"
    type             = "forward"
  }
}

resource "aws_lb_listener_rule" "http_path_rule" {
  count        = "${var.http_path_rule_enabled}"
  listener_arn = "${aws_lb_listener.front_end_http.arn}"
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.alb_target_group.arn}"
  }

  condition {
    field  = "path-pattern"
    values = "${var.path_list}"
  }
}

resource "aws_lb_listener_rule" "http_host_rule" {
  count        = "${var.http_host_rule_enabled}"
  listener_arn = "${aws_lb_listener.front_end_http.arn}"
  priority     = 99

  action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.alb_target_group.arn}"
  }

  condition {
    field  = "host-header"
    values = "${var.host_list}"
  }
}

output "https_arn" {
  value = "${aws_lb_listener.front_end_https.arn}"
}

output "http_arn" {
  value = "${aws_lb_listener.front_end_http.arn}"
}

output "target_group_arn" {
  value = "${aws_lb_target_group.alb_target_group.arn}"
}

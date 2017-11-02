output "https_arn" {
  value = "${aws_lb_listener.front_end_https.arn}"
}

output "http_arn" {
  value = "${aws_lb_listener.front_end_http.arn}"
}

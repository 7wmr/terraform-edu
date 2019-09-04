output "elb-dns" {
  value = "${aws_elb.web.dns_name}"
}

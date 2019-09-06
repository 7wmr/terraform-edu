output "generic-elb-dns" {
  value = "${aws_elb.web.dns_name}"
}

output "custom-elb-dns" {
  value = "${var.elb_record}.${var.elb_domain}"
}

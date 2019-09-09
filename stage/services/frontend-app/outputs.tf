output "custom-elb-dns" {
  value = "${var.elb_record}.${var.elb_domain}"
}

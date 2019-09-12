output "custom-elb-dns" {
  value = "${var.cluster_name}.${var.elb.domain}"
}

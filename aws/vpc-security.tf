
resource "aws_security_group_rule" "web_msg" {
  type                     = "ingress"

  from_port                = "${module.msg_rabbitmq.port_main}"
  to_port                  = "${module.msg_rabbitmq.port_main}"
  protocol                 = "tcp"

  source_security_group_id = "${module.svc_web.sec_group_id}"
  security_group_id        = "${module.msg_rabbitmq.sec_group_id}"
}

resource "aws_security_group_rule" "run_msg" {
  type                     = "ingress"

  from_port                = "${module.msg_rabbitmq.port_main}"
  to_port                  = "${module.msg_rabbitmq.port_main}"
  protocol                 = "tcp"

  source_security_group_id = "${module.svc_run.sec_group_id}"
  security_group_id        = "${module.msg_rabbitmq.sec_group_id}"
}

resource "aws_security_group_rule" "run_dbs" {
  type                     = "ingress"

  from_port                = "${var.mysql.port}"
  to_port                  = "${var.mysql.port}"
  protocol                 = "tcp"

  source_security_group_id = "${module.svc_run.sec_group_id}"
  security_group_id        = "${module.dbs_mysql.sec_group_id}"
}

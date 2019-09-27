Terraform Edu
======================

.. image:: https://circleci.com/gh/7wmr/terraform-edu.svg?style=shield&circle-token=5b8b29645d15daaf22709a0ee2fceefd913f82f1
    :target: https://circleci.com/gh/7wmr/terraform-edu


See documentation at: http://terraform-edu.7wmr.uk

Deployment
-----------------------

Download latest modules and plugins.

.. code:: bash

   terraform init -upgrade


Check that the configuration will apply the expected changes.

.. code:: bash

   terraform plan


Apply the new configuration.

.. code:: bash

  terraform apply -var-file=vars/$(terraform workspace show).tfvars


Add to the start of any ``user-data.sh`` template script file to ensure that output is forwarded to console log.

.. code:: bash

  #!/bin/bash -xe
  exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1


View system log output for an instance.

.. code:: bash

  echo $(aws ec2 get-console-output --instance-id "${INSTANCE_ID}" | jq ".Output")

To get a system log screenshot for an instance.

.. code:: bash

  echo $(aws ec2 get-console-screenshot --instance-id "${INSTANCE_ID}" | jq ".Output")


Termination
-----------------------

To destroy the cluster when finished.

.. code:: bash

   terraform destroy -auto-approve -force

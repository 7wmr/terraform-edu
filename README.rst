Terraform Edu
======================

.. image:: https://circleci.com/gh/7wmr/terraform-edu.svg?style=shield&circle-token=5b8b29645d15daaf22709a0ee2fceefd913f82f1
    :target: https://circleci.com/gh/7wmr/terraform-edu


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



Certificates
-----------------------

https://medium.com/@francisyzy/create-aws-elb-with-self-signed-ssl-cert-cd1c352331f

.. code:: bash
   
   DOMAIN_NAME='web-dev.8lr.co.uk'
   openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout "${DOMAIN_NAME}.key" -out "${DOMAIN_NAME}.crt"
   openssl rsa -in "${DOMAIN_NAME}.key" -text > "${DOMAIN_NAME}.pem"
   openssl x509 -inform PEM -in "${DOMAIN_NAME}.crt" > "${DOMAIN_NAME}.pem"




Termination
-----------------------

To destroy the cluster when finished.

.. code:: bash

   terraform destroy -auto-approve -force

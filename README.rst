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

   terraform apply


View user-data output for an instance.

.. code:: bash

   aws ec2 describe-instance-attribute --instance-id "${INSTANCE_ID}" \
     --attribute userData --output text --query "UserData.Value" \
     | base64 --decode


Termination
-----------------------

To destroy the cluster when finished.

.. code:: bash

   terraform destroy -auto-approve -force

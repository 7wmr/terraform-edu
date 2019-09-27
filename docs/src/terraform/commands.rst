Commands
==============================

Deployment
-----------------------

Download the latest modules and plugins.

.. code:: bash

   terraform init -upgrade

Check that the configuration will apply the expected changes.

.. code:: bash

   terraform plan

Apply the new configuration.

.. code:: bash

   terraform apply -var-file=vars/${terraform workspace show}.tfvars


Termination
-----------------------

To destroy the cluster when finished.

.. code:: bash

   terraform destroy -auto-approve -force

   
Alias
-----------------------

Use the following alias command to all the use of the ``tf`` command shortname rather than ``terraform`` command.

.. code:: bash

   alias tf='terraform'

.. code:: bash

   tf init -upgrade     

Commands
==============================

Deployment
-----------------------

Download the latest modules and plugins.

.. code-block:: bash

   terraform init -upgrade

Check that the configuration will apply the expected changes.

.. code-block:: bash

   terraform plan

Apply the new configuration.

.. code-block:: bash

   terraform apply -var-file=vars/${terraform workspace show}.tfvars


Termination
-----------------------

To destroy the cluster when finished.

.. code-block:: bash

   terraform destroy -auto-approve -force

   
Alias
-----------------------

Use the following alias command to all the use of the ``tf`` command shortname rather than ``terraform`` command.

.. code-block:: bash

   alias tf='terraform'

For example:
   
.. code-block:: bash

   tf init -upgrade     

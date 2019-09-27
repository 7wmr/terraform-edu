Instance
==============================


Add to the start of any ``user-data.sh`` template script file to ensure that output is forwarded to console log.

.. code-block:: bash

   #!/bin/bash -xe
   exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

View system log output for an instance.

.. code-block:: bash

   echo $(aws ec2 get-console-output --instance-id "${INSTANCE_ID}" | jq ".Output")

Get a system log screenshot for an instance.

.. code-block:: bash

   echo $(aws ec2 get-console-screenshot --instance-id "${INSTANCE_ID}" | jq ".Output")

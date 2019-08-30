Terraform Edu
======================


.. code:: bash

   terraform remote config \
       -backend=s3 \
       -backend-config="bucket=terraform-edu" \
       -backend-config="key=global/s3/terraform.tfstate" \
       -backend-config="region=eu-west-2" \
       -backend-config="encrypt=true"

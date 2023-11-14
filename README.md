# SERVICE POLICY

Terraform to create F5XC Service Policy

## Usage

- Clone this repo with `git clone --recurse-submodules https://github.com/cklewar/f5-xc-service-policy`
- Enter repository directory with `cd f5-xc-service-policy`
- Obtain F5XC API certificate file from Console and save it to `cert` directory
- Pick and choose from below examples and add mandatory input data and copy data into file `main.tf.example`.
- Rename file __main.tf.example__ to __main.tf__ with `rename main.tf.example main.tf`
- Change backend settings in `versions.tf` file to fit your environment needs. This example uses Terraform cloud backend
- Initialize with `terraform init`
- Apply with `terraform apply -auto-approve` or destroy with `terraform destroy -auto-approve`

## Service Policy module usage example
  
````hcl
````
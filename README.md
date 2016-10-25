# Description
If one provider uses the data from another provider, then it is possible to be able to `plan` and `apply` a terraform
plan, but not able to `destroy` it.

This example contains two `consul` providers where one is configured using data from `consul_keys` of the other provider.

# Steps to reproduce
1. Start up Consul in docker
    * `docker-compose up`
1. Seed Consul with relevant values
    * `./consul-setup.sh` or `./consul-setup.sh $(docker-machine ip)` if running on OSX
1. Apply the terraform file, making sure to pass in the address of the Consul running docker   
    * `terraform apply -var='consul_address=localhost:8500'` or `terraform apply -var="consul_address=$(docker-machine ip):8500"` if running on OSX
1. Make sure that the lines below `# Uncomment the lines below to make it fail` are uncommented
and the lines below `# Uncomment the lines below to make it work` are commented in `sample.tf`
1. Run destroy on the terraform state
    * `terraform destroy -var='consul_address=localhost:8500'` or `terraform destroy -var="consul_address=$(docker-machine ip):8500"` if running on OSX
    
# Expected outcome
Terraform destroys the files created successfully

# Actual outcome
```
$  terraform destroy -var 'consul_address=192.168.99.100:8500'
Do you really want to destroy?
  Terraform will delete all your managed infrastructure.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes

data.consul_keys.consul: Refreshing state...
archive_file.archive: Refreshing state... (ID: e402621bc1a0388f5626bf76b16c4ce3eeca5baf)
consul_keys.second: Refreshing state... (ID: consul)
Error creating plan: 1 error(s) occurred:

* Cycle: provider.consul.ctwo, consul_keys.second (destroy), archive_file.archive (destroy), data.consul_keys.consul (destroy), data.consul_keys.consul
```

# Notes
It is possible to run destroy if the lines below `# Uncomment the lines below to make it fail` are commented and
the lines below `# Uncomment the lines below to make it work` are uncommented  in `sample.tf`.

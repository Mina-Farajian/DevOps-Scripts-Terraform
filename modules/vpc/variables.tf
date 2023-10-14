variable "config" {
  type = object({
    # Custom variable to specify the environment.
    environment = string
    # Custom variable to specify application context.
    context = string
    # VPC properties
    vpc_cidr            = string
    public_subnet_cidr  = list(string)
    private_subnet_cidr = list(string)
    availability_zones  = list(string)
    tags                = map(string)
  })
}

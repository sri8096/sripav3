variable "resourcegroup_details" {
    type = object({
          name=string
            location=string
            })
    default = {
      location = "eastus"
      name = "srii5"
    }
}
variable "vnet_details" {
    type = object({
        name=string
        address_space=list(string)
    })
     default = {
     name = "pavv3"
     address_space = [ "192.168.0.0/16" ]
     }
}
variable "subnet_details" {
    type = object({
        names=list(string)
    })
}
       default = {
     names =  [ "web", "app", "db" ]
}
variable "runningversion" {
    type = string
    default = "1.0"
}

 default = {
      location = "eastus"
      name = "srii5"
 }
  default = {
     name = "pavv3"
     address_space = [ "192.168.0.0/16" ]
     }
      default = {
     names =  [ "web", "app", "db" ]
}
variable "runningversion" {
    type = string
    default = "1.0"
}

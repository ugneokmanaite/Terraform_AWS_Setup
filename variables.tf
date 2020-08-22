variable "name" {
  #type = string
  default = "Eng67_Ugne_Terraform_EC2"
}

 variable "vpcCIDRblock" {
   #type = string
   default= "10.100.0.0/16"
 }

variable "subnet_public" {
	#type = string
	default = "10.100.11.0/24"
}

variable "subnet_private" {
  #type = string
  default = "10.100.16.0/24"
}




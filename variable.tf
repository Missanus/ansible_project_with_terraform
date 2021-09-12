variable "test_env"{
    description = "environement"
    type     = string
    default  = "ansible"
}

variable "list_subnet_private" {
    type = list(string)
    default = ["subnet-0e79ea121f7028f5b"]    #	vpc-bf63adc6
}

variable "avaibility_zone" {
    type = list(string)
    default = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]    #	vpc-bf63adc6
}
variable "region"  {default    =   "eu-west-1"}

variable "aws_region" {
  description = "aws region"
  type        = string
  default     = "eu-west-1"
}

variable "nb_instance_max"{
    type = number
    default = 1
}
variable "ami_type"{
    type = string
    default = "t2.micro"
}

variable "ssh_key_name"{
    type    = string
    default = "ansible_key"
}

variable "BillingBusinessApp" {
    type   = string
    default = "ansible"
}
variable "resource_name" {
    type    = string
    default = "ansible"
}

variable "resource_env" {
    type    = string
    default = "test" 
}

variable "repos_bucket" {
    type    = string
    default = "bucket-ansible-tools" 
}     

variable "repos_bucket_resultat" {
    type    = string
    default = "bucket-ansible-tools" 
}

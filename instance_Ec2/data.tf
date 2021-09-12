



# Template files:
data "template_file" "iam_ec2_role_policy"{
  template = file("iam/role_ec2.tpl")
}


data "template_file" "traitev_pre_bucket_policy_tpl" {
  template = file("iam/role_ec2.tpl")

}

data "aws_ami" "last_aws_ami" {  #https://linuxtut.com/en/18d9d582ea6c8960f274/
  owners = ["amazon"]
  most_recent = true
  filter {
    name = "name"
    values = [
      "amzn2-ami-hvm-*-x86_64-gp2"]
  }
}


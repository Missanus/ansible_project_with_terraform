

resource "aws_instance" "aws_instance_instance" {
  ami                    = data.aws_ami.last_aws_ami.id 
  instance_type          = var.ami_type
  key_name               = "ansible_key"
  monitoring             = true
  ebs_optimized          = false
  iam_instance_profile   = aws_iam_instance_profile.test_profile_ansible.name    
  user_data              = file("user-data.sh")
  subnet_id              = "subnet-0e79ea121f7028f5b"
  security_groups        = ["sg-074678455dd32e4de", "sg-0f4d35dc560e9ace4"]

  ebs_block_device {
    device_name = "/dev/xvda"
    volume_size = 15
    volume_type = "gp3"

  }

  tags = {
    Name  = "instance_ansible_latest"          
    traitev-id              = "ansible"
  }
  volume_tags ={
    BillingBusinessApp         = var.BillingBusinessApp
    Name  = "app-instance-ansible-vol"  
  }

}

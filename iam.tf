resource "aws_iam_role" "ec2_iam_role_instance_ansible" {
  name = "ec2-iam-instance-role-instance-ansible"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "ec2.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "test_profile_ansible" {
  name = "instance-profile-instance-ansible"
  role = aws_iam_role.ec2_iam_role_instance_ansible.name
}

resource "aws_iam_role_policy_attachment" "policy-attachment-ssm-ecs-instance" {
  role       = aws_iam_role.ec2_iam_role_instance_ansible.name
  policy_arn =  "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"           
}

resource "aws_iam_role_policy" "ec2_role-policy" {
  name   = "ec2policy_instance_ansible"
  role   = aws_iam_role.ec2_iam_role_instance_ansible.id
  policy = data.template_file.iam_ec2_role_policy.rendered
}

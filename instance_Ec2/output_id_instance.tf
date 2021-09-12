
# recover the id instances
output "all_id_instances" {
  value = aws_instance.aws_instance_instance.*.id
}
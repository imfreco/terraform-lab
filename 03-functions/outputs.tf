output "instance_ip_address" {
  value = { for instance, info in aws_instance.demo_instance : instance => info.private_ip }
}
output "instance_private_ip" {
  value = [for instance in aws_instance.gemini_instance : instance.private_ip]
  description = "The private IP address of the main server instance."
}

output "instance_public_ip" {
  value = [for instance in aws_instance.gemini_instance : instance.public_ip]
  description = "The public IP address of the main server instance."
}
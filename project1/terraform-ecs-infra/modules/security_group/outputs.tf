output "backend_alb_sg" {
  description = "Name/ID of Internal ALB Security group"
  value       = aws_security_group.backend_alb_sg.id
}

output "efs_sg" {
  description = "Name/ID of NFS access Security group"
  value       = aws_security_group.EFS_sg.id
}
output "remote_sg" {
  description = "Name/ID of RemoteAccess Security group"
  value       = aws_security_group.Remote_sg.id
}
output "nginx_sg" {
  description = "Name/ID of Nginx http Security group"
  value       = aws_security_group.backend_nginx_sg.id
}
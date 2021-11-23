output "db_instance" {
  value = aws_instance.nextcloud_db
}

output "db_endpoint" {
  value = aws_instance.nextcloud_db.private_ip
}
output "vpc_id" {
  value = aws_vpc.nextcloud_vpc.id
}

output "private_eni_nextcloud_db_nat" {
  value = aws_network_interface.private_eni_nextcloud_db_nat
}

output "private_eni_nextcloud_app" {
	value = aws_network_interface.private_eni_nextcloud_app
}

output "public_eni_nextcloud_app" {
  value = aws_network_interface.public_eni_nextcloud_app
}

output "private_eni_db_app" {
  value = aws_network_interface.private_eni_db_app
}

output "private_subnet_db" {
  value = aws_subnet.nextcloud_private_sn_db
}
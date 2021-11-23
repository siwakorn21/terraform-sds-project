resource "aws_network_interface" "private_eni_nextcloud_db_nat" {
  subnet_id       = aws_subnet.nextcloud_private_sn_db.id
  security_groups = [aws_security_group.nextcloud_db_nat_sg.id]
  # private_ips = ["10.0.4.2"]

  tags = {
	"Name" = "private eni nextcloud db nat"
  }
}

resource "aws_network_interface" "private_eni_nextcloud_app" {
  subnet_id = aws_subnet.nextcloud_private_sn_app.id
  security_groups = [aws_security_group.nextcloud_private_db_app_sg.id]
  private_ips = ["10.0.2.6"]
  tags = {
	"Name" = "private eni nextcloud app"
  }
}

resource "aws_network_interface" "private_eni_db_app" {
  subnet_id = aws_subnet.nextcloud_private_sn_app.id
  private_ips = ["10.0.2.7"]
  security_groups = [aws_security_group.nextcloud_private_db_app_sg.id]
  tags = {
	"Name" = "private eni database to nextcloud app"
  }
}

resource "aws_network_interface" "public_eni_nextcloud_app" {
  subnet_id = aws_subnet.nextcloud_public_sn_app.id
  private_ips = ["10.0.1.5"]
  security_groups = [aws_security_group.nextcloud_public_app_sg.id]
  tags = {
	"Name" = "publuc eni nextcloud app"
  }
}
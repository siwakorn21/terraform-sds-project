resource "aws_eip" "nat_eip" {
  vpc = true

  tags = {
	"Name" = "NAT eip"
  }
}

resource "aws_eip" "public_eip_nextcloud_app" {
	vpc = true
	network_interface = aws_network_interface.public_eni_nextcloud_app.id
	associate_with_private_ip = "10.0.1.5"
	depends_on = [
	  aws_network_interface.public_eni_nextcloud_app,
	  aws_internet_gateway.gw
	]

	tags = {
	  "Name" = "public_eip_nextcloud_app"
	}
}

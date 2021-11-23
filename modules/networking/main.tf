resource "aws_vpc" "nextcloud_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
	  Name = "next_cloud_vpc"
  }

  lifecycle {
	  create_before_destroy = true
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.nextcloud_vpc.id

  tags = {
	"Name" = "nextcloud_gateway"
  }
}

# NAT
resource "aws_nat_gateway" "nextcloud_db_nat" {
  allocation_id = aws_eip.nat_eip.id
#   subnet_id     = aws_subnet.nextcloud_private_sn_db.id
	subnet_id = aws_subnet.nextcloud_public_sn_app.id

  tags = {
    Name = "Nextcloud DB NAT"
  }
  depends_on = [aws_internet_gateway.gw]
}

resource "aws_route_table" "nextcloud_db_route_table" {
	depends_on = [
	  aws_nat_gateway.nextcloud_db_nat
	]
	vpc_id = aws_vpc.nextcloud_vpc.id

	route {
		cidr_block = "0.0.0.0/0"
		nat_gateway_id = aws_nat_gateway.nextcloud_db_nat.id
	}

	tags = {
	  "Name" = "nextcloud_db_route_table"
	}
}

resource "aws_route_table_association" "nextcloud_db_rt_assoc" {
  subnet_id = aws_subnet.nextcloud_private_sn_db.id
  route_table_id = aws_route_table.nextcloud_db_route_table.id
}

resource "aws_route_table" "nextcloud_app_public_rt" {
	vpc_id = aws_vpc.nextcloud_vpc.id

	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = aws_internet_gateway.gw.id
	}

	tags = {
		"Name" = "nextcloud_public_app_rt"
	}
}

resource "aws_route_table_association" "nextcloud_app_public_rt_assoc" {
  subnet_id = aws_subnet.nextcloud_public_sn_app.id
  route_table_id = aws_route_table.nextcloud_app_public_rt.id
}

resource "aws_subnet" "nextcloud_private_sn_app" {
  vpc_id = aws_vpc.nextcloud_vpc.id
  cidr_block = var.private_cidrs_app
  availability_zone = var.availability_zone

  tags = {
    Name = "Nextcloud app private subnet"
  }
}

resource "aws_subnet" "nextcloud_private_sn_db" {
	vpc_id = aws_vpc.nextcloud_vpc.id
	cidr_block = var.private_cidrs_db
	availability_zone = var.availability_zone

	tags = {
	  "Name" = "Nextcloud db private subnet"
	}
}

resource "aws_subnet" "nextcloud_public_sn_app" {
	vpc_id = aws_vpc.nextcloud_vpc.id
	cidr_block = var.public_cidrs_app
	availability_zone = var.availability_zone

	tags = {
	  "Name" = "Nextcloud app public subnet"
	}
}

resource "aws_subnet" "nat_public_sn" {
  vpc_id = aws_vpc.nextcloud_vpc.id
  cidr_block = "10.0.5.0/24"
  availability_zone = var.availability_zone

  tags = {
	  "Name" = "Nat gatway subnet public"
  }
}
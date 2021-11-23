resource "aws_security_group" "nextcloud_public_app_sg" {
    name = "nextcloud_public_app_sg"

	ingress {
		from_port = "3306"
		to_port = "3306"
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

    ingress {
        from_port="80"
        to_port="80"
        protocol="tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port="22"
        to_port="22"
        protocol="tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        cidr_blocks     = ["0.0.0.0/0"]
    }

    vpc_id = aws_vpc.nextcloud_vpc.id

    lifecycle {
        create_before_destroy = true
    }

	tags = {
	  "Name" = "Nextcloud public app sg"
	}
}

resource "aws_security_group" "nextcloud_private_db_app_sg" {
    name = "nextcloud_private_db_app_sg"

    ingress {
        from_port="3306"
        to_port="3306"
        protocol="tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port="22"
        to_port="22"
        protocol="tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        cidr_blocks     = ["0.0.0.0/0"]
    }

    vpc_id = aws_vpc.nextcloud_vpc.id

    lifecycle {
        create_before_destroy = true
    }

	tags = {
	  "Name" = "Nextcloud private db app sg"
	}
}

resource "aws_security_group" "nextcloud_db_nat_sg" {
    ingress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        cidr_blocks     = ["0.0.0.0/0"]
    }
    egress {
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        cidr_blocks     = ["0.0.0.0/0"]
    }

    vpc_id = aws_vpc.nextcloud_vpc.id

    lifecycle {
        create_before_destroy = true
    }

	tags = {
	  "Name" = "Nextcloud db nat sg"
	}
}
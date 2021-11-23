resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "dev-key"
  public_key = tls_private_key.example.public_key_openssh

  provisioner "local-exec" { # Create "myKey.pem" to your computer!!
    command = "echo '${tls_private_key.example.private_key_pem}' > ./myKey.pem"
  }
}

resource "aws_instance" "nextcloud_db" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name = aws_key_pair.generated_key.key_name

  tags = {
    Name = "nextcloud-db"
  }

  network_interface {
    network_interface_id = var.private_eni_db_app.id
    device_index = 1
  }

  network_interface {
    network_interface_id = var.private_eni_nextcloud_db_nat.id
    device_index = 0
  }

  user_data = "${data.template_cloudinit_config.mariadb_init.rendered}"
}

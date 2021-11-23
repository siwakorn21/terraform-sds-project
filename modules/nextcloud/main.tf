# resource "tls_private_key" "gen_private" {
#   algorithm = "RSA"
#   rsa_bits  = 4096
# }

# resource "aws_key_pair" "generated_key_app" {
#   key_name   = "dev-key"
#   public_key = tls_private_key.gen_private.public_key_openssh

#   provisioner "local-exec" { # Create "myKey.pem" to your computer!!
#     command = "echo '${tls_private_key.gen_private.private_key_pem}' > ./app.pem"
#   }
# }

resource "aws_instance" "nextcloud_app" {
  ami           = var.ami
  instance_type = var.instance_type
  # key_name = aws_key_pair.generated_key_app.key_name

  tags = {
    Name = "nextcloud-app"
  }

  network_interface {
    network_interface_id = var.public_eni_nextcloud_app.id
    device_index = 0
  }

  network_interface {
    network_interface_id = var.private_eni_nextcloud_app.id
    device_index = 1
  }

  user_data = "${data.template_cloudinit_config.cloudinit-nextcloud.rendered}"
}

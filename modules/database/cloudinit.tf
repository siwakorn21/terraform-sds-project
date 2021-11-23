data "template_cloudinit_config" "mariadb_init" {
  gzip          = false
  base64_encode = false

  part {
	  content_type = "text/x-shellscript"
	  content = templatefile("${path.module}/scripts/mariadb_install.sh", {
      db_pass = var.db_pass
      db_user = var.db_user
      db_name = var.db_name
    })
  }
}
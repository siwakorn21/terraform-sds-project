module "iam" {
  source = "./modules/iam"
}

module "networking" {
  source = "./modules/networking"
  vpc_cidr = local.vpc_cidr
  public_cidrs_app = local.public_cidrs_app
  private_cidrs_app = local.private_cidrs_app
  private_cidrs_db = local.private_cidrs_db
  availability_zone = var.availability_zone
}

module "database" {
  depends_on = [
    module.networking
  ]
  source = "./modules/database"
  instance_type = "t3.medium"
  ami = var.ami
  vpc_id = module.networking.vpc_id
  private_cidrs_app = local.private_cidrs_app
  private_eni_nextcloud_db_nat = module.networking.private_eni_nextcloud_db_nat
  private_eni_db_app = module.networking.private_eni_db_app
  db_pass = var.database_pass
  db_name = var.database_name
  db_user = var.database_user
}

module "s3" {
  source = "./modules/s3"
  s3_bucket_name = var.bucket_name
  nextcloud_iam_user_arn = module.iam.nextcloud_iam_user_arn
  terraform_iam_user_arn = module.iam.terraform_iam_user_arn

  force_destroy = true
}

module "nextcloud" {
  depends_on = [
    module.database,
    module.s3
  ]
  source = "./modules/nextcloud"
  instance_type = "t3.medium"
  ami = var.ami
  private_eni_nextcloud_app = module.networking.private_eni_nextcloud_app
  public_eni_nextcloud_app = module.networking.public_eni_nextcloud_app
  vpc_id = module.networking.vpc_id

  # S3 CONFIG
  aws_region = var.region
  s3_bucket_name = var.bucket_name
  s3_access_key = module.iam.nextcloud_iam_user_access_key
  s3_secret_key = module.iam.nextcloud_iam_user_secret_key

  db_name = var.database_name
  db_user = var.database_user
  db_pass = var.database_pass
  db_endpoint = module.database.db_endpoint
  admin_user = var.admin_user
  admin_pass = var.admin_pass
  data_dir = "/var/www/nextcloud/data"
}




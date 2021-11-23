variable "vpc_cidr" {
	type = string
}

variable "public_cidrs_app" {
	type = string
}

variable "private_cidrs_app" {
	type = string
}

variable "private_cidrs_db" {
	type = string
}

variable "availability_zone" {
  type = string
}
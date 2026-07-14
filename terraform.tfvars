region = "ap-south-1"
vpc_cidr="10.10.0.0/16"
name_prefix="ecommerce-application"
public_subnet_cidrs=["10.10.0.0/24", "10.10.1.0/24"]
private_ecs_cidrs = ["10.10.10.0/24", "10.10.11.0/24"]
private_db_cidrs = ["10.10.20.0/24", "10.10.21.0/24"]
az_zones=["ap-south-1a" , "ap-south-1b"]
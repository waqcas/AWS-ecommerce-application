resource "aws_vpc" "my-vpc" {
    cidr_block = "10.10.0.0/24"
    enable_dns_support   = true
    enable_dns_hostnames = true

    tags = {
        Name: "ecommerce-vpc"
    }

}

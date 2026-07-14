variable vpc_cidr {
    type = string
}

variable name_prefix {
    type = string
}

variable region {
    type = string
}

variable public_subnet_cidrs {
    type = list(string)
}

variable az_zones {
    type = list(string)
}

variable private_ecs_cidrs {
    type = list(string)
}

variable private_db_cidrs {
    type = list(string)
}

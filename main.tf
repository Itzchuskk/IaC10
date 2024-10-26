#####################################################
#
# Programador: Emiliano Moreno Hernandez 
#
# Fecha de Creación: 25-Oct-2024
# Fecha de Modificación: 25-Oct-2024 
#
#####################################################


# Porveedor 
provider "aws" {

    access_key = var.aws_key
    secret_key = var.aws_secret
    region = var.region_aws
}

#Crear VPC
resource "aws_vpc" "VPC10" {
    cidr_block = "10.0.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = {
        name = "VPC--actividad10"
    } 
}

#Crear SubNet01
resource "aws_subnet" "SubNet01" {
    vpc_id = aws_vpc.VPC10.id
    cidr_block = "10.0.0.0/20"
    availability_zone = "us-east-2a"
    tags = {
        name = "Subnet_01"
    }
  
}

#Crear SubNet02
resource "aws_subnet" "SubNet02" {
    vpc_id = aws_vpc.VPC10.id
    cidr_block = "10.0.16.0/20"
    availability_zone = "us-east-2b"
    tags = {
        name = "Subnet_02"
    }
  
}

#SubNetPriv01
resource "aws_subnet" "SubNetPriv01" {
    vpc_id = aws_vpc.VPC10.id
    cidr_block = "10.0.128.0/20"
    availability_zone = "us-east-2a"
    tags = {
        name = "SubnetPriv_01"
    }
  
}

#SubNetPriv02
resource "aws_subnet" "SubNetPriv02" {
    vpc_id = aws_vpc.VPC10.id
    cidr_block = "10.0.144.0/24"
    availability_zone = "us-east-2b"
    tags = {
        name = "SubnetPriv_02"
    }
  
}

#Internet Gate Way
resource "aws_internet_gateway" "InternetGateWay" {
    vpc_id = aws_vpc.VPC10.id
    tags = {
        name = "InternetGateWayPrincipal"
    }
  
}

#Crear tabla de ruteo
resource "aws_route_table" "TablaRuteo" {
    vpc_id = aws_vpc.VPC10.id 
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.InternetGateWay.id
    }
  tags = {
    name = "Tabla de Ruteo Predeterminada"
  }
}

#Asociamos Tabla de Ruteo a la SubNet01a

resource "aws_route_table_association" "AsociacionTRSN01a" {
    subnet_id = aws_subnet.SubNet01.id
    route_table_id = aws_route_table.TablaRuteo.id  
}

#Asociamos Tabla de Ruteo a la SubNet02

resource "aws_route_table_association" "AsociacionTRSN02b" {
    subnet_id = aws_subnet.SubNet02.id
    route_table_id = aws_route_table.TablaRuteo.id  
}

#Asociamos Tabla de Ruteo a la SubNetPriv01

resource "aws_route_table_association" "AsociacionTRSNP01a" {
    subnet_id = aws_subnet.SubNetPriv01.id
    route_table_id = aws_route_table.TablaRuteo.id  
}

#Asociamos Tabla de Ruteo a la SubNetPriv02

resource "aws_route_table_association" "AsociacionTRSNP02b" {
    subnet_id = aws_subnet.SubNetPriv02.id
    route_table_id = aws_route_table.TablaRuteo.id  
}

#Grupos de Seguridad 
resource "aws_security_group" "SG-VPC10" {
    vpc_id = aws_vpc.VPC10.id
    #SSH
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]

    }
    #HTTP
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]

    }
    #RDP
    ingress {
        from_port = 3389
        to_port = 3389
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]

    }
    #SALIDA
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
      name = "Permitir_SSH_HTTP_RDP"
    }
  
}

#Par de llaves 
resource "aws_key_pair" "AWSkeys" {
    key_name = "AWSkeys"
    public_key = file("/Users/itzhuskk__/.ssh/id_rsa.pub")
  
}

#Instancia Ubuntu
resource "aws_instance" "InstanciaUbuntu" {
#Ubuntu 20.04 AMI
ami          = "ami-0ea3c35c5c3284d82"
instance_type = "t2.micro"
subnet_id = aws_subnet.SubNet01.id
security_groups = [aws_security_group.SG-VPC10.id]
key_name = aws_key_pair.AWSkeys.key_name
associate_public_ip_address = true
tags = {
  name = "InstanciaUbuntu"
}
}

#Instancia Windows Server
resource "aws_instance" "InstanciaWindows" {
#Ubuntu 20.04 AMI
ami          = "ami-0c808db6baea2d0ed"
instance_type = "t2.micro"
subnet_id = aws_subnet.SubNet02.id
security_groups = [aws_security_group.SG-VPC10.id]
key_name = aws_key_pair.AWSkeys.key_name
associate_public_ip_address = true
tags = {
  name = "InstanciaWindows"
}
}

#Output para la IP Publica de la instancia Ubuntu 
output "IPPublicaUbuntu" {
    value = aws_instance.InstanciaUbuntu.public_ip
    description = "la direccion IP publica de la instancia de Ubuntu"
}

#Output para la IP Privada de la instancia Ubuntu 
output "IPPrivadaUbuntu" {
    value = aws_instance.InstanciaUbuntu.private_ip
    description = "la direccion IP privada de la instancia de Ubuntu"
}


#Output para la IP Publica de la instancia Ubuntu 
output "IPPublicaWindows" {
    value = aws_instance.InstanciaWindows.public_ip
    description = "la direccion IP publica de la instancia de Windows"
}

#Output para la IP Privada de la instancia Ubuntu 
output "IPPrivadaWindows" {
    value = aws_instance.InstanciaWindows.private_ip
    description = "la direccion IP privada de la instancia de Windows"
}

#Output para la ID de la instancia Ubuntu 
output "IDUbuntu" {
    value = aws_instance.InstanciaUbuntu.id
    description = "ID de la instancia de Ubuntu"
}

#Output para la ID de la instancia Ubuntu 
output "IDWindows" {
    value = aws_instance.InstanciaWindows.id
    description = "ID de la instancia de Windows"
}


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
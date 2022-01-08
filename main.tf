module "function" {
    source = "./modules/create-order-function"
}

resource "null_resource" "example" {}

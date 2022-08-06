terraform {
    backend "s3" {
        bucket = "talent-academy-ashwini-lab-tfstates"
        key = "talent-academy/ami_blue_green/terraform.tfstates"
        region = "eu-west-1"
        dynamodb_table = "terraform-lock"

    } 
 }
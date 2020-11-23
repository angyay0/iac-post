terraform {
    required_version = ">= 0.11"
    backend "aws" {
        features {}
    }
}
###############################
## AWS IaC Components      ##
###############################
provider "aws" {
    region = "__awsregion__"
}
###############################
##   AWS IaC Components      ##
###############################
resource "aws_elastic_beanstalk_application" "mc-aws-app" {
    name = "__sitename__"
    description = "Multicloud IaC Frontend"
}

resource "aws_elastic_beanstalk_environment" "mc-aws-env" {
    name = "__siteenvname__"
    application = aws_elastic_beanstalk_application.mc-aws-app.name
    solution_stack_name  = "64bit Amazon Linux 2 v5.2.3 running Node.js 12"

    setting {
        name = "API_ENDPOINT"
        value = "https://__backendname__.azurewebsites.net"
    }
}
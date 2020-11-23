terraform {
    required_version = ">= 0.11"
    backend "aws" {
        bucket = "__tfbucketaccount__"
        key    = "terraform.tfstate"
        region = "__awsregion__"
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
##   AWS App Components      ##
###############################
resource "aws_elastic_beanstalk_application" "mc-aws-app" {
    name = "__sitename__"
    description = "Multicloud IaC Frontend"
}

resource "aws_elastic_beanstalk_environment" "mc-aws-env" {
    name = "__siteenvname__"
    application = aws_elastic_beanstalk_application.mc-aws-app.name
    solution_stack_name  = "64bit Amazon Linux 2 v5.2.3 running Node.js 12"
    cname_prefix = "mc-examples-for-devops"

    setting {
        namespace = "aws:autoscaling:launchconfiguration"
        name = "InstanceType"
        value = "t2.nano"
    }

    setting {
        namespace = "aws:autoscaling:asg"
        name = "MinSize"
        value = "1"
    }
  
    setting {
        namespace = "aws:autoscaling:asg"
        name = "MaxSize"
        value = "2"
    }

    setting {
        namespace = "aws:autoscaling:launchconfiguration"
        name      = "IamInstanceProfile"
        value     = "aws-elasticbeanstalk-ec2-role"
    }

    setting {
        namespace = "aws:elasticbeanstalk:environment"
        name = "API_ENDPOINT"
        value = "https://__backendname__.azurewebsites.net"
    }
}
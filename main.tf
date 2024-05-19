terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.66.0"
    }
  }
}

provider "aws" {
  region = "eu-west-2"
}

resource "aws_mq_broker" "example" {
  broker_name       = "example-broker"
  engine_type       = "ActiveMQ"
  engine_version    = "5.15.16" # Or the latest supported version
  host_instance_type = "mq.t3.micro"

  user {
    username = "admin"
    password = "Password123!" # Use a secure password
  }

  publicly_accessible = true

  logs {
    general = true
  }

  configuration {
    id       = aws_mq_configuration.example.id
    revision = aws_mq_configuration.example.latest_revision
  }
}

resource "aws_mq_configuration" "example" {
  name           = "example-configuration"
  engine_type    = "ActiveMQ"
  engine_version = "5.15.16" # Or the latest supported version

  data = <<EOF
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<broker xmlns="http://activemq.apache.org/schema/core">
    <plugins>
        <authorizationPlugin>
            <map>
                <authorizationMap>
                    <authorizationEntries>
                        <authorizationEntry queue=">" write="admin" read="admin" admin="admin"/>
                    </authorizationEntries>
                </authorizationMap>
            </map>
        </authorizationPlugin>
    </plugins>
</broker>
EOF
}

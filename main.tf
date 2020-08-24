# This is to launch AWS-Setup


provider "aws" {

# which region do we have the AMI available in?

  region = "eu-west-1"
}

# create the VPC
resource "aws_vpc" "tf_vpc" {
	cidr_block = var.vpcCIDRblock

	tags = {
		Name = "Eng67_Ugne_VPC_TF"
	}
}
# Create IGW
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.tf_vpc.id
  tags = {
    
     Name = "Eng67_Ugne_GW_TF"
  }
}
 resource "aws_instance" "web" {
	 ami = "ami-0b56fdde9568aee06"
	 instance_type = "t2.micro"
	 subnet_id = aws_subnet.public.id
	 vpc_security_group_ids = [aws_security_group.app.id]
	 associate_public_ip_address = true
	 tags = {
		 Name = "Eng67_Ugne_tf_app"
	 }
 }
 resource "aws_instance" "db" {
	 ami                         = "ami-04b810f426022d206"
	 instance_type               = "t2.micro"
	 subnet_id                   = aws_subnet.private.id
	 vpc_security_group_ids      = [aws_security_group.db.id]
	 associate_public_ip_address = true
	 tags                        = {
		 Name = "Eng67_Ugne_tf_db"
	 }
 }

 # creating the public the subnet

 resource "aws_subnet" "public" {
	vpc_id     = aws_vpc.tf_vpc.id
	cidr_block = var.subnet_public
	availability_zone = "eu-west-1a"
	map_public_ip_on_launch = true
	tags = {
	    Name = "Eng67_Ugne_Public_Subnet_TF"
	}
}

# creating the private subnet
 
 resource "aws_subnet" "private" {
	vpc_id     = aws_vpc.tf_vpc.id
	cidr_block = var.subnet_private
	availability_zone = "eu-west-1a"
	map_public_ip_on_launch = true
	tags = {
	    Name = "Eng67_Ugne_Public_Subnet_TF"
	}
}


# Creating security group for "app"
 resource "aws_security_group" "app" {
	 name = "app_sg"
	 description = "Allow https traffic"
	 vpc_id = aws_vpc.tf_vpc.id
	 #subnet_ids = [aws_subnet.public.id]

	   ingress {
		   description = "http from VPC"
		   from_port = 80
		   to_port = 80
		   protocol = "tcp"
		   cidr_blocks = ["0.0.0.0/0"]

	 }

	   ingress{
	       description = "access from my IP"
	       from_port = 22
	       to_port = 22
	       protocol = "tcp"
	       cidr_blocks = ["94.3.31.92/32"]


	   }
	   egress {
		 from_port = 0
		 to_port = 0
		 protocol = "-1"
		 cidr_blocks = ["0.0.0.0/0"]
	 }
 }

 resource "aws_security_group" "db" {
	 name = "db_sg"
	 description = "Allow access from app sg"
	 vpc_id = aws_vpc.tf_vpc.id
	 #subnet_ids = [aws_subnet.private.id]

	 ingress {
		 description = "from app sg"
		 from_port = 27017
		 to_port = 27017
		 protocol = "tcp"
		 security_groups = [aws_security_group.app.id]
	 }
     egress {
		 from_port  = 0
		 to_port    = 0
		 protocol   = "-1"
		 cidr_blocks = ["0.0.0.0/0"]
	 }
 }


//# Create NACL for public subnet
// resource "aws_network_acl" "public-nacl" {
//	 vpc_id = aws_vpc.tf_vpc.id
//	 subnet_ids = [aws_subnet.public.id]
//
//	 ingress {
//		     protocol   = "tcp"
//             rule_no    = 100
//             action     = "allow"
//		     cidr_block = "0.0.0.0/0"
//             from_port  = 443
//             to_port    = 80
//	 }
//	 ingress {
//		 protocol       = "tcp"
//		 rule_no        = 110
//		 action     	= "allow"
//		 cidr_block     = var.subnet_private
//		 from_port      = 27017
//		 to_port        = 27017
//	 }
//
//	 egress {
//		     from_port   = 0
//             to_port     = 0
//             protocol    = "-1"
//             cidr_block = "0.0.0.0/0"
//	 }
// }
//
//# Create NACL for private subnet
// resource "aws_network_acl" "private-nacl" {
//	 vpc_id = aws_vpc.tf_vpc.id
//	 subnet_ids = [aws_subnet.private.id]
//
//	 ingress {
//		 protocol       = "tcp"
//		 rule_no        = 100
//		 action     	= "allow"
//		 cidr_block     = var.subnet_public
//		 from_port      = 22
//		 to_port        = 22
//   }
//	 ingress {
//		 protocol = "tcp"
//		 rule_no = 110
//         action  = "allow"
//		 cidr_block = var.subnet_public
//		 from_port  = 27017
//		 to_port   = 27017
//	 }
//
//	  egress {
//		  from_port   = 0
//		  to_port     = 0
//		  protocol    = "-1"
//		  cidr_block = "0.0.0.0/0"
//	 }
// }


# Create a route table for public subnet
resource "aws_route_table" "route-public" {
  vpc_id = aws_vpc.tf_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "Eng67.Ugne.public.route"
  }
}

# Create route table association
 resource "aws_route_table_association" "Public-Route-Association" {
   subnet_id      = aws_subnet.public.id
   route_table_id = aws_route_table.route-public.id
}

# Create a private route table
resource "aws_route_table" "route-private" {
  vpc_id = aws_vpc.tf_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "Eng67.Ugne.private.route"
  }
}

  resource "aws_route_table_association" "Private-Route-Association" {
   subnet_id      = aws_subnet.private.id
   route_table_id = aws_route_table.route-private.id
}

# launch init script
  data "template_file" "initapp" {
    template = file ("init.sh.tpl")
    
   }

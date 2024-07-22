resource "aws_vpc" "lap-vpc" {
  cidr_block       = "10.0.0.0/16"
  

  tags = {
    Name = "lap-vpc"
  }
}


resource "aws_subnet" "lap-pub-subnet" {
  vpc_id     = aws_vpc.lap-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "lap-pub-subnet"
  }
}

resource "aws_subnet" "lap-priv-subnet" {
  vpc_id     = aws_vpc.lap-vpc.id
  cidr_block = "10.0.2.0/24"
availability_zone = "us-east-1b"
  tags = {
    Name = "lap-priv-subnet"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.lap-vpc.id

  tags = {
    Name = "gw"
  }
}

# resource "aws_internet_gateway_attachment" "gwt" {
#   internet_gateway_id = aws_internet_gateway.gw.id
#   vpc_id              = aws_vpc.lap-vpc.id




resource "aws_security_group" "sg" {
  name        = "sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.lap-vpc.id

  tags = {
    Name = "sg"
  }
}

resource "aws_instance" "app-server" {
  ami           = "ami-0b72821e2f351e396" 
  instance_type = "t2.micro"
  
  tags = {
    name = "app-server"
  }

}
  
resource "aws_instance" "web-server" {
  ami           = "ami-01fccab91b456acc2" 
  instance_type = "t2.micro"
  key_name = "keypair-tf"
  
  tags = {
    name = "web-server"
  }

}


resource "aws_db_subnet_group" "db-subnet-gp" {
  name       = "db-subnet-gp"
  subnet_ids = [aws_subnet.lap-priv-subnet.id, aws_subnet.lap-pub-subnet.id]
  tags = {
    Name = "db-subnet-gp"
  }
}
  
resource "aws_db_instance" "database" {
  allocated_storage    = 10
  db_name              = "database1"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username             = "admin"
  password             = "admin1234"
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
  db_subnet_group_name= aws_db_subnet_group.db-subnet-gp.id

  
}

resource "aws_s3_bucket" "learningtestlap" {
  bucket = "learningtestlap"

  tags = {
    Name        = "learningtestlap"
    Environment = "Dev"
  }
}

resource "aws_key_pair" "keypair-tf" {
  key_name   = "keypair-tf"
  public_key = " .ssh/id_rsa.pub"

}


resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.lap-vpc.id

  route {
    cidr_block = "10.0.3.0/24"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "pub-rt-assoc" {
  subnet_id      = aws_subnet.lap-pub-subnet.id
  route_table_id = aws_route_table.rt.id
}

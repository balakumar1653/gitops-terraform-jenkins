#VPC for our applications

resource "aws_vpc" "app_vpc" {
  cidr_block = "${var.vpc_cidr}"
}


#Create Internet Gateway and attach it to app_vpc

resource "aws_internet_gateway" "app_igw" {
  vpc_id = "${aws_vpc.app_vpc.id}"

}

# Building subnets for our VPCs

resource "aws_subnet" "public" {
  count                   = "${length(var.subnet_cidr)}"
  availability_zone       = "${element(var.avlzone, count.index)}"
  vpc_id                  = "${aws_vpc.app_vpc.id}"
  cidr_block              = "${element(var.subnet_cidr, count.index)}"
  map_public_ip_on_launch = true

}

#Create Route table, attach Internet Gateway and associate with public subnets


resource "aws_route_table" "public_rt" {
  vpc_id = "${aws_vpc.app_vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.app_igw.id}"
  }

}
# Attach route table with public subnets
resource "aws_route_table_association" "a" {
  count          = "${length(var.subnet_cidr)}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public_rt.id}"
}

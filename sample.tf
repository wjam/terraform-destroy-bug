variable "consul_address" { }
variable "consul_scheme" { default = "http" }
variable "consul_token" { default = "d6b8444a-11a2-4c5b-965b-dfe78ac63400" }
variable "consul_datacenter" { default = "dc1" }

provider "consul" {
  address = "${var.consul_address}"
  scheme = "${var.consul_scheme}"
  token = "${var.consul_token}"
  datacenter = "${var.consul_datacenter}"
}

data "consul_keys" "consul" {

  key {
    name = "file_contents"
    path = "file_contents"
  }
  key {
    name = "consul_datacenter"
    path = "consul_datacenter"
  }
  key {
    name = "consul_scheme"
    path = "consul_scheme"
  }

}

resource "archive_file" "archive" {
  type = "zip"
  source_content = "${data.consul_keys.consul.var.file_contents}"
  source_content_filename = "demonstration.txt"
  output_path = "${path.module}/example.zip"
}

resource "consul_keys" "second" {
  provider = "consul.ctwo"
  key {
    path                 = "${archive_file.archive.output_size}/value"
    value                = "something"
    delete               = true
  }
}

provider "consul" {
  alias = "ctwo"
  address = "${var.consul_address}"
  token = "${var.consul_token}"

  # Uncomment the lines below to make it work
//  datacenter = "${var.consul_datacenter}"
//  scheme = "${var.consul_scheme}"

  # Uncomment the lines below to make it fail
  datacenter = "${data.consul_keys.consul.var.consul_datacenter}"
  scheme = "${data.consul_keys.consul.var.consul_scheme}"
}

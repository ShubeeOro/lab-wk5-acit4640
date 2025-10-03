# https://developer.hashicorp.com/packer/docs/templates/hcl_templates/blocks/packer
packer {
  required_plugins {
    amazon = {
      version = ">= 1.5"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

# https://developer.hashicorp.com/packer/docs/templates/hcl_templates/blocks/source
source "amazon-ebs" "debian" {
  ami_name      = "web-nginx-aws"
  instance_type = "t2.micro"
  region        = "us-west-2"
  source_ami_filter {
    filters = {
      name                = "debian-*-amd64-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["136693071363"]
  }
  ssh_username = "admin"
}

# https://developer.hashicorp.com/packer/docs/templates/hcl_templates/blocks/build
build {
  name = "web-nginx"
  sources = [
    # COMPLETE ME Use the source defined above
    "sources.amazon-ebs.debian"
  ]
  
  # https://developer.hashicorp.com/packer/docs/templates/hcl_templates/blocks/build/provisioner
  provisioner "shell" {

    scripts = [
      "scripts/install-nginx",
      "scripts/setup-dir"
    ]
    pause_before = "10s"
    timeout = "10s"

      # COMPLETE ME add inline scripts to create necessary directories and change directory ownership.
      # See nginx.conf file for root directory where files will be served.
      # Files need appropriate ownership for default user

  }

  provisioner "file" {
    # COMPLETE ME add the HTML file to your image
    source = "files/index.html"
    destination = "/web/html/index.html"
  }

  provisioner "file" {
    # COMPLETE ME add the nginx.conf file to your image
    source = "files/nginx.conf"
    destination = "/tmp/web/nginx.conf"
  }

  # COMPLETE ME add additional provisioners to run shell scripts and complete any other tasks

  provisioner "shell" {
    script = "scripts/setup-nginx"
    pause_before = "10s"
    timeout = "10s"
  }
}

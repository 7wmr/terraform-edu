# Configure the DigitalOcean Provider
provider "digitalocean" {
  # token = "${var.do_token}"
  # using env variable DIGITALOCEAN_TOKEN
}

data "digitalocean_ssh_key" "default" {
  name = "rneave@Richard-Neave-Work"
}

resource "digitalocean_domain" "default" {
  name       = "dev01.8lr.co.uk"
  ip_address = "${digitalocean_droplet.dev01.ipv4_address}"
}

# Create a web server
resource "digitalocean_droplet" "dev01" {
  name     = "dev01.8lr.co.uk"
  size     = "s-1vcpu-1gb"
  image    = "ubuntu-18-04-x64"
  region   = "lon1"
  ssh_keys = ["${data.digitalocean_ssh_key.default.fingerprint}"]

  provisioner "file" {
    source      = "/Users/rneave/.ssh/id_rsa"
    destination = "/root/.ssh/id_rsa"
    
    connection {
      type        = "ssh"
      host        = "${digitalocean_droplet.dev01.ipv4_address}"
      private_key = "${file("~/.ssh/id_rsa")}"
      user        = "root"
      timeout     = "2m"
    }

  }

  provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin",
      "apt-get -y update && apt-get -y install",
      "chmod 600 ~/.ssh/id_rsa",
      "mkdir -p ~/repos && cd ~/repos",
      "ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts",
      "git clone git@github.com:7wmr/dotfiles.git && cd dotfiles/",
      "sh install-ubuntu.sh"
    ]

    connection {
      type        = "ssh"
      host        = "${digitalocean_droplet.dev01.ipv4_address}"
      private_key = "${file("~/.ssh/id_rsa")}"
      user        = "root"
      timeout     = "2m"
    }

  }

}

#resource "digitalocean_certificate" "cert" {
#  name    = "dev01.8lr.co.uk.cert"
#  type    = "lets_encrypt"
#  domains = ["dev01.8lr.co.uk"]
#}
#
## Create a new Load Balancer with TLS termination
#resource "digitalocean_loadbalancer" "public" {
#  name        = "secure-loadbalancer-1"
#  region      = "lon1"
#
#  forwarding_rule {
#    entry_port      = 443
#    entry_protocol  = "https"
#
#    target_port     = 80
#    target_protocol = "http"
#
#    certificate_id  = "${digitalocean_certificate.cert.id}"
#  }
#
#  droplet_ids = ["${digitalocean_droplet.dev01.id}"]
#}



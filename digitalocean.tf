# Configure the DigitalOcean Provider
provider "digitalocean" {
  # token = "${var.do_token}"
  # using env variable DIGITALOCEAN_TOKEN
}

# Create a web server
resource "digitalocean_droplet" "web" {
  name   = "ubuntu-dev01"
  size   = "s-1vcpu-1gb"
  image  = "ubuntu-18-04-x64"
  region = "lon1"
}

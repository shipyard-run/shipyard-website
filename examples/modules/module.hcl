network "onprem" {
  subnet = "10.6.0.0/16"
}

module "consul" {
	source = "./sub_module"
}

module "nomad" {
	source = "github.com/shipyard-run/blueprints//consul-nomad"
}
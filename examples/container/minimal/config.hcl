container "unique_name" {
    network {
        name = "network.cloud"
    }

    image {
        name = "consul:1.6.1"
    }
}

network "cloud" {
    subnet = "10.0.0.0/16"
}
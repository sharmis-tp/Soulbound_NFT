import-ssh:
	ssh-add ~/.ssh/sharmis

build:
	sui move build

test:
	sui move test
TAG = 1.0
PREFIX = antob/mongo-backup

all: build push

build:
	docker build -t $(PREFIX):$(TAG) .

push:
	docker push $(PREFIX):$(TAG)

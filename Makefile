# Copyright 2018-present Ciena Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

ifeq ($(ONOS_IP),)
ONOS_IP=127.0.0.1
endif
ifeq ($(ONOS_PORT),)
ONOS_PORT=8181
endif
ONOS_USER=karaf
ONOS_PASS=karaf

ifeq ($(VERSION),)
VERSION=$(shell xq -r .project.version pom.xml)
endif

ONOS_VERSION=1.14.1
ONOS_IMAGE_NAME=onosproject/onos
ONOS_IMAGE=$(ONOS_IMAGE_NAME):$(ONOS_VERSION)

help:
	@echo "The following make targets are available:"
	@echo ""
	@echo "build             - compiles and packages the Ciena Flowswitch Driver"
	@echo "clean             - removes the build artifacts from the work directory"
	@echo "onos-up           - starts an instance of ONOS as a container"
	@echo "onos-down         - stops the ONOS container instances"
	@echo "deploy            - uploads and activates the Ciena Flowswitch Driver in ONOS"
	@echo "undeploy          - removes the Ciena Flowswitch Driver from ONOS"
	@echo "post-sample       - HTTP POSTs a sample Flowswitch device configuration to ONOS"

build:
	mvn -Donos.version=$(ONOS_VERSION) install

onos-up:
	docker run --rm -tid --name onos -p 8181:8181 -p 8101:8101 $(ONOS_IMAGE) $(ONOS_OPTIONS)

onos-down:
	docker rm -f onos

post-sample:
	curl --fail -X POST -HContent-type:application/json http://karaf:karaf@localhost:8181/onos/v1/network/configuration -d@sample.json

deploy:
	curl --fail -sSL --user $(ONOS_USER):$(ONOS_PASS) -X POST -H "Content-Type:application/octet-stream" http://$(ONOS_IP):$(ONOS_PORT)/onos/v1/applications?activate=true --data-binary @target/onos-jinjava-sample-0.0.1-SNAPSHOT.oar

undeploy:
	curl --fail -sSL --user $(ONOS_USER):$(ONOS_PASS) -X DELETE http://$(ONOS_IP):$(ONOS_PORT)/onos/v1/applications/com.ciena.onos.jinjava

clean:
	mvn clean

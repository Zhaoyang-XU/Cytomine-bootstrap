#
# Copyright (c) 2009-2017. Authors: see NOTICE file.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

FROM cytomineuliege/java8

MAINTAINER Cytomine Team "support@cytomine.be"

RUN apt-get update -y && apt-get install -y groovy
RUN cd /tmp/  && wget -q http://release.cytomine.be/java-client/cytomine-java-client-1.0-SNAPSHOT-jar-with-dependencies.jar -O Cytomine-client-java.jar
RUN cd /tmp/ && mkdir data && cd data && wget -q http://release.cytomine.be/data/data-demo.tar.gz -O data-demo.tar.gz && tar -zxvf data-demo.tar.gz

ADD injectdata.groovy /tmp/injectdata.groovy
RUN chmod +x /tmp/injectdata.groovy
ADD deploy.sh /tmp/deploy.sh
RUN chmod +x /tmp/deploy.sh

ENTRYPOINT ["/tmp/deploy.sh"]

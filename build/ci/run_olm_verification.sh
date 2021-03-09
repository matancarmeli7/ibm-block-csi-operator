#!/bin/bash -xe

#
# Copyright 2020 IBM Corp.
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
#

docker build -f build/ci/Dockerfile.olm-verification -t operator-olm-verification .

ARCH=$(uname -m)

if [ "${ARCH}" != "ppc64le" ]; then
  DOCKER_PATH=$(which docker)
  docker run --rm -t -v /var/run/docker.sock:/var/run/docker.sock -v "${DOCKER_PATH}":/usr/bin/docker operator-olm-verification
else
  docker run --rm -t operator-olm-verification
fi

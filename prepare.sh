#!/bin/sh
# Copyright 2014-2015 TIS Inc.
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

run() {
  output="$("$@" 2>&1)"
  status="$?"
}

install_git() {
  run which git
  if [ $status -ne 0 ]; then
    echo "install git."
    yum install -y git
    if [ $status -ne 0 ] ; then
      echo "$output" >&2
      return 1
    fi
  fi
}

install_ruby() {
  run which ruby
  if [ $status -ne 0 ]; then
    echo "install ruby."

    run which git
    if [ $status -ne 0 ]; then
      install_git
    fi
    yum install -y openssl-devel readline-devel zlib-devel tar
    git clone https://github.com/sstephenson/rbenv.git /usr/local/rbenv
    git clone https://github.com/sstephenson/ruby-build.git /usr/local/rbenv/plugins/ruby-build
    echo 'export RBENV_ROOT="/usr/local/rbenv"' > /etc/profile.d/rbenv.sh
    echo 'export PATH="${RBENV_ROOT}/bin:${PATH}"' >> /etc/profile.d/rbenv.sh
    echo 'eval "$(rbenv init --no-rehash -)"' >> /etc/profile.d/rbenv.sh
    source /etc/profile.d/rbenv.sh
    rbenv install -v 2.2.3
    rbenv rehash
    rbenv global 2.2.3
  fi
}

install_ansible() {
  run which ansible
  if [ $status -ne 0 ]; then
    echo "install ansible."
    yum install -y --enablerepo=epel ansible
    if [ $status -ne 0 ] ; then
      echo "$output" >&2
      return 1
    fi
  fi
}

set_ruby_path() {
  run which ruby
  if [ $status -ne 0 ]; then
    if [[ -d /opt/chefdk ]] && [[ -x /opt/chefdk/embedded/bin/ruby ]]; then
      ruby_home=/opt/chefdk/embedded
    elif [[ -d /opt/chef ]] && [[ -x /opt/chef/embedded/bin/ruby ]]; then
      ruby_home=/opt/chef/embedded
    fi

    echo "export PATH=\$PATH:${ruby_home}/bin" > ${CHEF_ENV_FILE}
    export PATH=${ruby_home}/bin:${PATH}
  fi
}

install_serverspec() {
  run which ruby
  if [ $status -ne 0 ]; then
    install_ruby
  fi

  run bash -c "gem list | grep serverspec"
  if [ $status -ne 0 ]; then
    gem install serverspec
  fi
}

setup_python_env() {
  PACKAGE_LIST=$1

  run which python
  if [ $status -ne 0 ] ; then
    run yum install -y python
    if [ $status -ne 0 ] ; then
      echo "$output" >&2
      return 1
    fi
  fi

  run which pip
  if [ $status -ne 0 ] ; then
    run bash -c "curl -kL https://bootstrap.pypa.io/get-pip.py | python"
    if [ $status -ne 0 ] ; then
      echo "$output" >&2
      return 1
    fi
  fi

  run pip install -r ${PACKAGE_LIST}
  if [ $status -ne 0 ] ; then
    echo "$output" >&2
    deactivate
    return 1
  fi
}

install_ansible
install_serverspec

setup_python_env ./lib/python-packages.txt

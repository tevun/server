#!/usr/bin/env bash

apt-get install -y language-pack-pt
locale-gen --purge en_US en_US.UTF-8 pt_BR.UTF-8
dpkg-reconfigure locales

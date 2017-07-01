#!/bin/sh

set -e

cd ~/
git clone git@github.com:ignat-zakrevsky/ducalis.git
cd ducalis
bundle install
bundle exec ruby lib/cli.rb --adapter circle

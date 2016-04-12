# Puppet module: removecontent

This is a Puppet module for removecontent
It provides only package installation and file configuration.
Released under the terms of Apache 2 License.

This module requires the presence of getlib module in your modulepath.


## USAGE - Basic management

* Install removecontent with default settings

        class { 'removecontent': }

* Install a specific version of removecontent package

        class { 'removecontent':
          version => '1.0.1',
        }

* Remove removecontent resources

        class { 'removecontent':
          absent => true
        }

* Enable auditing without without making changes on existing removecontent configuration *files*

        class { 'removecontent':
          audit_only => true
        }

* Module dry-run: Do not make any change on *all* the resources provided by the module

        class { 'removecontent':
          noops => true
        }


## USAGE - Overrides and Customizations
* Use custom sources for main config file 

        class { 'removecontent':
          source => [ "puppet:///modules/get-automation/removecontent/removecontent.conf-${hostname}" , "puppet:///modules/get-automation/removecontent/removecontent.conf" ], 
        }


* Use custom source directory for the whole configuration dir

        class { 'removecontent':
          source_dir       => 'puppet:///modules/get-automation/removecontent/conf/',
          source_dir_purge => false, # Set to true to purge any existing file not present in $source_dir
        }

* Use custom template for main config file. Note that template and source arguments are alternative. 

        class { 'removecontent':
          template => 'get-automation/removecontent/removecontent.conf.erb',
        }

* Automatically include a custom subclass

        class { 'removecontent':
          extend => 'get-automation::my_removecontent',
        }



## TESTING
[![Build Status](https://travis-ci.org/get-automation/puppet-removecontent.png?branch=master)](https://travis-ci.org/get-automation/puppet-removecontent)

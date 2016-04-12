# Class: removecontent::params
#
# This class defines default parameters used by the main module class removecontent
# Operating Systems differences in names and paths are addressed here
#
# == Variables
#
# Refer to removecontent class for the variables defined here.
#
# == Usage
#
# This class is not intended to be used directly.
# It may be imported or inherited by other classes
#
class removecontent::params {

  # Define what operating systems does this module support.
  # Anything not listed as true will prevent the module from being applied.
  $supported_os = $::operatingsystem ? {
    /(?i:RedHat|OracleLinux|CentOS)/  => true,
    /(?i:Debian|Ubuntu)/              => false,
    default                           => false
  }

  ### Application related parameters ###
  # - Package
  $package = $::operatingsystem ? {
    default => 'removecontent',
  }

  $version = $::operatingsystem ? {
    default => 'present'
  }

  # - File
  $config_dir = $::operatingsystem ? {
    default => 'c:/Users/nitin/Desktop/removecontent',
  }

  $config_file = $::operatingsystem ? {
    default => 'c:/Users/nitin/Desktop/removecontent/removecontent.conf',
  }

  $config_file_mode = $::operatingsystem ? {
    default => '0644',
  }

  $config_file_owner = $::operatingsystem ? {
    default => 'Administrators',
  }

  $config_file_group = $::operatingsystem ? {
    default => 'Administrators',
  }


  ### General Settings
  $noops            = false
  $audit_only       = false
  $absent           = true
  $extend           = ''

  # Config File Parameters
  $source                    = ''
  $source_dir                = ''
  $source_dir_purge          = false
  $template                  = undef
  $content                   = undef
  $options                   = undef

}

# vim: ts=2 et sw=2 autoindent

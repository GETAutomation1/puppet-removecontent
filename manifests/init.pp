# = Class: removecontent
#
# This is the main removecontent class
#
#
# == Parameters
#
# Standard class parameters
# Define the general class behavior and customizations
#
# [*extend*]
#   Name of a custom class to autoload to manage module's customizations
#   If defined, removecontent class will automatically "include $extend"
#   Can be defined also by the (top scope) variable $removecontent_extend
#   Can be defined also by the (class scope) variable $removecontent::extend
#
# [*source*]
#   Sets the content of source parameter for main configuration file
#   If defined, removecontent main config file will have the param: source => $source
#   Can be defined also by the (top scope) variable $removecontent_source
#   Can be defined also by the (class scope) variable $removecontent::source
#
# [*source_dir*]
#   If defined, the whole removecontent configuration directory content is retrieved
#   recursively from the specified source
#   (source => $source_dir , recurse => true)
#   Can be defined also by the (top scope) variable $removecontent_source_dir
#   Can be defined also by the (class scope) variable $removecontent::source_dir
#
# [*source_dir_purge*]
#   If set to true (default false) the existing configuration directory is
#   mirrored with the content retrieved from source_dir
#   (source => $source_dir , recurse => true , purge => true)
#   Can be defined also by the (top scope) variable $removecontent_source_dir_purge
#   Can be defined also by the (class scope) variable $removecontent::source_dir_purge
#
# [*template*]
#   Sets the path to the template to use as content for main configuration file
#   If defined, removecontent main config file has: content => content("$template")
#   Note source and template parameters are mutually exclusive: don't use both
#   Can be defined also by the (top scope) variable $removecontent_template
#   Can be defined also by the (class scope) variable $removecontent::template
#
# [*options*]
#   An hash of custom options to be used in templates for arbitrary settings.
#   Can be defined also by the (top scope) variable $removecontent_options
#   Can be defined also by the (class scope) variable $removecontent::options
#
# [*version*]
#   The package version, used in the ensure parameter of package type.
#   Default: present. Can be 'latest' or a specific version number.
#   Note that if the argument absent (see below) is set to true, the
#   package is removed, whatever the value of version parameter.
#   Can be defined also by the (class scope) variable $removecontent::version
#
# [*absent*]
#   Set to 'true' to remove package(s) installed by module
#   Can be defined also by the (top scope) variable $removecontent_absent
#   Can be defined also by the (class scope) variable $removecontent::absent
#
# [*audit_only*]
#   Set to 'true' if you don't intend to override existing configuration files
#   and want to audit the difference between existing files and the ones
#   managed by Puppet.
#   Can be defined also by the (top scope) variables $removecontent_audit_only
#   and $audit_only
#   Can be defined also by the (class scope) variable $removecontent::audit_only
#
# [*noops*]
#   Set noop metaparameter to true for all the resources managed by the module.
#   Basically you can run a dryrun for this specific module if you set
#   this to true. Default: false
#   Can be defined also by the (class scope) variable $removecontent::noops
#
# Default class params - As defined in removecontent::params.
# Note that these variables are mostly defined and used in the module itself,
# overriding the default values might not affected all the involved components.
# Set and override them only if you know what you're doing.
# Note also that you can't override/set them via *top* scope variables.
#
# [*package*]
#   The name of removecontent package
#
# [*config_file*]
#   Main configuration file path
#
# == Examples
#
# You can use this class in 2 ways:
# - Set variables (at top/class scope level in an ENC (Automaton, Foreman etc..)) and "include removecontent"
# - Call removecontent as a parametrized class
#
# See README for details.
#
#
class removecontent (
  $noops             = $removecontent::params::noops,
  $extend            = $removecontent::params::extend,
  $absent            = $removecontent::params::absent,
  $package           = $removecontent::params::package,
  $version           = $removecontent::params::version,
  $config_file       = $removecontent::params::config_file,
  $config_file_mode  = $removecontent::params::config_file_mode,
  $config_file_owner = $removecontent::params::config_file_owner,
  $config_file_group = $removecontent::params::config_file_group,
  $source            = $removecontent::params::source,
  $source_dir        = $removecontent::params::source_dir,
  $source_dir_purge  = $removecontent::params::source_dir_purge,
  $template          = $removecontent::params::template,
  $content           = $removecontent::parmas::content,
  $options           = $removecontent::params::options,
  ) inherits removecontent::params {

  ### Warn if Operating System is *NOT* supported by this module
  if $removecontent::params::supported_os == true {
    ### Validation of Parameters
    validate_absolute_path($config_dir)
    validate_absolute_path($config_file)
    validate_string($config_file_owner)
    validate_string($config_file_group)
    validate_string($config_file_mode)
    if $options { validate_hash($options) }

    # Sanitize Booleans
    $bool_source_dir_purge    = any2bool($removecontent::source_dir_purge)
    $bool_absent              = any2bool($removecontent::absent)
    $bool_audit_only          = any2bool($removecontent::audit_only)
    $bool_noops               = any2bool($removecontent::noops)

    ### Definition of Managed Resource Parameters ( These are set based off the class parameter input )
    $manage_package = $removecontent::bool_absent ? {
      true  => 'absent',
      false => $removecontent::version,
    }

    $manage_file = $removecontent::bool_absent ? {
      true    => 'absent',
      default => 'present',
    }

    $manage_config_file_content = default_content($removecontent::content, $removecontent::template)

    $manage_config_file_source  = $removecontent::source ? {
      ''      => undef,
      default => is_array($removecontent::source) ? {
        false   => split($removecontent::source, ','),
        default => $removecontent::source,
      }
    }

    $manage_file_replace = $removecontent::bool_audit_only ? {
       true  => false,
       false => true,
    }

    ### Definition of Metaparameters
    $manage_audit = $removecontent::bool_audit_only ? {
      true  => 'all',
      false => undef,
    }

    ### Managed resources
    package { 'removecontent.package':
      ensure  => $removecontent::manage_package,
      name    => $removecontent::package,
      noop    => $removecontent::bool_noops,
    }

    file { 'removecontent.conf':
      ensure  => $removecontent::manage_file,
      path    => $removecontent::config_file,
      mode    => $removecontent::config_file_mode,
      owner   => $removecontent::config_file_owner,
      group   => $removecontent::config_file_group,
      require => Package['removecontent.package'],
      source  => $removecontent::manage_config_file_source,
      content => $removecontent::manage_config_file_content,
      replace => $removecontent::manage_file_replace,
      audit   => $removecontent::manage_audit,
      noop    => $removecontent::bool_noops,
    }

  # The whole removecontent configuration directory can be recursively overriden by a source directory
    if $removecontent::source_dir {
      file { 'removecontent.dir':
        ensure  => directory,
        path    => $removecontent::config_dir,
        require => Package['removecontent.package'],
        source  => $removecontent::source_dir,
        recurse => true,
        purge   => $removecontent::bool_source_dir_purge,
        force   => $removecontent::bool_source_dir_purge,
        replace => $removecontent::manage_file_replace,
        audit   => $removecontent::manage_audit,
        noop    => $removecontent::bool_noops,
      }
    }


    ### Include custom class if $extend is set
    if $removecontent::extend {
      include $removecontent::extend
    }
  } else {
    notice("INFO: ${::operatingsystem} is _NOT_ supported. Contact module maintainer for support.")
    notify{"INFO: ${::operatingsystem} is _NOT_ supported. Contact module maintainer for support.":}
  }

}


# vim: ts=2 et sw=2 autoindent

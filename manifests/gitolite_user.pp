# == Define: gitolite::gitolite_user
# 
# This define creates a gitolite user that will be used to host git
# repositories.
#
# === Parameters
#
# [*namevar*]
#   the login name of the gitolite user. Usually 'git' or 'gitolite'.
#
# [*homedir*]
#   home directory path of the gitolite user.
#
# [*repos_root*]
#   path to the root directory where git repositories will be created.
#
# [*repo_umask*]
#   This variable is used in gitolite.rc. This is the umask of the
#   repositories. Change this if you run stuff like gitweb and find it
#   can't read the repos.
#
# [*GL_GIT_CONFIG_KEYS*]
#   This variable is used in gitolite.rc. This is a regexp of the config
#   keys that are allowed to be set using the "config" keyword from gitolite.
#   Check templates/gitolite.rc for details.
#
define gitolite::gitolite_user(
  $homedir,
  $repos_root = '/git',
  $projects_list = '',
  $repo_umask = '0077',
  $GL_GITCONFIG_KEYS = '.*'
) {
  include gitolite::base

  if ($projects_list != '') {
    $proj_list = $projects_list
  } else {
    $proj_list = "${homedir}/projects.list"
  }

  user { $name:
    comment => 'gitolite user',
    managehome => true,
    home => $homedir,
  }

  file { $repos_root:
    ensure => directory,
    owner => $name,
    group => $name,
    mode => '0755',
    require => User[$name],
  }

  file { $homedir:
    ensure => directory,
    owner => $name,
    group => $name,
    require => User[$name],
  }

  file { "${homedir}/.ssh":
    ensure => directory,
    owner => $name,
    group => $name,
    mode => '0600',
    require => File[$homedir],
  }

  file { "${homedir}/.gitolite":
    ensure => directory,
    owner => $name,
    group => $name,
    require => File[$homedir],
  }

  file { "${homedir}/.gitolite/keydir":
    ensure => directory,
    owner => $name,
    group => $name,
    purge => true,
    recurse => true,
    require => File["${homedir}/.gitolite"],
    notify => Exec["gitolite-compile-${name}"],
  }

  file { "${homedir}/.gitolite/conf":
    ensure => directory,
    owner => $name,
    group => $name,
    require => File["${homedir}/.gitolite"],
  }

  file { "${homedir}/.gitolite/conf/repos":
    ensure => directory,
    owner => $name,
    group => $name,
    purge => true,
    recurse => true,
    require => File["${homedir}/.gitolite/conf"],
    notify => Exec["gitolite-compile-${name}"],
  }

  file { "${homedir}/.gitolite/conf/groups":
    ensure => directory,
    owner => $name,
    group => $name,
    purge => true,
    recurse => true,
    require => File["${homedir}/.gitolite/conf"],
    notify => Exec["gitolite-compile-${name}"],
  }

  file { "${homedir}/.gitolite/conf/gitolite.conf":
    ensure => present,
    owner => $name,
    group => $name,
    source => 'puppet:///modules/gitolite/gitolite.conf',
    require => File["${homedir}/.gitolite/conf"],
  }

  file { "${homedir}/.gitolite.rc":
    ensure => present,
    owner => $name,
    group => $name,
    content => template('gitolite/gitolite.rc'),
    require => File[$homedir],
  }

  $glcompile = $gitolite::base::glcompile
  exec { "gitolite-compile-${name}":
    command => "su - ${name} -c ${glcompile}",
    refreshonly => true,
    require => [File[$glcompile], User[$name]],
    timeout => 0,
  }
}


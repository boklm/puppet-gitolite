# == Define: gitolite::user
#
# This defined resource will define a user in the gitolite configuration.
#
# === Parameters
#
# [*namevar*]
#   The name of the user that is being defined.
#
# [*gitolite_user*]
#   login name of the user hosting the git repositories.
#
# [*homedir*]
#   home directory of the user hosting the git repositories.
#
# [*key*]
#   public ssh key of the user being defined.
#
define gitolite::user($gitolite_user, $homedir, $key) {
  file { "${homedir}/.gitolite/keydir/${name}.pub":
    ensure  => present,
    owner   => $gitolite_user,
    group   => $gitolite_user,
    notify  => Exec["gitolite-compile-${gitolite_user}"],
    content => $key,
  }
}

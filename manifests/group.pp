# == Define: gitolite::group
#
# This defined resource is used to define a group in the gitolite
# configuration.
#
# === Parameters
#
# [*namevar*]
#   identifier of the group declaration. This can be the same as the
#   group name, or something different.
#
# [*gitolite_user*]
#   login name of the gitolite user hosting the repositories.
#
# [*groupname*]
#   name of the group that should be defined.
#
# [*values*]
#   array containing a list of users to be included inside the group.
#
define gitolite::group(
  $gitolite_user,
  $homedir,
  $groupname,
  $values
) {
  file { "${homedir}/.gitolite/conf/groups/${name}.conf":
    ensure  => present,
    owner   => $gitolite_user,
    group   => $gitolite_user,
    notify  => Exec["gitolite-compile-${gitolite_user}"],
    content => inline_template("@<%= groupname %> = <%= values.join(' ') %>\n"),
  }
}

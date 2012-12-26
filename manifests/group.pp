define gitolite::group($gitolite_user, $homedir, $groupname, $values) {
  file { "${homedir}/.gitolite/conf/groups/${name}.conf":
    ensure => present,
    owner => $gitolite_user,
    group => $gitolite_user,
    notify => Exec["gitolite-compile-${gitolite_user}"],
    content => inline_template("@<%= groupname %> = <%= values.join(' ') %>\n"),
  }
}

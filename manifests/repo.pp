# == Define: gitolite::repo
#
# This defined resource will define a git repository inside the gitolite
# configuration.
#
# === Parameters
#
# [*namevar*]
#   The identifier of the definition. This can be the name of the repo,
#   or something else.
#
# [*gitolite_user*]
#   login name of the user hosting the git repositories.
#
# [*homedir*]
#   homedir of the user hosting the git repositories.
#
# [*reponame*]
#   name of the git repository that is being defined.
#
# [*access_rules*]
#   list of access rule lines
#
# [*options*]
#   list of gitolite options
#
# [*configs*]
#   list of git config options
#
# [*gitweb_owner*]
#   name of the owner of the git repo. This name is displayed by gitweb.
#
# [*description*]
#   description of the repository. This desncription is disylayed by gitweb.
#
define gitolite::repo(
  $gitolite_user,
  $homedir,
  $reponame,
  $access_rules,
  $options = [],
  $configs = [],
  $gitweb_owner = 'nobody',
  $description = 'no description'
) {
  $filename = regsubst($name, '/', '_', 'M')
  file { "${homedir}/.gitolite/conf/repos/${filename}.conf":
    ensure  => present,
    owner   => $gitolite_user,
    group   => $gitolite_user,
    notify  => Exec["gitolite-compile-${gitolite_user}"],
    content => template('gitolite/gitolite_repo.conf'),
  }
}

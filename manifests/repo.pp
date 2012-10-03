# access_rules: list of access rule lines
# options: list of gitolite options
# configs: list of git config options
define gitolite::repo($gitolite_user, $homedir, $reponame, $access_rules, $options = [], $configs = []) {
    $filename = regsubst($name, '/', '_', 'M')
    file { "${homedir}/.gitolite/conf/repos/${filename}.conf":
	ensure => present,
	owner => $gitolite_user,
	group => $gitolite_user,
	notify => Exec["gitolite-compile-${gitolite_user}"],
	content => template('gitolite/gitolite_repo.conf'),
    }
}

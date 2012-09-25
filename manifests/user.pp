define gitolite::user($gitolite_user, $homedir, $key) {
    file { "${homedir}/.gitolite/keydir/${name}.pub":
	ensure => present,
	owner => $gitolite_user,
	group => $gitolite_user,
	notify => Exec["gitolite-compile-${gitolite_user}"],
	content => $key,
	require => Gitolite::Gitolite_user[$gitolite_user],
    }
}

define gitolite::gitolite_user($homedir, $groups = []) {
    include gitolite::base

    user { $name:
	comment => "gitolite user",
	managehome => true,
	home => $homedir,
    }

    file { $homedir:
	ensure => directory,
	owner => $name,
	group => $name,
	require => User[$name],
    }

    file { "$homedir/.ssh":
	ensure => directory,
	owner => $name,
	group => $name,
	mode => '0600',
	require => File[$homedir],
    }

    file { "$homedir/.gitolite":
	ensure => directory,
	owner => $name,
	group => $name,
	require => File[$homedir],
    }

    file { "$homedir/.gitolite/keydir":
	ensure => directory,
	owner => $name,
	group => $name,
	require => File["$homedir/.gitolite"],
    }

    file { "$homedir/.gitolite/conf":
	ensure => directory,
	owner => $name,
	group => $name,
	require => File["$homedir/.gitolite"],
    }

    file { "$homedir/.gitolite/conf/repos":
	ensure => directory,
	owner => $name,
	group => $name,
	require => File["$homedir/.gitolite/conf"],
    }

    file { "$homedir/.gitolite/conf/gitolite.conf":
	ensure => present,
	owner => $name,
	group => $name,
	source => "puppet:///modules/gitolite/gitolite.conf",
	require => File["$homedir/.gitolite/conf"],
    }

    $glcompile = $gitolite::base::glcompile
    exec { "gitolite-compile-$name":
	command => $glcompile,
	user => $name,
	refreshonly => true,
	require => [File[$glcompile], User[$name]],
    }
}


define gitolite::gitolite_user($homedir, $groups = [], $repos_root = '/git', $projects_list = '') {
    include gitolite::base

    if ($projects_list == '') {
	$proj_list = $projects_list
    } else {
	$proj_list = "${homedir}/projects.list"
    }

    user { $name:
	comment => "gitolite user",
	managehome => true,
	home => $homedir,
    }

    file { $repos_root:
	ensure => directory,
	owner => $name,
	group => $name,
	mode => 0755,
	require => User[$name],
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

    file { "$homedir/.gitolite.rc":
	ensure => present,
	owner => $name,
	group => $name,
	content => template('gitolite/gitolite.rc'),
	require => File[$homedir],
    }

    $glcompile = $gitolite::base::glcompile
    exec { "gitolite-compile-$name":
	command => "su - $name -c $glcompile",
	refreshonly => true,
	require => [File[$glcompile], User[$name]],
    }
}


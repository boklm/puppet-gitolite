class gitolite::base {
    package { 'gitolite':
	ensure => installed,
    }

    $glcompile = '/usr/local/bin/gitolite-compile'

    file { $glcompile:
	ensure => present,
	owner => 'root',
	group => 'root',
	mode => '0755',
	source => 'puppet:///modules/gitolite/gitolite-compile',
    }
}

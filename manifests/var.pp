# == Class: gitolite::var
#
# Gitolite module configuration.
#
# === Parameters
#
# [*gl_version*]
#   version of gitolite. Can be v2 for versions 2.x or v3 for
#   versions 3.x.
#
class gitolite::var(
  $gl_version = 'v2'
) {
  if not ($gl_version in [ 'v2', 'v3' ]) {
    fail("Incorrect gitolite version $gl_version")
  }
}

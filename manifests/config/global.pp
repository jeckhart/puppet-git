# Public: Set a global git configuration value.
#
# namevar - The String name of the configuration option.
# value   - The String value of the configuration option.
#
# Examples
#
#   git::config::global { 'user.name':
#     value => 'Hugh Bot',
#   }
#
#   git::config::global { 'user.email':
#     value => 'test@example.com',
#   }
define git::config::global($value) {
  $split_key = split($name, '\.')
  $path = "/Users/${::boxen_user}/.gitconfig"

  $isarray = is_array($require)
  $isstring = is_string($require)
  $any2 = any2array($require)

  if $require {
    if is_array($require) {
      $localreq = $require
    } else {
      $localreq = any2array($require)
    }
  } else {
    $localreq = []
  }
  $os_require = $osfamily ? {
    'Darwin' => [],
    default  => [ File["/Users/${::boxen_user}"] ],
  }
  $extra_require = any2array(concat($os_require,$localreq))
  debug("req: '$extra_require' - '$os_require' - '$require' - '$localreq' - '$isarray' - '$isstring' - '$any2'")

  ini_setting { "set ${name} to ${value} in ${path}":
    ensure  => present,
    path    => $path,
    require => $extra_require,
    section => $split_key[0],
    setting => $split_key[1],
    value   => $value,
  }
}

project('networktime', ['c', 'vala'], 
          version: '0.1.0',
    meson_version: '>= 0.50.0',
  default_options: [ 'warning_level=2',
                   ],
)

networktime_sources = [
  'src/main.vala',
]

networktime_deps = [
  dependency('glib-2.0'),
  dependency('gobject-2.0'),
  meson.get_compiler('vala').find_library('posix'),
]

executable('networktime', networktime_sources,
  vala_args: '--target-glib=2.58',  dependencies: networktime_deps,
  install: true,
)
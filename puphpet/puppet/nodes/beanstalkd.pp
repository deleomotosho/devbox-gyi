class puphpet_beanstalkd (
  $beanstalkd,
  $apache,
  $hhvm,
  $nginx,
  $php
) {

  include ::puphpet::apache::params
  include puphpet::supervisord


  # beanstalk_console requires Apache or Nginx
  if array_true($apache, 'install') {
    $webroot = "${puphpet::apache::params::default_vhost_dir}/beanstalk_console"
  } elsif array_true($nginx, 'install') {
    $webroot = "${puphpet::params::nginx_webroot_location}/beanstalk_console"
  } else {
    $webroot = false
  }

  # beanstalk_console requires PHP engine
  if array_true($php, 'install') or array_true($hhvm, 'install') {
    $php_installed = true
  } else {
    $php_installed = false
  }

  create_resources( beanstalkd::config, {
    'beanstalkd' => $beanstalkd['settings'],
  })

  $console_prerequisites = ($webroot and $php_installed)

  if array_true($beanstalkd, 'beanstalk_console') and $console_prerequisites {
    class { 'puphpet::beanstalkd::console' :
      install_location => $webroot
    }
  }

  supervisord::program { 'clean_queue':
    command     => "php /var/www/clean/artisan queue:work --daemon --sleep=3 --tries=3 --memory=512",
    priority    => '100',
    autostart   => true,
    autorestart => 'true',
    environment => {
      'PATH' => "/bin:/sbin:/usr/bin:/usr/sbin:${path}",
      'COMPOSER_PROCESS_TIMEOUT' => '16000'
    },
    require     => [
      Class['puphpet::beanstalkd::console']
    ]
  }

}

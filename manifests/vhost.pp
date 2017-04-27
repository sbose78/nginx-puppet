# Manage an Nginx virtual host
class nginx::vhost($domain='UNSET',$root='UNSET') {
 
  include nginx  # Class was declared inside init.pp
 
  $default_parent_root = "/home/ubuntu/nginxsites-puppet"

    
 
  # Default value overrides
 
  if $domain == 'UNSET' {
    $vhost_domain = "$name.next"
$vhost_domain_a = "$name"
  } else {
	 $vhost_domain = "$domain.next"
	 $vhost_domain_a = "$domain"
  }




  if $root == 'UNSET' {
    	$vhost_root = "$default_parent_root/${name}.next"
	$vhost_root_a = "$default_parent_root/${name}"
  } else {
    	$vhost_root = "$root.next"
  	$vhost_root_a = "$root"
  }
 
 
  # Creating the virtual host conf file out of the template in nginx/templates directory
 
  file { "/etc/nginx/sites-available/${vhost_domain}.conf":
    content => template('nginx/vhost.erb'), # vhost.erb is present in nginx/templates/
    require => Package['nginx'],
    notify  => Exec['reload nginx'], # Resource was declared in init.pp
  }
 
  # Enabling the site by creating a sym link from sites-available to sites-enabled
 
  file { "/etc/nginx/sites-enabled/${vhost_domain}.conf":
    ensure  => link,
    target  => "/etc/nginx/sites-available/${vhost_domain}.conf",
    require => File["/etc/nginx/sites-available/${vhost_domain}.conf"],
    notify  => Exec['reload nginx'],
  }
 

  # Creating the virtual host conf file out of the template in nginx/templates directory

  file { "/etc/nginx/sites-available/${vhost_domain_a}.conf":
    content => template('nginx/vhost_a.erb'), # vhost.erb is present in nginx/templates/
    require => Package['nginx'],
    notify  => Exec['reload nginx'], # Resource was declared in init.pp
  }

  # Enabling the site by creating a sym link from sites-available to sites-enabled

  file { "/etc/nginx/sites-enabled/${vhost_domain_a}.conf":
    ensure  => link,
    target  => "/etc/nginx/sites-available/${vhost_domain_a}.conf",
    require => File["/etc/nginx/sites-available/${vhost_domain_a}.conf"],
    notify  => Exec['reload nginx'],
  } 


  # Creating the directory structure for the site directory
  # The array stores the directories to be created.
  # Puppet does not support a "mkdir -p " struct.
  # Hence, directories and subdirectories need to be
  # (painfully) defined in the puppet manifest, as below.
 
  $dir_tree = [ "$default_parent_root", "$vhost_root", "$vhost_root_a" ,
  ]
 file { $dir_tree :
          owner   => 'ubuntu',
          group   => 'ubuntu',
          ensure  => 'directory',
          mode    => '777',
  }
  ->   # This arrow ensures that the dir structure is created first.
  file {  ["$vhost_root/index.html"]:
            owner   => 'ubuntu',
            group   => 'ubuntu',
            source => "puppet:///modules/nginx/index-html", # index.html was dropped under nginx/files/
            mode    => '755',
  }->
  file {  ["$vhost_root/about.html"]:
            owner   => 'ubuntu',
            group   => 'ubuntu',
            source => "puppet:///modules/nginx/about-html", # index.html was dropped under nginx/files/
            mode    => '755',
  }->
  file { ["$vhost_root/downtime.html"]:
            owner   => 'ubuntu',
            group   => 'ubuntu',
            source => "puppet:///modules/nginx/downtime-html", # index.html was dropped under nginx/files/
            mode    => '755',
  }->file {  ["$vhost_root_a/index.html"]:
            owner   => 'ubuntu',
            group   => 'ubuntu',
            source => "puppet:///modules/nginx/index-html", # index.html was dropped under nginx/files/
            mode    => '755',
  }->
  file {  ["$vhost_root_a/about.html"]:
            owner   => 'ubuntu',
            group   => 'ubuntu',
            source => "puppet:///modules/nginx/about-html", # index.html was dropped under nginx/files/
            mode    => '755',
  }->
  file { ["$vhost_root_a/downtime.html"]:
            owner   => 'ubuntu',
            group   => 'ubuntu',
            source => "puppet:///modules/nginx/downtime-html", # index.html was dropped under nginx/files/
            mode    => '755',
  }
 
}

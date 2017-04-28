class nginx::serverinfo{

 $domain_used=hiera('domain_usage')

 $serverinfodata = [
  {
        metric => $::uptime,
        description => "Uptime"
  },
  {
        metric => $::kernelrelease,
        description => "kernel release"
  },
  {
	metric => $::users,
	description => "Current user"
  },
  {
	metric => "$domain_used" ,
	description => 'allowed hosts'

  },
 ]

}


	


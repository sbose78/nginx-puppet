class nginx::serverinfo{

	

 $serverinfodata = [
  {
        metric => $::uptime,
        description => "Uptime"
  },
  {
        metric => $::kernelrelease,
        description => "kernel release"
  },

 ]

}


	


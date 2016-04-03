use XML::LibXML;

$xmlFileName = 'services.xml';

$parser = XML::LibXML->new();
 
$file = $parser->parse_file($xmlFileName);

@root =  $file->findnodes('services/service');

$counter = @root;



use DBI;

$db = DBI->connect("dbi:SQLite:dbname=fw.db","","");

$sql = 'drop table cp_svc_map; ';
$db->do($sql);



$sql = 'create table cp_svc_map (name varchar(100), class varchar(100), port int, port2 int, member varchar(100), icmp varchar(20));';
$db->do($sql);

$sql = 'BEGIN;';
$db->do($sql);



for ($i=0; $i<$counter; $i++)
{
	if  ($root[$i]->findvalue('Class_Name') eq 'dcerpc_service')
		{
			$name = $root[$i]->findvalue('Name');
			$class = $root[$i]->findvalue('Class_Name');			

			$sql = "insert into cp_svc_map values('$name', '$class', null, null, null, null);";
			$db->do($sql);			

		}


	if  ($root[$i]->findvalue('Class_Name') eq 'service_group')
		{
			@members = $root[$i]->findnodes('members/reference');
			$memb_c = @members;
			
			for ($j=0; $j<$memb_c; $j++)
			{

				$name = $root[$i]->findvalue('Name');
				$class = $root[$i]->findvalue('Class_Name');
				$member = $members[$j]->findvalue('Name');

				$sql = "insert into cp_svc_map values('$name', '$class', null, null, '$member', null);";
				$db->do($sql);					
			}
		
		}
		
	if  ($root[$i]->findvalue('Class_Name') eq 'gtp_service')
		{
			$name = $root[$i]->findvalue('Name');
			$class = $root[$i]->findvalue('Class_Name');
			$port = $root[$i]->findvalue('port');		
			@pr = portrange($port);
		
			$sql = "insert into cp_svc_map values('$name', '$class', $pr[0], $pr[1], null, null);";
			$db->do($sql);				

		}	

	if  ($root[$i]->findvalue('Class_Name') eq 'gtp_mm_v0_service')
		{
			$name = $root[$i]->findvalue('Name');
			$class = $root[$i]->findvalue('Class_Name');
			$port = $root[$i]->findvalue('port');	
			@pr = portrange($port);			
		
			$sql = "insert into cp_svc_map values('$name', '$class', $pr[0], $pr[1], null, null);";
			$db->do($sql);				

		}	
		
	if  ($root[$i]->findvalue('Class_Name') eq 'gtp_mm_v1_service')
		{
			$name = $root[$i]->findvalue('Name');
			$class = $root[$i]->findvalue('Class_Name');
			$port = $root[$i]->findvalue('port');			
			@pr = portrange($port);			
		
			$sql = "insert into cp_svc_map values('$name', '$class', $pr[0], $pr[1], null, null);";
			$db->do($sql);				

		}	

	if  ($root[$i]->findvalue('Class_Name') eq 'gtp_v1_service')
		{
			$name = $root[$i]->findvalue('Name');
			$class = $root[$i]->findvalue('Class_Name');
		
			$sql = "insert into cp_svc_map values('$name', '$class', null, null, null, null);";
			$db->do($sql);				

		}			

	if  ($root[$i]->findvalue('Class_Name') eq 'icmp_service')
		{
			$name = $root[$i]->findvalue('Name');
			$class = $root[$i]->findvalue('Class_Name');
			$icmptype = $root[$i]->findvalue('icmp_type');

			$sql = "insert into cp_svc_map values('$name', '$class', null, null, null, '$icmptype');";
			$db->do($sql);					

		}
	
	if  ($root[$i]->findvalue('Class_Name') eq 'icmpv6_service')
		{
			$name = $root[$i]->findvalue('Name');
			$class = $root[$i]->findvalue('Class_Name');
			$icmptype = $root[$i]->findvalue('icmp_type');

			$sql = "insert into cp_svc_map values('$name', '$class', null, null, null, '$icmptype');";
			$db->do($sql);				

		}
		
	if  ($root[$i]->findvalue('Class_Name') eq 'other_service')
		{
			$name = $root[$i]->findvalue('Name');
			$class = $root[$i]->findvalue('Class_Name');
			$port = $root[$i]->findvalue('protocol');
			@pr = portrange($port);			
		
			$sql = "insert into cp_svc_map values('$name', '$class', $pr[0], $pr[1], null, null);";
			$db->do($sql);				

		}

	if  ($root[$i]->findvalue('Class_Name') eq 'rpc_service')
		{
			$name = $root[$i]->findvalue('Name');
			$class = $root[$i]->findvalue('Class_Name');
			$port = $root[$i]->findvalue('port');			
			@pr = portrange($port);			
		
			$sql = "insert into cp_svc_map values('$name', '$class', $pr[0], $pr[1], null, null);";
			$db->do($sql);	

		}			

	if  ($root[$i]->findvalue('Class_Name') eq 'tcp_service')
		{
			$name = $root[$i]->findvalue('Name');
			$class = $root[$i]->findvalue('Class_Name');
			$port = $root[$i]->findvalue('port');			
			@pr = portrange($port);			
		
			$sql = "insert into cp_svc_map values('$name', '$class', $pr[0], $pr[1], null, null);";
			$db->do($sql);				

		}

	if  ($root[$i]->findvalue('Class_Name') eq 'tcp_citrix_service')
		{
			$name = $root[$i]->findvalue('Name');
			$class = $root[$i]->findvalue('Class_Name');
			$port = $root[$i]->findvalue('port');			
			@pr = portrange($port);			
		
			$sql = "insert into cp_svc_map values('$name', '$class', $pr[0], $pr[1], null, null);";
			$db->do($sql);				

		}		
		
	if  ($root[$i]->findvalue('Class_Name') eq 'compound_tcp_service')
		{
			$name = $root[$i]->findvalue('Name');
			$class = $root[$i]->findvalue('Class_Name');
			$port = $root[$i]->findvalue('port');			
			@pr = portrange($port);			
		
			$sql = "insert into cp_svc_map values('$name', '$class', $pr[0], $pr[1], null, null);";
			$db->do($sql);				

		}	

	if  ($root[$i]->findvalue('Class_Name') eq 'udp_service')
		{
			$name = $root[$i]->findvalue('Name');
			$class = $root[$i]->findvalue('Class_Name');
			$port = $root[$i]->findvalue('port');			
			@pr = portrange($port);			
		
			$sql = "insert into cp_svc_map values('$name', '$class', $pr[0], $pr[1], null, null);";
			$db->do($sql);				

		}			

}
$sql = 'END;';
$db->do($sql);
$db->disconnect;

sub portrange {

$port = @_[0];

	if (substr($port,0,1) eq '<')
	{
		@portsplit = (1, substr($port,1,length($port)-1));
	} else {
	
		if (substr($port,0,1) eq '>')
		{
			@portsplit = (substr($port,1,length($port)-1),65535);
		} else {
			@portsplit = split(/-/, $port);
		}
	}
	
	@portrange = ();
	
	if (($portsplit[0] >=1) and ($portsplit[1]>=1))
	{
		@portrange = ($portsplit[0], $portsplit[1]);
	}

	if (!($portsplit[0] >=1) and ($portsplit[1]>=1))
	{
		
		@portrange = ($portsplit[1], $portsplit[1])
	}	
	
	if (($portsplit[0] >=1) and !($portsplit[1]>=1))
	{
		
		@portrange = ($portsplit[0], $portsplit[0])
	}	
	
	return @portrange;
	
}
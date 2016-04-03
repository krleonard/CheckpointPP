use XML::LibXML;

$xmlFileName = 'network_objects.xml';

$parser = XML::LibXML->new();
 
$file = $parser->parse_file($xmlFileName);

@root =  $file->findnodes('network_objects/network_object');

$counter = @root;

use DBI;

$db = DBI->connect("dbi:SQLite:dbname=fw.db","","");

$sql = 'drop table cp_netobj; ';
$db->do($sql);



$sql = 'create table cp_netobj (name varchar(100), class varchar(50), ip varchar(50), mask varchar(50), ip_value int, ip2 varchar(50), ip2_value int, member varchar(100), plus varchar(50));';
$db->do($sql);

$sql = 'BEGIN;';
$db->do($sql);


for ($i=0;$i<$counter;$i++)
{

	if  ($root[$i]->findvalue('Class_Name') eq 'cluster_member')
	{
		@ifs = $root[$i]->findnodes('interfaces/interfaces');
		$if_c = @ifs;
		
		for ($j=0; $j<$if_c; $j++)
		{

			$name = $root[$i]->findvalue('Name');
			$class = $root[$i]->findvalue('Class_Name');
			$ip = $ifs[$j]->findvalue('ipaddr');
			$mask = $ifs[$j]->findvalue('netmask');
			$ipvalue = ip2dec($ip);

			$sql = "insert into cp_netobj values('$name', '$class', '$ip','$mask', $ipvalue, '$ip', $ipvalue, null, null);";
			$db->do($sql);
		}
		$ip2 = $root[$i]->findvalue('ipaddr');
		$ip2value = ip2dec($ip2);

		$sql = "insert into cp_netobj values('$name', '$class', '$ip2',null, $ip2value, '$ip2', $ip2value, null, null);";
		$db->do($sql);			

	}
	
	if  ($root[$i]->findvalue('Class_Name') eq 'dynamic_object')
	{
		$name = $root[$i]->findvalue('Name');
		$class = $root[$i]->findvalue('Class_Name');
		$ip = $root[$i]->findvalue('bogus_ip');
		$ipvalue = ip2dec($ip);

		$sql = "insert into cp_netobj values('$name', '$class', '$ip', null, $ipvalue, '$ip', $ipvalue, null, null);";
		$db->do($sql);
	}

	if  ($root[$i]->findvalue('Class_Name') eq 'gateway_cluster')
	{
		@ifs = $root[$i]->findnodes('interfaces/interfaces');
		$if_c = @ifs;
		
		for ($j=0; $j<$if_c; $j++)
		{

			$name = $root[$i]->findvalue('Name');
			$class = $root[$i]->findvalue('Class_Name');
			$ip = $ifs[$j]->findvalue('ipaddr');
			$mask = $ifs[$j]->findvalue('netmask');
			$ipvalue = ip2dec($ip);

			$sql = "insert into cp_netobj values('$name', '$class', '$ip','$mask', $ipvalue, '$ip', $ipvalue, null, null);";
			$db->do($sql);				

		}
		
		$ip2 = $root[$i]->findvalue('ipaddr');
		$ip2value = ip2dec($ip2);
		
		$sql = "insert into cp_netobj values('$name', '$class', '$ip2',null, $ip2value, '$ip2', $ip2value, null, null);";
		$db->do($sql);
		

	}	
	
	if  ($root[$i]->findvalue('Class_Name') eq 'network_object_group')
	{
		@members = $root[$i]->findnodes('members/reference');
		$memb_c = @members;
		
		for ($j=0; $j<$memb_c; $j++)
		{

			$name = $root[$i]->findvalue('Name');
			$class = $root[$i]->findvalue('Class_Name');
			$member = $members[$j]->findvalue('Name');

			$sql = "insert into cp_netobj values('$name', '$class', null, null, null, null, null, '$member', null);";
			$db->do($sql);				

		}
		
		

	}

	if  ($root[$i]->findvalue('Class_Name') eq 'group_with_exception')
	{
		@base = $root[$i]->findnodes('base');
		$base_c = @base;
		
		for ($j=0; $j<$base_c; $j++)
		{

			$name = $root[$i]->findvalue('Name');
			$class = $root[$i]->findvalue('Class_Name');
			$base_ = $base[$j]->findvalue('Name');

			$sql = "insert into cp_netobj values('$name', '$class', null, null, null, null, null, '$base_', 'base');";
			$db->do($sql);				

		}
		
		@exc = $root[$i]->findnodes('exception');
		$exc_c = @exc;
		
		for ($j=0; $j<$exc_c; $j++)
		{

			$name = $root[$i]->findvalue('Name');
			$class = $root[$i]->findvalue('Class_Name');
			$exc_ = $exc[$j]->findvalue('Name');

			$sql = "insert into cp_netobj values('$name', '$class', null, null, null, null, null, '$exc_', 'exc');";
			$db->do($sql);						

		}
	
	}	

	if  ($root[$i]->findvalue('Class_Name') eq 'host_plain')
	{
			$name = $root[$i]->findvalue('Name');
			$class = $root[$i]->findvalue('Class_Name');
			$ip = $root[$i]->findvalue('ipaddr');
			$ipvalue = ip2dec($ip);

			$sql = "insert into cp_netobj values('$name', '$class', '$ip',null, $ipvalue, '$ip', $ipvalue, null, null);";
			$db->do($sql);				

	}
		
	if  ($root[$i]->findvalue('Class_Name') eq 'host_ckp')
	{
		@ifs = $root[$i]->findnodes('interfaces/interfaces');
		$if_c = @ifs;
		
		for ($j=0; $j<$if_c; $j++)
		{

			$name = $root[$i]->findvalue('Name');
			$class = $root[$i]->findvalue('Class_Name');
			$ip = $ifs[$j]->findvalue('ipaddr');
			$mask = $ifs[$j]->findvalue('netmask');
			$ipvalue = ip2dec($ip);

			$sql = "insert into cp_netobj values('$name', '$class', '$ip','$mask', $ipvalue, '$ip', $ipvalue, null, null);";
			$db->do($sql);
			
		}
		$ip2 = $root[$i]->findvalue('ipaddr');
		$ip2value = ip2dec($ip2);

		$sql = "insert into cp_netobj values('$name', '$class', '$ip2',null, $ip2value, '$ip2', $ip2value, null, null);";
		$db->do($sql);					

	}

	if  ($root[$i]->findvalue('Class_Name') eq 'address_range')
	{
		$name = $root[$i]->findvalue('Name');
		$class = $root[$i]->findvalue('Class_Name');
		$ip_first = $root[$i]->findvalue('ipaddr_first');
		$ip_last = $root[$i]->findvalue('ipaddr_last');
		$ipfvalue = ip2dec($ip_first);
		$iplvalue = ip2dec($ip_last);

		
		$sql = "insert into cp_netobj values('$name', '$class', '$ip_first',null, $ipfvalue, '$ip_last', $iplvalue, null, null);";
		$db->do($sql);			
		
	}	
	
	if  ($root[$i]->findvalue('Class_Name') eq 'network')
	{
		$name = $root[$i]->findvalue('Name');
		$class = $root[$i]->findvalue('Class_Name');
		$ip = $root[$i]->findvalue('ipaddr');
		$mask = $root[$i]->findvalue('netmask');
		$ipvalue = ip2dec($ip);
		@sn = subnet($ip,$mask);
		$baseip = @sn[0];
		$upperip = @sn[1];
		$basevalue = ip2dec($baseip);
		$uppervalue = ip2dec($upperip);

		$sql = "insert into cp_netobj values('$name', '$class', '$baseip','$mask', $basevalue, '$upperip', $uppervalue, null, null);";
		$db->do($sql);			

	}		

	if  ($root[$i]->findvalue('Class_Name') eq 'security_zone')
	{
		$name = $root[$i]->findvalue('Name');
		$class = $root[$i]->findvalue('Class_Name');
		$ip = $root[$i]->findvalue('bogus_ip');
		$ipvalue = ip2dec($ip);

		$sql = "insert into cp_netobj values('$name', '$class', '$ip',null , $ipvalue, '$ip', $ipvalue, null, null);";
		$db->do($sql);		
	}
	
}

$sql = 'END;';
$db->do($sql);
$db->disconnect;	

sub subnet {

	@ret = ();
	@subnetip = split(/\./, @_[0]);
	@subnetmask = split(/\./, @_[1]);

	$maskvalue = ip2dec(@_[1]);
	$ipvalue = ip2dec(@_[0]);
	$ipbasevalue = $ipvalue-($ipvalue%((256**4-1)-$maskvalue+1));
	$ipuppervalue = (256**4-1)-$maskvalue+$ipbasevalue;

	$base = dec2ip($ipbasevalue);
	$upper = dec2ip($ipuppervalue);

	push(@ret,$base,$upper);

	return @ret;

}

sub dec2ip {
	$iptemp = @_[0];
	@ip=();
	push(@ip, int($iptemp/256**3), int(($iptemp%256**3)/256**2), int((($iptemp%256**3)%256**2)/256), (($iptemp%256**3)%256**2)%256);
	$ret = @ip[0] . '.' . @ip[1] . '.' . @ip[2] . '.' . @ip[3];
	return $ret;
}

sub ip2dec{

    $ipf = @_[0];

    @ipsplit = split(/\./, $ipf);

    $octet1 = $ipsplit[0]*256**3;
    $octet2 = $ipsplit[1]*256**2;
    $octet3 = $ipsplit[2]*256;
    $octet4 = $ipsplit[3];

    $ipvalue = $octet1+$octet2+$octet3+$octet4;

    return $ipvalue;
}

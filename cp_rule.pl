use XML::LibXML;

$xmlFileName = 'Security_Policy.xml';

$parser = XML::LibXML->new();
 
$file = $parser->parse_file($xmlFileName);

@root =  $file->findnodes('fw_policies/fw_policie/rule/rule');

$counter = @root;

use DBI;

$db = DBI->connect("dbi:SQLite:dbname=fw.db","","");

$sql = 'drop table cp_rule; ';
$db->do($sql);
$sql = 'drop table cp_source; ';
$db->do($sql);
$sql = 'drop table cp_dest; ';
$db->do($sql);
$sql = 'drop table cp_service; ';
$db->do($sql);
$sql = 'drop table cp_fw; ';
$db->do($sql);


$sql = 'create table cp_rule (rule_name varchar(20), type varchar(50), com varchar(500), disabled varchar(10));';
$db->do($sql);
$sql = 'create table cp_source (rule_name varchar(20), source varchar(100));';
$db->do($sql);
$sql = 'create table cp_dest (rule_name varchar(20), destination varchar(100));';
$db->do($sql);
$sql = 'create table cp_service (rule_name varchar(20), service varchar(100)); ';
$db->do($sql);
$sql = 'create table cp_fw (rule_name varchar(20), fw varchar(50)); ';
$db->do($sql);
$sql = 'BEGIN;';
$db->do($sql);

for ($j=0;$j<$counter;$j++)
{

	if ($root[$j]->findvalue('Rule_Number') ne '')
	{
		$rulenum = $root[$j]->findvalue('Rule_Number');
		$type = $root[$j]->findvalue('action/action/Name');
		$comment = $root[$j]->findvalue('comments');
		$disabled = $root[$j]->findvalue('disabled');
		
		$sql = "insert into cp_rule values('$rulenum', '$type', '$comment', '$disabled');";
		$db->do($sql);
		
		
		@dst = $root[$j]->findnodes('dst/members/reference');
		$dst_c = @dst;
		if ($dst_c > 0)
		{
			for($i=0;$i<$dst_c;$i++)
			{
				$rulenum = $root[$j]->findvalue('Rule_Number'); 
				$dest = $dst[$i]->findvalue('Name');
				$sql = "insert into cp_dest values('$rulenum', '$dest');";
				$db->do($sql);
			}
		}

		@fw = $root[$j]->findnodes('install/members/reference');
		$fw_c = @fw;
		if ($fw_c > 0)
		{
			for($i=0;$i<$fw_c;$i++)
			{
				$rulenum = $root[$j]->findvalue('Rule_Number');
				$firew = $fw[$i]->findvalue('Name');
				$sql = "insert into cp_fw values('$rulenum', '$firew');";
				$db->do($sql);
			}
		}


		@srv = $root[$j]->findnodes('services/members/reference');
		$srv_c = @srv;
		if ($srv_c > 0)
		{
			for($i=0;$i<$srv_c;$i++)
			{
				$rulenum = $root[$j]->findvalue('Rule_Number');
				$serv = $srv[$i]->findvalue('Name');
				$sql = "insert into cp_service values('$rulenum', '$serv');";
				$db->do($sql);
			}
		}

		@src = $root[$j]->findnodes('src/members/reference');
		$src_c = @src;
		if ($src_c > 0)
		{
			for($i=0;$i<$src_c;$i++)
			{
				$rulenum = $root[$j]->findvalue('Rule_Number');
				$source = $src[$i]->findvalue('Name');
				$sql = "insert into cp_source values('$rulenum', '$source');";
				$db->do($sql);
			}
		}
	}
}

$sql = 'END;';
$db->do($sql);
$db->disconnect;	


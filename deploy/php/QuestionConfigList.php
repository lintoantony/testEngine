<?php
define('TT_BASE', dirname(__FILE__). '/..');
include_once TT_BASE. '/includes/config.inc.php';
require_Once ADODB_DIR. 'adodb.inc.php';
include_once TT_BASE. '/includes/functions.inc.php';
include_once TT_BASE. '/includes/connect.inc.php';
require_once TT_BASE. '/lib/TTSmarty.php';
include_once TT_BASE.'/includes/class.phpmailer.php';
include_once TT_BASE.'/includes/class.smtp.php';

$TT_smarty = new TTSmarty;
$TT_smarty->assign('urlPath',APP_URL);
$TT_smarty->assign('imagePath',IMAGE_DIR);
$TT_smarty->assign('appName',APP_NAME);
$TT_smarty->assign('photoUrl',PHOTO_URL);
$TT_smarty->assign('title',"Contact Us : Basic Theory Test (BTT) | Final Theory Test (FTT) | Riding Theory Test (RTT) Singapore Driving Theory Tests");




  $doc = new DOMDocument();
  header("Content-Type: text/plain");
  $doc->formatOutput = true;
      
  $config = $doc->createElement( "config" );  
  $doc->appendChild( $config );

  $appHeading = $doc->createElement("appHeading");
  $config->appendChild($appHeading);

  $cdata = $doc->createCDATASection("[Singapore Driving Theory Tests (BTT/FTT/RTT)]");
  $appHeading->appendChild($cdata);

  $userid = $doc->createElement("UserID");
  $config->appendChild($userid);
  
  $cdata = $doc->createCDATASection("101");
  $userid->appendChild($cdata);
  
  $userOptions = $doc->createElement("userOptions");
  $config->appendChild($userOptions);
  
  $option = $doc->createElement("option");
  $userOptions->appendChild($option);
  
  $optiontp = $doc->createAttribute("courseType");
  $option->appendChild($optiontp);
  
  $optiontpValue = $doc->createTextNode("courseType");
  $optiontp->appendChild($optiontpValue);

  $label = $doc->createElement("label");
  $option->appendChild($label);
  
  $cdata = $doc->createCDATASection("[Theory Test:]");
  $label->appendChild($cdata);
  
  $choices = $doc->createElement("choices");
  $option->appendChild($choices);
  
  $ListofCouses = getListofCourse($conn);
  $TT_smarty->assign('ListofCouses',$ListofCouses);
  $i = count($ListofCouses);

  for($k = 0; $k < $i; $k++)
  {
 		
   $item = $doc->createElement("item");
   $choices->appendChild($item);
   
   $itemid = $doc->createAttribute("itemid");
   $item->appendChild($itemid);
  
   $itemidValue = $doc->createTextNode($ListofCouses[$k]["sub"]);
   $itemid->appendChild($itemidValue);
  
   $cdata = $doc->createCDATASection("[".$ListofCouses[$k]["des"]."]");
   $item->appendChild($cdata);
   
  }
  
  $option1 = $doc->createElement("option");
  $userOptions->appendChild($option1);
  
  $optiontp = $doc->createAttribute("testMode");
  $option1->appendChild($optiontp);
  
  $optiontpValue = $doc->createTextNode("testMode");
  $optiontp->appendChild($optiontpValue);

  $label = $doc->createElement("label");
  $option1->appendChild($label);
  
  $cdata = $doc->createCDATASection("[Test Type/Mode:]");
  $label->appendChild($cdata);
  
  $choices = $doc->createElement("choices");
  $option1->appendChild($choices);
  
  $QuestionTypeList = getQuestionTypeList($conn);
  $TT_smarty->assign('QuestionTypeList',$QuestionTypeList);
  $i = count($QuestionTypeList);
  
   for($k = 0; $k < $i; $k++)
  {
 		
   $item = $doc->createElement("item");
   $choices->appendChild($item);
   
   $itemid = $doc->createAttribute("itemid");
   $item->appendChild($itemid);
  
   $itemidValue = $doc->createTextNode($QuestionTypeList[$k]["id"]);
   $itemid->appendChild($itemidValue);
  
   $cdata = $doc->createCDATASection("[".$QuestionTypeList[$k]["name"]."]");
   $item->appendChild($cdata);
   
  }
  
  
  $option2 = $doc->createElement("option");
  $userOptions->appendChild($option2);
  
  $optiontp = $doc->createAttribute("noOfQuestions");
  $option2->appendChild($optiontp);
  
  $optiontpValue = $doc->createTextNode("noOfQuestions");
  $optiontp->appendChild($optiontpValue);

  $label = $doc->createElement("label");
  $option2->appendChild($label);
  
  $cdata = $doc->createCDATASection("[No. of Questions:]");
  $label->appendChild($cdata);
  
  $choices = $doc->createElement("choices");
  $option2->appendChild($choices);
  
  $ListofQnos = getListofQnos($conn);
  $TT_smarty->assign('ListofQnos',$ListofQnos);
  $i = count($ListofQnos);
  
   for($k = 0; $k < $i; $k++)
  {
 		
   $item = $doc->createElement("item");
   $choices->appendChild($item);
   
   $itemid = $doc->createAttribute("itemid");
   $item->appendChild($itemid);
  
   $itemidValue = $doc->createTextNode($ListofQnos[$k]["id"]);
   $itemid->appendChild($itemidValue);
  
   $cdata = $doc->createCDATASection("[".$ListofQnos[$k]["name"]."]");
   $item->appendChild($cdata);
   
  }
  
  $option3 = $doc->createElement("option");
  $userOptions->appendChild($option3);
  
  $optiontp = $doc->createAttribute("language");
  $option3->appendChild($optiontp);
  
  $optiontpValue = $doc->createTextNode("language");
  $optiontp->appendChild($optiontpValue);

  $label = $doc->createElement("label");
  $option3->appendChild($label);
  
  $cdata = $doc->createCDATASection("[Language:]");
  $label->appendChild($cdata);
  
  $choices = $doc->createElement("choices");
  $option3->appendChild($choices);
  
  $ListofLanguage = getListofLanguage($conn);
  $TT_smarty->assign('ListofLanguage',$ListofLanguage);
  $i = count($ListofLanguage);
  
   for($k = 0; $k < $i; $k++)
  {
 		
   $item = $doc->createElement("item");
   $choices->appendChild($item);
   
   $itemid = $doc->createAttribute("itemid");
   $item->appendChild($itemid);
  
   $itemidValue = $doc->createTextNode($ListofLanguage[$k]["id"]);
   $itemid->appendChild($itemidValue);
  
   $cdata = $doc->createCDATASection("[".$ListofLanguage[$k]["name"]."]");
   $item->appendChild($cdata);
   
  }
  
  $userOptions = $doc->createElement("labelTexts");
  $config->appendChild($userOptions);
  
  $lbloption = $doc->createElement("label");
  $userOptions->appendChild($lbloption);
  
  $lbltype = $doc->createAttribute("type");
  $lbloption->appendChild($lbltype);
   
  $cpvalue = $doc->createTextNode("copyright");
  $lbltype->appendChild($cpvalue);
   
  $cdata = $doc->createCDATASection("Copyrights SGDriveTest @ 2011");
  $lbloption->appendChild($cdata);
  
  $lbloption = $doc->createElement("label");
  $userOptions->appendChild($lbloption);
  
  $lbltype = $doc->createAttribute("type");
  $lbloption->appendChild($lbltype);
   
  $cpvalue = $doc->createTextNode("instruction");
  $lbltype->appendChild($cpvalue);
   
  $cdata = $doc->createCDATASection("Pass percentage is 90%, Good Luck!");
  $lbloption->appendChild($cdata);
  
  
  $lbloption = $doc->createElement("label");
  $userOptions->appendChild($lbloption);
  
  $lbltype = $doc->createAttribute("type");
  $lbloption->appendChild($lbltype);
   
  $cpvalue = $doc->createTextNode("start");
  $lbltype->appendChild($cpvalue);
   
  $cdata = $doc->createCDATASection("START");
  $lbloption->appendChild($cdata);
  
  $lbloption = $doc->createElement("label");
  $userOptions->appendChild($lbloption);
  
  $lbltype = $doc->createAttribute("type");
  $lbloption->appendChild($lbltype);
   
  $cpvalue = $doc->createTextNode("prev");
  $lbltype->appendChild($cpvalue);
   
  $cdata = $doc->createCDATASection("Previous");
  $lbloption->appendChild($cdata);

  $lbloption = $doc->createElement("label");
  $userOptions->appendChild($lbloption);
  
  $lbltype = $doc->createAttribute("type");
  $lbloption->appendChild($lbltype);
   
  $cpvalue = $doc->createTextNode("next");
  $lbltype->appendChild($cpvalue);
   
  $cdata = $doc->createCDATASection("Next");
  $lbloption->appendChild($cdata);
  
  
  $lbloption = $doc->createElement("label");
  $userOptions->appendChild($lbloption);
  
  $lbltype = $doc->createAttribute("type");
  $lbloption->appendChild($lbltype);
   
  $cpvalue = $doc->createTextNode("finish");
  $lbltype->appendChild($cpvalue);
   
  $cdata = $doc->createCDATASection("Finish");
  $lbloption->appendChild($cdata);
  
    
  $lbloption = $doc->createElement("label");
  $userOptions->appendChild($lbloption);
  
  $lbltype = $doc->createAttribute("type");
  $lbloption->appendChild($lbltype);
   
  $cpvalue = $doc->createTextNode("bug");
  $lbltype->appendChild($cpvalue);
   
  $cdata = $doc->createCDATASection("Report Bugs");
  $lbloption->appendChild($cdata);
  
      
  $lbloption = $doc->createElement("label");
  $userOptions->appendChild($lbloption);
  
  $lbltype = $doc->createAttribute("type");
  $lbloption->appendChild($lbltype);
   
  $cpvalue = $doc->createTextNode("reviewQuestion");
  $lbltype->appendChild($cpvalue);
   
  $cdata = $doc->createCDATASection("Review Question");
  $lbloption->appendChild($cdata);
  
        
  $lbloption = $doc->createElement("label");
  $userOptions->appendChild($lbloption);
  
  $lbltype = $doc->createAttribute("type");
  $lbloption->appendChild($lbltype);
   
  $cpvalue = $doc->createTextNode("startAgain");
  $lbltype->appendChild($cpvalue);
   
  $cdata = $doc->createCDATASection("Start Again");
  $lbloption->appendChild($cdata);
  
        
  $lbloption = $doc->createElement("label");
  $userOptions->appendChild($lbloption);
  
  $lbltype = $doc->createAttribute("type");
  $lbloption->appendChild($lbltype);
   
  $cpvalue = $doc->createTextNode("review");
  $lbltype->appendChild($cpvalue);
   
  $cdata = $doc->createCDATASection("Review");
  $lbloption->appendChild($cdata);
  
  
        
  $lbloption = $doc->createElement("label");
  $userOptions->appendChild($lbloption);
  
  $lbltype = $doc->createAttribute("type");
  $lbloption->appendChild($lbltype);
   
  $cpvalue = $doc->createTextNode("page");
  $lbltype->appendChild($cpvalue);
   
  $cdata = $doc->createCDATASection("Page");
  $lbloption->appendChild($cdata);
  
  
  
    
        
  $lbloption = $doc->createElement("label");
  $userOptions->appendChild($lbloption);
  
  $lbltype = $doc->createAttribute("type");
  $lbloption->appendChild($lbltype);
   
  $cpvalue = $doc->createTextNode("summary");
  $lbltype->appendChild($cpvalue);
   
  $cdata = $doc->createCDATASection("Driving Test Summary");
  $lbloption->appendChild($cdata);
  
  
  
    
        
  $lbloption = $doc->createElement("label");
  $userOptions->appendChild($lbloption);
  
  $lbltype = $doc->createAttribute("type");
  $lbloption->appendChild($lbltype);
   
  $cpvalue = $doc->createTextNode("ptd");
  $lbltype->appendChild($cpvalue);
   
  $cdata = $doc->createCDATASection("Practice Test Drive");
  $lbloption->appendChild($cdata);
  
  
  
    
        
  $lbloption = $doc->createElement("label");
  $userOptions->appendChild($lbloption);
  
  $lbltype = $doc->createAttribute("type");
  $lbloption->appendChild($lbltype);
   
  $cpvalue = $doc->createTextNode("score");
  $lbltype->appendChild($cpvalue);
   
  $cdata = $doc->createCDATASection("Your Score");
  $lbloption->appendChild($cdata);
  
  
    
        
  $lbloption = $doc->createElement("label");
  $userOptions->appendChild($lbloption);
  
  $lbltype = $doc->createAttribute("type");
  $lbloption->appendChild($lbltype);
   
  $cpvalue = $doc->createTextNode("timeText");
  $lbltype->appendChild($cpvalue);
   
  $cdata = $doc->createCDATASection("You have done this practice in");
  $lbloption->appendChild($cdata);
  
  
    
        
  $lbloption = $doc->createElement("label");
  $userOptions->appendChild($lbloption);
  
  $lbltype = $doc->createAttribute("type");
  $lbloption->appendChild($lbltype);
   
  $cpvalue = $doc->createTextNode("percentage");
  $lbltype->appendChild($cpvalue);
   
  $cdata = $doc->createCDATASection("Percentage of Marks");
  $lbloption->appendChild($cdata);
  
  
  
    
        
  $lbloption = $doc->createElement("label");
  $userOptions->appendChild($lbloption);
  
  $lbltype = $doc->createAttribute("type");
  $lbloption->appendChild($lbltype);
   
  $cpvalue = $doc->createTextNode("result");
  $lbltype->appendChild($cpvalue);
   
  $cdata = $doc->createCDATASection("FINAL TEST RESULT");
  $lbloption->appendChild($cdata);
  
  
  
    
        
  $lbloption = $doc->createElement("label");
  $userOptions->appendChild($lbloption);
  
  $lbltype = $doc->createAttribute("type");
  $lbloption->appendChild($lbltype);
   
  $cpvalue = $doc->createTextNode("pass");
  $lbltype->appendChild($cpvalue);
   
  $cdata = $doc->createCDATASection("PASS");
  $lbloption->appendChild($cdata);
  
  
  
    
        
  $lbloption = $doc->createElement("label");
  $userOptions->appendChild($lbloption);
  
  $lbltype = $doc->createAttribute("type");
  $lbloption->appendChild($lbltype);
   
  $cpvalue = $doc->createTextNode("fail");
  $lbltype->appendChild($cpvalue);
   
  $cdata = $doc->createCDATASection("FAIL");
  $lbloption->appendChild($cdata);
  
  
    
        
  $lbloption = $doc->createElement("label");
  $userOptions->appendChild($lbloption);
  
  $lbltype = $doc->createAttribute("type");
  $lbloption->appendChild($lbltype);
   
  $cpvalue = $doc->createTextNode("select");
  $lbltype->appendChild($cpvalue);
   
  $cdata = $doc->createCDATASection("Select the best answer");
  $lbloption->appendChild($cdata);
  
  $userOptions = $doc->createElement("terms");
  $config->appendChild($userOptions);
  
  $lbloption = $doc->createElement("label");
  $userOptions->appendChild($lbloption);
  
  
   
  $cdata = $doc->createCDATASection("Terms and Conditions:");
  $lbloption->appendChild($cdata);
  
  
  $lstlist = $doc->createElement("list");
  $userOptions->appendChild($lstlist);
  
  $lstitem1 = $doc->createElement("item");
  $lstlist->appendChild($lstitem1);
  $cdata = $doc->createCDATASection("1. Questions are picked up randomly.");
  $lstitem1->appendChild($cdata);
  
  
  $lstitem2 = $doc->createElement("item");
  $lstlist->appendChild($lstitem2);  
  $cdata = $doc->createCDATASection("2. Test Results will be shown immediately at the end.");
  $lstitem2->appendChild($cdata);
  
  $lstitem3 = $doc->createElement("item");
  $lstlist->appendChild($lstitem3);
  $cdata = $doc->createCDATASection("3. Once the time limit reached, you couldn't able to continue. It will bring you t the summary page in the Test Simulated mode.");
  $lstitem3->appendChild($cdata);
  
  $lstitem4 = $doc->createElement("item");
  $lstlist->appendChild($lstitem4);
  $cdata = $doc->createCDATASection("4. You can go back by clicking the previous button to change the answer at any point.");
  $lstitem4->appendChild($cdata);
  
  $lstitem5 = $doc->createElement("item");
  $lstlist->appendChild($lstitem5);
  $cdata = $doc->createCDATASection("5. In case of any Difficulties/Errors Pls mail us.");
  $lstitem5->appendChild($cdata);
  
  $lstitem6 = $doc->createElement("item");
  $lstlist->appendChild($lstitem6);
  $cdata = $doc->createCDATASection("6. This is not an actual test conducted by Traffic Police (mockup test).");
  $lstitem6->appendChild($cdata);

    

  //echo $doc->saveXML();
  
  print "configXml=$doc";

 

function getListofCourse($conn)
 {
 	$sql = "SELECT * FROM dt_course WHERE is_active ='Y' ";
 	$rs  = &$conn->Execute($sql);
	//echo "$SQL : $sql";
 	if($rs) {
 		$count = 0;
		                          
 		while(!$rs->EOF) { 
		
 			$sno  		= $rs->fields["sno"]; 
 			$sub	    = $rs->fields["sub"];
			$key 		= $rs->fields["key"];
			$description= $rs->fields["description"];
				
			
 			$ret[$count++] = array(
 			"sno"    		=> $count,
 			"sno1" 			=> $sno,
			"sub" 			=> $sub,
			"key"			=> $key,
			"des"			=> $description	);
 			$rs->MoveNext(); }
 		}
 	return $ret;
}

function getQuestionTypeList($conn)
 {
 	$sql = "SELECT * FROM dt_testtype WHERE is_active ='Y' ";
 	$rs  = &$conn->Execute($sql);
	//echo "$SQL : $sql";
 	if($rs) {
 		$count = 0;
		                          
 		while(!$rs->EOF) { 
		
 			$id  		= $rs->fields["id"]; 
			$name	    = $rs->fields["name"];
			
 			$ret[$count++] = array(
 			"sno"    		=> $count,
 			"id" 			=> $id,
			"name" 			=> $name	);
 			$rs->MoveNext(); }
 		}
 	return $ret;
}

function getListofQnos($conn)
 {
 	$sql = "SELECT * FROM dt_noquestions WHERE is_active ='Y' ";
 	$rs  = &$conn->Execute($sql);
	//echo "$SQL : $sql";
 	if($rs) {
 		$count = 0;
		                          
 		while(!$rs->EOF) { 
		
 			$id  		= $rs->fields["id"]; 
 			$noofq	    = $rs->fields["noofq"];
			$name	    = $rs->fields["name"];
			
 			$ret[$count++] = array(
 			"sno"    		=> $count,
 			"id" 			=> $id,
			"noofq" 		=> $noofq,
			"name" 			=> $name	);
 			$rs->MoveNext(); }
 		}
 	return $ret;
}

function getListofLanguage($conn)
 {
 	$sql = "SELECT * FROM dt_language WHERE is_active ='Y' ";
 	$rs  = &$conn->Execute($sql);
	//echo "$SQL : $sql";
 	if($rs) {
 		$count = 0;
		                          
 		while(!$rs->EOF) { 
		
 			$id  		= $rs->fields["lang_id"]; 
 			$name	    = $rs->fields["name"];							
			
 			$ret[$count++] = array(
 			"sno"    		=> $count,
 			"id" 			=> $id,
			"name" 			=> $name	);
 			$rs->MoveNext(); }
 		}
 	return $ret;
}


?>



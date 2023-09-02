-- MySQL dump 10.13  Distrib 8.0.29, for Linux (x86_64)
--
-- Host: dataarchive.mysql.pythonanywhere-services.com    Database: dataarchive$default
-- ------------------------------------------------------
-- Server version	8.0.32

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `api_accessrequest`
--

DROP TABLE IF EXISTS `api_accessrequest`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `api_accessrequest` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `access` varchar(20) NOT NULL,
  `status` varchar(20) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `document_id` bigint NOT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `api_accessrequest_document_id_ec08d1f8_fk_api_document_id` (`document_id`),
  KEY `api_accessrequest_user_id_478b1081_fk_auth_user_id` (`user_id`),
  CONSTRAINT `api_accessrequest_document_id_ec08d1f8_fk_api_document_id` FOREIGN KEY (`document_id`) REFERENCES `api_document` (`id`),
  CONSTRAINT `api_accessrequest_user_id_478b1081_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `api_accessrequest`
--

LOCK TABLES `api_accessrequest` WRITE;
/*!40000 ALTER TABLE `api_accessrequest` DISABLE KEYS */;
/*!40000 ALTER TABLE `api_accessrequest` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `api_approval`
--

DROP TABLE IF EXISTS `api_approval`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `api_approval` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `status` varchar(25) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `document_id` bigint NOT NULL,
  `approver_id` bigint NOT NULL,
  `notes` longtext NOT NULL DEFAULT (_utf8mb3''),
  `requester_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `api_approval_document_id_status_79776f3c_uniq` (`document_id`,`status`),
  KEY `api_approval_approver_id_42d1e678_fk_api_position_id` (`approver_id`),
  KEY `api_approval_requester_id_3ff8b6ee_fk_auth_user_id` (`requester_id`),
  KEY `api_approval_document_id_1bf3e7a4` (`document_id`),
  CONSTRAINT `api_approval_approver_id_42d1e678_fk_api_position_id` FOREIGN KEY (`approver_id`) REFERENCES `api_position` (`id`),
  CONSTRAINT `api_approval_document_id_1bf3e7a4_fk_api_document_id` FOREIGN KEY (`document_id`) REFERENCES `api_document` (`id`),
  CONSTRAINT `api_approval_requester_id_3ff8b6ee_fk_auth_user_id` FOREIGN KEY (`requester_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=74 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `api_approval`
--

LOCK TABLES `api_approval` WRITE;
/*!40000 ALTER TABLE `api_approval` DISABLE KEYS */;
INSERT INTO `api_approval` VALUES (51,'rejected','2023-08-27 20:52:00.496836',81,33,'',12),(54,'accepted','2023-08-27 21:31:36.651798',84,33,'',12),(55,'pending','2023-08-27 23:39:39.504903',86,24,'',43),(56,'accepted','2023-08-27 23:39:42.151545',87,24,'',43),(57,'pending','2023-08-28 05:52:09.407637',91,31,'',12),(73,'accepted','2023-08-28 15:30:17.643233',117,1,'',12);
/*!40000 ALTER TABLE `api_approval` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `api_auditlog`
--

DROP TABLE IF EXISTS `api_auditlog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `api_auditlog` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `object_id` int unsigned NOT NULL,
  `action` varchar(50) NOT NULL,
  `timestamp` datetime(6) NOT NULL,
  `rationale` longtext NOT NULL,
  `content_type_id` int NOT NULL,
  `user_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `api_auditlog_content_type_id_e634b038_fk_django_content_type_id` (`content_type_id`),
  KEY `api_auditlog_user_id_b15d4175_fk_auth_user_id` (`user_id`),
  CONSTRAINT `api_auditlog_content_type_id_e634b038_fk_django_content_type_id` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `api_auditlog_user_id_b15d4175_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`),
  CONSTRAINT `api_auditlog_chk_1` CHECK ((`object_id` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `api_auditlog`
--

LOCK TABLES `api_auditlog` WRITE;
/*!40000 ALTER TABLE `api_auditlog` DISABLE KEYS */;
/*!40000 ALTER TABLE `api_auditlog` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `api_category`
--

DROP TABLE IF EXISTS `api_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `api_category` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `tag` varchar(100) NOT NULL,
  `description` varchar(300) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `tag` (`tag`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `api_category`
--

LOCK TABLES `api_category` WRITE;
/*!40000 ALTER TABLE `api_category` DISABLE KEYS */;
INSERT INTO `api_category` VALUES (1,'Invitations','Official Invitation from Management'),(2,'Journals','Journal Publications by Staff'),(3,'Proposals','Official Announcement from Management'),(4,'Personal Qualifications','Resume and other qualifications of staff'),(5,'Appointments','University-related appointment document'),(7,'Miscellaneous','Random Documents'),(8,'Uncategorised','A repository for uncategorised document'),(11,'Thesis','Job, Internship, Research and other'),(24,'Projects','projecs');
/*!40000 ALTER TABLE `api_category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `api_comment`
--

DROP TABLE IF EXISTS `api_comment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `api_comment` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `text` longtext NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `author_id` int NOT NULL,
  `document_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `api_comment_author_id_c45b2dbf_fk_auth_user_id` (`author_id`),
  KEY `api_comment_document_id_32e10a47_fk_api_document_id` (`document_id`),
  CONSTRAINT `api_comment_author_id_c45b2dbf_fk_auth_user_id` FOREIGN KEY (`author_id`) REFERENCES `auth_user` (`id`),
  CONSTRAINT `api_comment_document_id_32e10a47_fk_api_document_id` FOREIGN KEY (`document_id`) REFERENCES `api_document` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `api_comment`
--

LOCK TABLES `api_comment` WRITE;
/*!40000 ALTER TABLE `api_comment` DISABLE KEYS */;
INSERT INTO `api_comment` VALUES (1,'test','2023-08-22 09:27:35.219938',12,21),(2,'haha','2023-08-22 09:28:47.246397',12,21),(4,'blah','2023-08-22 11:22:42.026371',12,21),(5,'srufhe fesfuehdaunhs ihaihcns idcaiujcs akasubhsic asikchsic fhsohsdi hndkcs ddchs','2023-08-22 12:17:05.130077',12,21),(7,'Some errors where noted in the last section','2023-08-23 14:47:56.908117',12,45),(8,'Corrected now','2023-08-23 14:53:05.475649',13,45),(13,'ok, I think it is good','2023-08-27 23:43:55.289621',42,21),(20,'faulty','2023-08-28 15:31:10.639602',13,117),(21,'rectified','2023-08-28 15:31:50.267814',12,117);
/*!40000 ALTER TABLE `api_comment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `api_document`
--

DROP TABLE IF EXISTS `api_document`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `api_document` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `description` longtext NOT NULL,
  `file_type` varchar(255) NOT NULL,
  `file` varchar(100) NOT NULL,
  `source` varchar(255) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `uploaded_by_id` int NOT NULL,
  `last_updated` datetime(6) NOT NULL,
  `category_id` bigint NOT NULL,
  `date_received` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `api_document_uploaded_by_id_005dc346_fk_auth_user_id` (`uploaded_by_id`),
  KEY `api_document_category_id_d2193570_fk_api_category_id` (`category_id`),
  CONSTRAINT `api_document_category_id_d2193570_fk_api_category_id` FOREIGN KEY (`category_id`) REFERENCES `api_category` (`id`),
  CONSTRAINT `api_document_uploaded_by_id_005dc346_fk_auth_user_id` FOREIGN KEY (`uploaded_by_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=118 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `api_document`
--

LOCK TABLES `api_document` WRITE;
/*!40000 ALTER TABLE `api_document` DISABLE KEYS */;
INSERT INTO `api_document` VALUES (5,'Appointment for Kofi','letters','image','documents/sk2.png','Administration','2023-06-23 21:41:26.831185',12,'2023-06-27 18:01:50.561553',5,'2023-06-01 21:38:46.000000'),(6,'Decree of Massacre','deadly','image','documents/L400_SEM2_TIMETABLE.png','Kaguya','2023-06-23 21:44:45.496773',12,'2023-08-22 02:45:03.941611',8,'2023-05-29 21:42:32.000000'),(15,'Prospective Hackathon Venues','event','pdf','documents/mysql-tutorial-excerpt-5.7-en_rj1CGsU.pdf','CAL Bank','2023-06-27 18:31:17.295137',12,'2023-07-18 13:54:11.954044',7,'2023-03-06 18:28:57.000000'),(21,'Exploration of Outer Space with new Augmented Reality','quantum kinematics','word','documents/Reading_Report_3_-_Sets_and_Maps.docx','NASA','2023-07-18 14:11:38.651603',12,'2023-08-23 03:49:53.858578',2,'2023-07-18 14:02:05.064000'),(40,'Enigma Report','report','pdf','documents/Combined_Crytography_and_Network_Security_Solved_MCQ_Set_1-7_KtxdPPD.pdf','Research Lab','2023-08-23 11:17:49.217423',12,'2023-08-28 15:07:49.148575',4,'2023-08-23 11:16:59.305000'),(45,'Financial Report','bills and expenses','word','documents/Project_Documentation.docx','Management','2023-08-23 14:45:57.135813',12,'2023-08-25 04:26:40.110759',8,'2023-08-23 14:44:36.160000'),(81,'Call for Masters Reseach','the department of Medical Microbiology, ug......','image','documents/LOBO_BG_Ia6nIyo.png','Public Affairs','2023-08-27 20:52:00.483053',12,'2023-08-28 15:12:04.426055',5,'2023-08-27 20:51:19.413000'),(84,'365 Licence','Document access','word','documents/Chapter_5.docx','Microsoft Teams','2023-08-27 21:31:36.638726',12,'2023-08-28 15:08:49.377665',4,'2023-08-27 21:31:04.691000'),(86,'Hackathon','you are invited to a hackathon','image','documents/UoG_CoA_2017.svg.png','The School','2023-08-27 23:39:39.474443',43,'2023-08-28 15:06:52.075004',8,'2023-08-27 23:37:32.612000'),(87,'Finance Report','dear Graduates','image','documents/UoG_CoA_2017.svg_IGpiglw.png','The School','2023-08-27 23:39:42.136903',43,'2023-08-28 15:06:07.372846',8,'2023-08-27 23:37:32.612000'),(89,'Part-Time & Full-Time Job Opportunity','Hi there,\r\n\r\nA Ghanaian healthy fast-food restaurant is seeking to recruit both students and graduates for part-time and full-time jobs.\r\nClean Eats Limited is a counter-service snack bar with retail outlets in Tema, East Legon,  and Haatso.\r\n\r\nVacant Positions:\r\nCashiers\r\nKitchen Assistants\r\nSupervisor (only Haatso)\r\nCandidates must:\r\nhave a passion for working in the food industry\r\nmust have high levels of integrity\r\nmust be disciplined in carrying out their duties\r\nInterested candidates should apply through the link below:\r\nhttps://forms.gle/aMWBSWfQbAdXefM18\r\n\r\nThank you.\r\n--\r\n UG Careers and Counselling Centre','csv','documents/scanners_-_scanners.csv.csv','Careers And Counseling Center','2023-08-28 05:35:15.329439',12,'2023-08-28 06:10:54.866492',4,'2023-08-28 05:34:43.397000'),(90,'Finance Trainee NSS & Full-time Employment Opportunity','Dear graduates and final year students,\r\nAn international trade enterprise is open to accepting students and graduates for the following:\r\nNational Service posting\r\nFull-time employment\r\n\r\nCompany preferences (preferred, but not limited to):\r\nFinancing/Economic related majors…\r\nFluent in French\r\nBachelor/Master degree\r\nFemale applicants\r\n\r\nPlease provide the necessary information as well as your CV in the form below:\r\nhttps://forms.gle/EisTkYNvapb1DoJ26','pdf','documents/William_Stallings_Cryptography_and_Network_Securz_lib_org.pdf','Careers and Counsel','2023-08-28 05:40:35.695498',12,'2023-08-28 05:43:41.687614',5,'2023-08-27 05:32:53.000000'),(91,'Call for Applications - School of Languages Short Courses','Dear all,\r\n\r\nThe School of Languages announces its 2023 edition of short courses for professionals, ministers, church workers, researchers, consultants, language teachers and practitioners, (bilingual) secretaries, administrative assistants, expatriates, students and the general public. \r\n\r\n\r\n\r\nThe schedule and fees are as follows:\r\n\r\n\r\nNo.\r\n\r\nCourse Title\r\n\r\nDate\r\n\r\nDuration\r\n\r\nFees\r\n\r\n1\r\n\r\nWriting Skills for Administrators\r\n\r\nSeptember 11&12\r\n\r\n16 hours\r\n\r\nGH¢1,250\r\n\r\n2\r\n\r\nSpeaking and Presentation Skills\r\n\r\nSeptember 13&14\r\n\r\n16 hours\r\n\r\nGH¢1,250\r\n\r\n3\r\n\r\nMinute-Taking & Agenda Writing\r\n\r\nSeptember 15\r\n\r\n8 hours\r\n\r\nGH¢700\r\n\r\n4\r\n\r\nReport Writing\r\n\r\nSeptember 18&19\r\n\r\n16 hours\r\n\r\nGH¢1,250','pdf','documents/3-s2.0-B9780123747204000030-main.pdf','Public Affairs','2023-08-28 05:52:09.386266',12,'2023-08-28 05:52:10.962242',1,'2023-08-28 05:48:30.316000'),(92,'NSS OPPORTUNITY - ACCOUNTING STUDENTS','Careers And Counseling Centre UG <careers@st.ug.edu.gh>\r\nTue, Aug 22, 11:42 AM (6 days ago)\r\nto University, Accra, University\r\n\r\nDear final year students,\r\nAn international trade enterprise is seeking to recruit final year students for this 2023/2024 National Service period.\r\nRequirements:\r\nAccounting students\r\nFirst/second class upper honours\r\n\r\nTo apply, please fill the form with the required information, as well as your CV and academic record:\r\nhttps://forms.gle/cg1vVmb3xXCLbotz5\r\n\r\n\r\nThank you.\r\nAll the best.','image','','Careers And Cousel','2023-08-28 05:55:00.621289',12,'2023-08-28 05:55:00.621323',3,'2023-08-28 05:52:10.533000'),(94,'UG SRC ELECTIONS - 2023 - Voters Link','Dear Student,\r\n\r\nWelcome to UG-Evote Application. Kindly use the link below to login to the application and participate in the UG SRC ELECTIONS - 2023.\r\n\r\nLink: https://sts.ug.edu.gh/vote/ugsrc/?token=YdnfMx4WSRtwVkmv\r\n\r\nSend all questions and enquiries to itse.ugcs@staff.ug.edu.gh','word','documents/Course_work_3_Eso8B5e.docx','UG SERVICES','2023-08-28 06:06:22.492773',12,'2023-08-28 06:06:22.555024',1,'2023-08-28 06:02:24.006000'),(95,'EXTENSION OF DEADLINE: Call for Applications-OR Tambo Research Chair- MPhil & PhD Research Scholarships','Dear Men,\r\n\r\n   \r\n\r\nThe Office of Research, Innovation and Development (ORID) is pleased to inform the University community that the O.R. Tambo Africa Research Chair for Food Science and Technology at the University of Ghana invites applications for MPhil and PhD Research Scholarships.\r\n\r\n \r\n\r\nThe purpose of the scholarship is to provide funding for MPhil and PhD students to support the research component of a MPhil/PhD programme in the following departments:\r\n\r\n \r\n\r\nDepartment of Food Process Engineering\r\nDepartment of Nutrition and Food Science\r\nDepartment of Agricultural Engineering\r\n \r\n\r\n Eligibility criteria:   \r\n\r\n \r\n\r\nMPhil STUDENTS\r\n\r\nPhD STUDENTS\r\n\r\nUniversity of Ghana MPhil Year 1 student with excellent academic credentials.\r\nDemonstrable capacity to carry out original, and innovative research.\r\nAble to work independently, highly motivated.\r\n \r\n\r\nPhD student already enrolled in the listed departments at the University of Ghana.\r\nCompleted and passed all coursework requirements for PhD Year I.\r\nCompleted and passed comprehensive exams for PhD Year 2 (by the date of award).\r\nExcellent academic credentials.\r\nDemonstrable capacity to carry out original, and innovative research.\r\nAble to work independently, highly motivated.\r\nGood communication skills.\r\n \r\n\r\nScholarship details: \r\n\r\nPlease refer to the attached documents for the details.     \r\n\r\n  \r\n\r\nDeadline:  5 pm August 31, 2023.\r\n\r\n \r\n\r\nAll enquiries should be emailed to: innovatefoods@ug.edu.gh.\r\n\r\n \r\n\r\n \r\n\r\nSincerely,  \r\n\r\n----------------------------------','pdf','','ORID-INFORMATION','2023-08-28 06:17:26.981982',12,'2023-08-28 06:28:36.293059',11,'2023-08-28 06:11:20.279000'),(101,'Reminder - UG@75 Health Outreach Programme Inbox','Dear all, \r\n\r\nWe are thrilled to invite you to an exciting health outreach event as part of the ongoing 75th Anniversary celebration of the University of Ghana. The Outreach Programme is a unique opportunity for us to give back to the community that has been an integral part of our journey over the past 75 years. \r\n\r\nThe UG@75 Outreach Programme is scheduled as follows: \r\n\r\n\r\n\r\nDate:           Friday, 18th August, 2023 \r\n\r\nTime:          10:00 A.M. - 5:00 P.M. \r\n\r\nVenues:   Madina Main Market, Madina Zongo Junction (Chps Compound) and Agbogbloshie (A deprived community in Madina). \r\n\r\n \r\n\r\nThe UG@75 Health Outreach is in partnership with the LA Nkwantanang Municipal Health Directorate, with support from: \r\n\r\n* University Health Services \r\n\r\n* Medical School \r\n\r\n* Dental School \r\n\r\n* School of Public Health \r\n\r\n* School of Pharmacy \r\n\r\n* School of Biomedical and Allied Health Sciences \r\n\r\n* School of Nursing and Midwifery \r\n\r\n*Department of Psychology \r\n\r\n*Department of Social Work \r\n\r\n* Careers and Counselling Centre \r\n\r\n* University of Ghana Medical Centre \r\n\r\n\r\nMembers of the UG community are encouraged to actively participate in this event. Your volunteerism, presence, enthusiasm, and support are vital to the success of the Outreach Programme. \r\n\r\nPlease click here for more information on the outreach programme. \r\n\r\nFor further information, kindly contact Prof. Richmond Aryeetey (0244129669), Dr. Lilian Ohene (0246395696) or Ms Gloria Addai (0540816571) on ways to support the programme.','image','documents/health.jpeg','Public Affairs','2023-08-28 07:28:00.362749',12,'2023-08-28 07:28:02.179196',8,'2023-08-28 07:20:25.045000'),(102,'Assignment Submission','assignment submission for  DCIT 418 End of Semester Exam - Requires Respondus LockDown Browser\" is available on Aug 15, 2023 7:30:00 AM to the entire class at https://sakai.ug.edu.gh/samigo-app/servlet/Login?id=841a80c9-5d77-43fc-9bda-50405953c0bd1692068637198 has been completed at time limit 1 hr. This assessment will be submitted when time is up. Students can submit this 1 time(s). (The highest score will be recorded).\r\n\r\nStudent will receive no feedback.\r\n\r\nFind this assessment at the \"DCIT 418 1 S2-2223\" site on https://sakai.ug.edu.gh/portal.','csv','documents/RothIRA.csv','Sakai','2023-08-28 07:33:14.092672',12,'2023-08-28 07:33:14.217757',4,'2023-08-28 07:28:01.760000'),(117,'Invitation to SPMS','Training programme','word','documents/Course_work_3_45EC7xH.docx','Public Affairs','2023-08-28 15:30:17.615378',12,'2023-08-28 15:31:37.165101',1,'2023-08-22 15:28:56.000000');
/*!40000 ALTER TABLE `api_document` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `api_document_position_access`
--

DROP TABLE IF EXISTS `api_document_position_access`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `api_document_position_access` (
  `id` int NOT NULL AUTO_INCREMENT,
  `document_id` bigint NOT NULL,
  `position_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `api_document_position_ac_document_id_position_id_8aac845f_uniq` (`document_id`,`position_id`),
  KEY `api_document_positio_position_id_011c30de_fk_api_posit` (`position_id`),
  CONSTRAINT `api_document_positio_document_id_dac4c655_fk_api_docum` FOREIGN KEY (`document_id`) REFERENCES `api_document` (`id`),
  CONSTRAINT `api_document_positio_position_id_011c30de_fk_api_posit` FOREIGN KEY (`position_id`) REFERENCES `api_position` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=175 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `api_document_position_access`
--

LOCK TABLES `api_document_position_access` WRITE;
/*!40000 ALTER TABLE `api_document_position_access` DISABLE KEYS */;
INSERT INTO `api_document_position_access` VALUES (4,5,9),(2,6,1),(3,6,4),(18,21,24),(17,21,31),(50,91,31),(51,92,16),(146,101,9),(147,101,24),(148,101,26),(149,101,31),(145,101,32),(174,117,1);
/*!40000 ALTER TABLE `api_document_position_access` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `api_document_read_access`
--

DROP TABLE IF EXISTS `api_document_read_access`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `api_document_read_access` (
  `id` int NOT NULL AUTO_INCREMENT,
  `document_id` bigint NOT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `api_document_read_access_document_id_user_id_279391e9_uniq` (`document_id`,`user_id`),
  KEY `api_document_read_access_user_id_704b393a_fk_auth_user_id` (`user_id`),
  CONSTRAINT `api_document_read_access_document_id_81ffb7e6_fk_api_document_id` FOREIGN KEY (`document_id`) REFERENCES `api_document` (`id`),
  CONSTRAINT `api_document_read_access_user_id_704b393a_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=196 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `api_document_read_access`
--

LOCK TABLES `api_document_read_access` WRITE;
/*!40000 ALTER TABLE `api_document_read_access` DISABLE KEYS */;
INSERT INTO `api_document_read_access` VALUES (23,6,14),(10,21,4),(12,21,9),(13,21,12),(28,45,30);
/*!40000 ALTER TABLE `api_document_read_access` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `api_document_update_access`
--

DROP TABLE IF EXISTS `api_document_update_access`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `api_document_update_access` (
  `id` int NOT NULL AUTO_INCREMENT,
  `document_id` bigint NOT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `api_document_update_access_document_id_user_id_1df09f5d_uniq` (`document_id`,`user_id`),
  KEY `api_document_update_access_user_id_bd24f41f_fk_auth_user_id` (`user_id`),
  CONSTRAINT `api_document_update__document_id_f118ba02_fk_api_docum` FOREIGN KEY (`document_id`) REFERENCES `api_document` (`id`),
  CONSTRAINT `api_document_update_access_user_id_bd24f41f_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=54 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `api_document_update_access`
--

LOCK TABLES `api_document_update_access` WRITE;
/*!40000 ALTER TABLE `api_document_update_access` DISABLE KEYS */;
INSERT INTO `api_document_update_access` VALUES (1,6,2),(2,6,20),(19,21,13);
/*!40000 ALTER TABLE `api_document_update_access` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `api_notification`
--

DROP TABLE IF EXISTS `api_notification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `api_notification` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `message` varchar(300) NOT NULL,
  `is_read` tinyint(1) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `document_id` bigint DEFAULT NULL,
  `receiver_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `api_notification_receiver_id_message_document_id_163ec092_uniq` (`receiver_id`,`message`,`document_id`),
  KEY `api_notification_document_id_b8822602_fk_api_document_id` (`document_id`),
  CONSTRAINT `api_notification_document_id_b8822602_fk_api_document_id` FOREIGN KEY (`document_id`) REFERENCES `api_document` (`id`),
  CONSTRAINT `api_notification_receiver_id_4f55e63e_fk_auth_user_id` FOREIGN KEY (`receiver_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=379 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `api_notification`
--

LOCK TABLES `api_notification` WRITE;
/*!40000 ALTER TABLE `api_notification` DISABLE KEYS */;
INSERT INTO `api_notification` VALUES (38,'You have been granted read access to the document \'Financial Report\'.',0,'2023-08-25 01:46:35.581232',45,30),(140,'Document Approval Request: \'rsdfsdfrs\'',1,'2023-08-27 20:52:00.506913',81,13),(141,'You have been granted access to the document \'rsdfsdfrs\'.',1,'2023-08-27 20:52:00.526668',81,13),(146,'Document Approval Request: \'ergergdr\'',1,'2023-08-27 21:31:36.660272',84,13),(147,'You have been granted access to the document \'ergergdr\'.',1,'2023-08-27 21:31:36.679260',84,13),(148,'Document Approval Request: \'some doc\'',0,'2023-08-27 23:39:39.533147',86,42),(149,'You have been granted access to the document \'some doc\'.',1,'2023-08-27 23:39:39.636786',86,42),(150,'Document Approval Request: \'some doc\'',1,'2023-08-27 23:39:42.161332',87,42),(151,'You have been granted access to the document \'some doc\'.',1,'2023-08-27 23:39:42.180149',87,42),(152,'You have been granted update access to the document \'Finance Trainee NSS & Full-time Employment Opportunity\'.',0,'2023-08-28 05:40:35.731079',90,9),(153,'Document Approval Request: \'Call for Applications - School of Languages Short Courses\'',0,'2023-08-28 05:52:09.417765',91,24),(154,'You have been granted access to the document \'Call for Applications - School of Languages Short Courses\'.',0,'2023-08-28 05:52:09.436792',91,24),(156,'You have been granted access to the document \'EXTENSION OF DEADLINE: Call for Applications-OR Tambo Research Chair- MPhil & PhD Research Scholarships\'.',0,'2023-08-28 06:17:27.072740',95,40),(157,'You have been granted access to the document \'EXTENSION OF DEADLINE: Call for Applications-OR Tambo Research Chair- MPhil & PhD Research Scholarships\'.',0,'2023-08-28 06:17:27.089281',95,24),(158,'You have been granted access to the document \'EXTENSION OF DEADLINE: Call for Applications-OR Tambo Research Chair- MPhil & PhD Research Scholarships\'.',0,'2023-08-28 06:17:27.107263',95,25),(159,'You have been granted access to the document \'EXTENSION OF DEADLINE: Call for Applications-OR Tambo Research Chair- MPhil & PhD Research Scholarships\'.',0,'2023-08-28 06:17:27.123010',95,42),(160,'You have been granted access to the document \'EXTENSION OF DEADLINE: Call for Applications-OR Tambo Research Chair- MPhil & PhD Research Scholarships\'.',0,'2023-08-28 06:17:27.136653',95,44),(161,'You have been granted access to the document \'EXTENSION OF DEADLINE: Call for Applications-OR Tambo Research Chair- MPhil & PhD Research Scholarships\'.',0,'2023-08-28 06:17:27.159662',95,35),(313,'You have been granted access to the document \'Reminder - UG@75 Health Outreach Programme Inbox\'.',0,'2023-08-28 07:28:00.494068',101,40),(314,'You have been granted access to the document \'Reminder - UG@75 Health Outreach Programme Inbox\'.',0,'2023-08-28 07:28:00.541647',101,24),(315,'You have been granted access to the document \'Reminder - UG@75 Health Outreach Programme Inbox\'.',0,'2023-08-28 07:28:00.569803',101,25),(316,'You have been granted access to the document \'Reminder - UG@75 Health Outreach Programme Inbox\'.',0,'2023-08-28 07:28:00.592445',101,42),(317,'You have been granted access to the document \'Reminder - UG@75 Health Outreach Programme Inbox\'.',0,'2023-08-28 07:28:00.645126',101,44),(376,'Document Approval Request: \'Invitation to SPMS\'',1,'2023-08-28 15:30:17.663721',117,13),(377,'You have been granted access to the document \'Invitation to SPMS\'.',0,'2023-08-28 15:30:18.774967',117,13);
/*!40000 ALTER TABLE `api_notification` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `api_position`
--

DROP TABLE IF EXISTS `api_position`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `api_position` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `api_position_name_95182e2a_uniq` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `api_position`
--

LOCK TABLES `api_position` WRITE;
/*!40000 ALTER TABLE `api_position` DISABLE KEYS */;
INSERT INTO `api_position` VALUES (9,'Alumni Relations Officer'),(31,'Career Counselor'),(32,'Course Advisor'),(24,'Curriculum Coordinator'),(26,'Departmental Liaison'),(28,'Director of Graduate Studies'),(29,'Director of Undergraduate Studies'),(34,'Examination Officer'),(23,'Faculty Advisor'),(27,'Graduate Teaching Assistant Coordinator'),(1,'Head of Department'),(8,'International Programs Coordinator'),(3,'Internship Coordinator'),(22,'Laboratory Technician'),(33,'Librarian'),(5,'Program Coordinator'),(21,'Research Assistant'),(4,'Research Coordinator'),(25,'Scholarship Coordinator'),(16,'Secretary'),(6,'Student Affairs Coordinator'),(20,'Teaching Assistant');
/*!40000 ALTER TABLE `api_position` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `api_profile`
--

DROP TABLE IF EXISTS `api_profile`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `api_profile` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `staff_id` int NOT NULL,
  `title` varchar(20) NOT NULL,
  `phone` varchar(17) NOT NULL,
  `position_id` bigint DEFAULT NULL,
  `rank_id` bigint NOT NULL,
  `user_id` int NOT NULL,
  `is_admin` tinyint(1) NOT NULL,
  `gender` varchar(25) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`),
  UNIQUE KEY `api_profile_staff_id_a18d0929_uniq` (`staff_id`),
  UNIQUE KEY `api_profile_position_id_90ec5bd4_uniq` (`position_id`),
  KEY `api_profile_rank_id_cd9570aa_fk_api_rank_id` (`rank_id`),
  CONSTRAINT `api_profile_rank_id_cd9570aa_fk_api_rank_id` FOREIGN KEY (`rank_id`) REFERENCES `api_rank` (`id`),
  CONSTRAINT `api_profile_user_id_41309820_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `api_profile`
--

LOCK TABLES `api_profile` WRITE;
/*!40000 ALTER TABLE `api_profile` DISABLE KEYS */;
INSERT INTO `api_profile` VALUES (1,10847179,'Mr','0547208905',16,3,12,1,'male'),(2,10888888,'Mr','0249256380',NULL,5,3,0,'male'),(4,10814014,'Mr','0545441848',NULL,7,4,1,'male'),(5,10987667,'Dr','0545430098',4,3,5,0,'male'),(6,10465876,'Miss','0556787775',NULL,5,2,1,'female'),(7,10658905,'Mr','0277790433',NULL,5,10,0,'male'),(8,10978876,'Dr','0545441848',25,7,9,1,'male'),(9,10555555,'Mrs','0546789876',1,7,13,0,'female'),(10,10989898,'Dr','0245672345',NULL,3,14,1,'male'),(13,10222222,'Mrs','0245678904',NULL,7,19,0,'male'),(14,10987890,'Dr','0245676543',5,5,20,0,'male'),(17,10814015,'Mr.','+233545441849',NULL,22,23,0,'male'),(18,10814016,'Mrs.','0545441810',31,21,24,0,'female'),(21,10814019,'Mr','0244453710',NULL,7,27,0,'male'),(22,10814020,'Mr','0302773030',29,4,28,0,'male'),(24,10814022,'Mrs','0246725060',23,24,30,0,'female'),(25,10814023,'Mr','0302775878',33,23,31,0,'male'),(27,10814025,'Mrs','0352622095',3,21,33,0,'female'),(28,10814026,'Miss','0246905879',22,5,34,0,'female'),(29,10814027,'Mrs','0277682215',28,4,35,0,'female'),(30,10814028,'Dr','0244453710',20,7,36,0,'male'),(32,10814013,'Miss','0244453710',8,23,38,0,'female'),(34,10814011,'Mr','0244853516',9,24,40,0,'male'),(36,10814031,'Mr','0302760578',24,22,42,0,'male'),(37,10333333,'Mr','0546788765',27,4,43,1,'male'),(38,10814099,'Dr','0547896321',26,7,44,0,'male'),(40,10800000,'Mrs','0247896542',21,23,46,0,'female'),(41,10839284,'Dr.','+233558151870',NULL,22,47,0,'male');
/*!40000 ALTER TABLE `api_profile` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `api_rank`
--

DROP TABLE IF EXISTS `api_rank`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `api_rank` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `api_rank_name_1afe46e6_uniq` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `api_rank`
--

LOCK TABLES `api_rank` WRITE;
/*!40000 ALTER TABLE `api_rank` DISABLE KEYS */;
INSERT INTO `api_rank` VALUES (22,'Adjunct Professor'),(21,'Assistant Professor'),(5,'Associate Professor'),(7,'Emeritus Professor'),(4,'Professor'),(24,'Research Professor'),(3,'Senior Lecturer'),(23,'Visiting Professor');
/*!40000 ALTER TABLE `api_rank` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `api_version`
--

DROP TABLE IF EXISTS `api_version`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `api_version` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `version_number` int unsigned NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `document_id` bigint NOT NULL,
  `changes` longtext NOT NULL DEFAULT (_utf8mb3'h'),
  `changed_by_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `api_version_document_id_99c9d199_fk_api_document_id` (`document_id`),
  KEY `api_version_changed_by_id_37fe3957_fk_auth_user_id` (`changed_by_id`),
  CONSTRAINT `api_version_changed_by_id_37fe3957_fk_auth_user_id` FOREIGN KEY (`changed_by_id`) REFERENCES `auth_user` (`id`),
  CONSTRAINT `api_version_document_id_99c9d199_fk_api_document_id` FOREIGN KEY (`document_id`) REFERENCES `api_document` (`id`),
  CONSTRAINT `api_version_chk_1` CHECK ((`version_number` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=86 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `api_version`
--

LOCK TABLES `api_version` WRITE;
/*!40000 ALTER TABLE `api_version` DISABLE KEYS */;
INSERT INTO `api_version` VALUES (35,1,'2023-08-27 20:52:00.490267',81,'Initial Upload',12),(38,1,'2023-08-27 21:31:36.645623',84,'Initial Upload',12),(40,1,'2023-08-27 23:39:39.488886',86,'Initial Upload',43),(41,1,'2023-08-27 23:39:42.144003',87,'Initial Upload',43),(43,1,'2023-08-28 05:35:15.338094',89,'Initial Upload',12),(44,1,'2023-08-28 05:40:35.704859',90,'Initial Upload',12),(45,1,'2023-08-28 05:52:09.399581',91,'Initial Upload',12),(46,1,'2023-08-28 05:55:00.641401',92,'Initial Upload',12),(48,1,'2023-08-28 06:06:22.503915',94,'Initial Upload',12),(49,1,'2023-08-28 06:17:26.993302',95,'Initial Upload',12),(55,1,'2023-08-28 07:28:00.386090',101,'Initial Upload',12),(56,1,'2023-08-28 07:33:14.100768',102,'Initial Upload',12),(84,1,'2023-08-28 15:30:17.626180',117,'Initial Upload',12),(85,2,'2023-08-28 15:31:37.173845',117,'doc',12);
/*!40000 ALTER TABLE `api_version` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group`
--

DROP TABLE IF EXISTS `auth_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group`
--

LOCK TABLES `auth_group` WRITE;
/*!40000 ALTER TABLE `auth_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group_permissions`
--

DROP TABLE IF EXISTS `auth_group_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group_permissions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `group_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group_permissions`
--

LOCK TABLES `auth_group_permissions` WRITE;
/*!40000 ALTER TABLE `auth_group_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_permission`
--

DROP TABLE IF EXISTS `auth_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_permission` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=81 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add log entry',1,'add_logentry'),(2,'Can change log entry',1,'change_logentry'),(3,'Can delete log entry',1,'delete_logentry'),(4,'Can view log entry',1,'view_logentry'),(5,'Can add permission',2,'add_permission'),(6,'Can change permission',2,'change_permission'),(7,'Can delete permission',2,'delete_permission'),(8,'Can view permission',2,'view_permission'),(9,'Can add group',3,'add_group'),(10,'Can change group',3,'change_group'),(11,'Can delete group',3,'delete_group'),(12,'Can view group',3,'view_group'),(13,'Can add user',4,'add_user'),(14,'Can change user',4,'change_user'),(15,'Can delete user',4,'delete_user'),(16,'Can view user',4,'view_user'),(17,'Can add content type',5,'add_contenttype'),(18,'Can change content type',5,'change_contenttype'),(19,'Can delete content type',5,'delete_contenttype'),(20,'Can view content type',5,'view_contenttype'),(21,'Can add session',6,'add_session'),(22,'Can change session',6,'change_session'),(23,'Can delete session',6,'delete_session'),(24,'Can view session',6,'view_session'),(25,'Can add position',7,'add_position'),(26,'Can change position',7,'change_position'),(27,'Can delete position',7,'delete_position'),(28,'Can view position',7,'view_position'),(29,'Can add rank',8,'add_rank'),(30,'Can change rank',8,'change_rank'),(31,'Can delete rank',8,'delete_rank'),(32,'Can view rank',8,'view_rank'),(33,'Can add document',9,'add_document'),(34,'Can change document',9,'change_document'),(35,'Can delete document',9,'delete_document'),(36,'Can view document',9,'view_document'),(37,'Can add notification',10,'add_notification'),(38,'Can change notification',10,'change_notification'),(39,'Can delete notification',10,'delete_notification'),(40,'Can view notification',10,'view_notification'),(41,'Can add comment',11,'add_comment'),(42,'Can change comment',11,'change_comment'),(43,'Can delete comment',11,'delete_comment'),(44,'Can view comment',11,'view_comment'),(45,'Can add audit log',12,'add_auditlog'),(46,'Can change audit log',12,'change_auditlog'),(47,'Can delete audit log',12,'delete_auditlog'),(48,'Can view audit log',12,'view_auditlog'),(49,'Can add access request',13,'add_accessrequest'),(50,'Can change access request',13,'change_accessrequest'),(51,'Can delete access request',13,'delete_accessrequest'),(52,'Can view access request',13,'view_accessrequest'),(53,'Can add approval',14,'add_approval'),(54,'Can change approval',14,'change_approval'),(55,'Can delete approval',14,'delete_approval'),(56,'Can view approval',14,'view_approval'),(57,'Can add profile',15,'add_profile'),(58,'Can change profile',15,'change_profile'),(59,'Can delete profile',15,'delete_profile'),(60,'Can view profile',15,'view_profile'),(61,'Can add version',16,'add_version'),(62,'Can change version',16,'change_version'),(63,'Can delete version',16,'delete_version'),(64,'Can view version',16,'view_version'),(65,'Can add category',17,'add_category'),(66,'Can change category',17,'change_category'),(67,'Can delete category',17,'delete_category'),(68,'Can view category',17,'view_category'),(69,'Can add permission',18,'add_permission'),(70,'Can change permission',18,'change_permission'),(71,'Can delete permission',18,'delete_permission'),(72,'Can view permission',18,'view_permission'),(73,'Can add Token',19,'add_token'),(74,'Can change Token',19,'change_token'),(75,'Can delete Token',19,'delete_token'),(76,'Can view Token',19,'view_token'),(77,'Can add token',20,'add_tokenproxy'),(78,'Can change token',20,'change_tokenproxy'),(79,'Can delete token',20,'delete_tokenproxy'),(80,'Can view token',20,'view_tokenproxy');
/*!40000 ALTER TABLE `auth_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user`
--

DROP TABLE IF EXISTS `auth_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user`
--

LOCK TABLES `auth_user` WRITE;
/*!40000 ALTER TABLE `auth_user` DISABLE KEYS */;
INSERT INTO `auth_user` VALUES (2,'pbkdf2_sha256$390000$fMVncCqbasfWtndbVRfzfd$c6KMUgRzjzDmC4HB3X9MxTYelNnPd5E2xQGZZhH47DQ=',NULL,0,'JanPrince','Prince','Djan','pjan@dcs.com',0,1,'2023-06-15 21:18:19.000000'),(3,'pbkdf2_sha256$390000$KoQ27FMvvO2T6m9ZzkfAeL$8Y2QASO2rXL6uCFq/pTemo0C19H6FoXgRbi5o6rLsoM=',NULL,0,'LeoSam','Leonard','Sam','lsam@dcs.com',0,1,'2023-06-15 21:18:50.000000'),(4,'pbkdf2_sha256$390000$KRzdocQ4Ec9GWB3rECazkH$lNx2lSFOx12OhNxkCH2tAFbgm0BH/pNvEH+zWe/El4M=',NULL,0,'Miles','Miles','Morales','m.morales@gmail.com',0,1,'2023-06-15 21:19:16.000000'),(5,'pbkdf2_sha256$390000$R27RaqBmckfhFkBOcjsLgc$JPGLk3INkCCshx7+sHzxU7iXj5ha9X0hbYbRXwGYMDM=',NULL,0,'Kingsley','Kingsley','Acquah','k.acquah@dcs.com',0,1,'2023-06-15 21:23:12.000000'),(9,'pbkdf2_sha256$390000$7onpx8XprQvm1kn4uHPJ5O$t+Q1VkeTIOSm/KACVd/6G8SyJd1WV/FTJ72IUUrugIk=',NULL,0,'N.Yaw','Solomon','Nnyamile','synnyamile@st.ug.edu.gh',0,1,'2023-06-15 21:24:36.000000'),(10,'pbkdf2_sha256$390000$UwVGLbmwvYImkxDxlq9APV$Rdmc/5LQZMNW/Il1X+zpAahk+W7gb7JpyGItxsraoM4=',NULL,0,'Derrick','Derrick','Marfo','dmarfo@dcs.com',0,1,'2023-06-15 21:24:55.000000'),(12,'pbkdf2_sha256$390000$jFdTLo5br9gYoFB3JN6glN$XkygCLZkjYgFJL74Epq7mpSwNo6I75cVJ1Wz9bHHWlY=',NULL,0,'samuel','Samuel','Sackey','smlscky@gmail.com',0,1,'2023-06-16 02:30:27.000000'),(13,'pbkdf2_sha256$390000$myHCkBVDXS7JDLgpbGDoGr$QwizZpzwkzgpoW6srwF+i598mDhoWzhYB424EE9LVD8=',NULL,0,'marilyn.sohah97','Marilyn','Preprah','ssackey023@st.ug.edu.gh',0,1,'2023-06-18 13:43:19.000000'),(14,'pbkdf2_sha256$390000$DDUox4QcFpAEntXN5POL32$01RZTNpBeZxQOZmc8vdE3BDsxlb1xJKVxCJvSp3IPB4=',NULL,0,'kofi.adu54','Kofi','Addo','kofi.adu@dcs.com',0,1,'2023-06-18 13:46:20.720885'),(19,'pbkdf2_sha256$390000$jULdeg4KbeA9dayr1n5SUG$OtdX7zTOFEEpetftMNOu9CxLR65mycIHDGpaQc33AwY=',NULL,0,'test.tester48','test','tester','test@test.com',0,1,'2023-06-19 18:12:49.811517'),(20,'pbkdf2_sha256$390000$kpWfEB74BbdYNUPiyFclXa$PpdrylNDnuRH/2OB9tCBGQhycKUfXyqj4xVmuCiY22w=',NULL,0,'kelvin.dokodi61','Kelvin','Dokodi','d.dokes@dcs.com',0,1,'2023-06-21 16:01:05.588942'),(23,'pbkdf2_sha256$390000$yrjuNmzzLQmHl3PdsZqZEk$CI+pCyLB1FoNYKa9r6b8TfCVLe1dt6mI32wJ7GjWdTg=',NULL,0,'Piten1994','Connie','Race','ConniePRace@armyspy.com',0,1,'2023-08-19 15:59:21.000000'),(24,'pbkdf2_sha256$390000$4N8jNwZNH6QqmGp0yqT97r$RtJnbwt5IsQQOnr4vZeftbS1mmjz+B6hR6vKwcZmwmY=',NULL,0,'Histitandul','Husan','Duanful','Histitandul@gmail.com',0,1,'2023-08-19 18:05:36.000000'),(25,'pbkdf2_sha256$390000$oUlIpJZ439fVIsQzvl5vTP$zyYaDgDtL1LRfn4JVTl7XgRY9lzqalFgvgN08IMJLXE=',NULL,0,'Witich','Jerry','Moxley','JerryAMoxley@jourrapide.com',0,1,'2023-08-19 18:14:53.000000'),(26,'pbkdf2_sha256$390000$WRzHip44dmCxfkxlGnucFT$IE7vcFOcl8RWAjvtAA2ca5g5IEdK0GoLxyBtWq/TBSQ=',NULL,0,'Towled','Peter','Oliver','PeterCOliver@armyspy.com',0,1,'2023-08-19 18:21:05.000000'),(27,'pbkdf2_sha256$390000$Midvzd1IgYpySUAa9Tcxet$GKHUiQQcCd3bOTwbRCJKGbpk/d8aPxDeAd67ZbvkWSE=',NULL,0,'Bantais','Donald','Donald','DonaldMPlank@dayrep.com',0,1,'2023-08-19 18:26:16.000000'),(28,'pbkdf2_sha256$390000$cLyw6lF6RRx5x8lcsOjmNC$sptUGhFC0MefBajG1wT4R0XdI5JVehNUaVzJqQlLzZ4=',NULL,0,'Sawas1971','Na','Ting','NaTing@jourrapide.com',0,1,'2023-08-19 18:31:49.000000'),(29,'pbkdf2_sha256$390000$tO6QelKmNC1CmxaZTmiaKE$EvhGIBjruGKXXdlKBQ/Ftug06fO89UooI/EWFwVxzNQ=',NULL,0,'Succurs','Julian','Costa','JulianBarbosaCosta@teleworm.us',0,1,'2023-08-19 18:35:16.000000'),(30,'pbkdf2_sha256$390000$GjdnRMp0cTMQ6ZniJCccap$vtI/k4UC/08jAL99qbHNJ7PgFiort4thLZ0VMvm9cAM=',NULL,0,'Joaroarry03','Alambek','Kadyrov','AlambekKadyrov@rhyta.com',0,1,'2023-08-19 18:37:10.000000'),(31,'pbkdf2_sha256$390000$UXOihoOu94ZRC082oVoU8w$Vx2I7cgNU/BvqPd7jY4fOa/I3C5guwYXHFB/u2fIGfU=',NULL,0,'Sibacted60','Dragan','Jukić','DraganJukic@armyspy.com',0,1,'2023-08-19 18:42:12.000000'),(32,'pbkdf2_sha256$390000$5VoAGGjqH48aZcgRiPg39P$E4OIGz3ZKjaQbpYLFWMCQZdzympwOUNRDfyBn9kNPPQ=',NULL,0,'Yall2001','Dorothy','Thompson','DorothyJThompson@jourrapide.com',0,1,'2023-08-19 18:43:34.000000'),(33,'pbkdf2_sha256$390000$XqagQvxT86Mit1g8k3LI9o$ijmkazkx9Ke2J/LPVXv8MSINvqQkMRExPzePVGdXIEA=',NULL,0,'Clar1938','Brenda','Clukey','BrendaFClukey@jourrapide.com',0,1,'2023-08-19 18:47:45.000000'),(34,'pbkdf2_sha256$390000$Ym4NMQfW8Z4n6cjIBly7Om$Jt2i/9vKnJM31DDkyPs4vFw2cr6B47ShUEDVLtQSK5c=',NULL,0,'Sealithed','Olive','Johnson','OliveJJohnson@rhyta.com',0,1,'2023-08-19 18:52:33.000000'),(35,'pbkdf2_sha256$390000$aZ0b2CzGFnIrIo0Gc9H58I$GnDylYKAz6tr3Jn1KiRzb+pFQKEklJXc+/iDyFwjL5o=',NULL,0,'Craireir','Sherrill','Ward','SherrillLWard@dayrep.com',0,1,'2023-08-20 05:38:09.000000'),(36,'pbkdf2_sha256$390000$3spGhyO53g2QThLeY4uP4Y$jc29xkUywSSQQKmdu4Rj+V2T73C4dR3pNOsFrLCgNrg=',NULL,0,'Coudifter2004','Clifford','Kenney','CliffordLKenney@armyspy.com',0,1,'2023-08-20 05:43:30.000000'),(38,'pbkdf2_sha256$390000$0pRYLxXjR5dkQntstuV5x6$I2W8HGJDjqmzJzIXtIArvWU3O9Nu4iImsA7q+AeA0tE=',NULL,0,'Reatunat','Daisy','Elliott','DaisyElliott@dayrep.com',0,1,'2023-08-20 05:55:00.000000'),(40,'pbkdf2_sha256$390000$QwfrBt82UkrYC78605fOG6$a0vURKRVGoLjyZZWUxW0vmWWsh2L8U7R37SPFrQmxpI=',NULL,0,'Mothasaim','Arnaud','Cuillerier','ArnaudCuillerier@rhyta.com',0,1,'2023-08-20 06:05:10.000000'),(41,'pbkdf2_sha256$390000$zGNc2kCypm8RXpk2rtw9Wq$yHEX7tf9FmQ5L0p4cq7WvK+ul+RpYGVqaBRgoEEQqXU=',NULL,0,'Bastoofter','Eric','Meyer','EricMeyer@armyspy.com',0,1,'2023-08-20 06:10:41.000000'),(42,'pbkdf2_sha256$390000$sqiwUtu9TLP5AqUanaNrHo$RoDS/XDmzunnCtnehpYoNWX24N91nuVSTv5ShfgYZgY=',NULL,0,'Thiciathy','Kosisochukwu','Tobeolisa','KosisochukwuTobeolisa@jourrapide.com',0,1,'2023-08-20 06:15:57.000000'),(43,'pbkdf2_sha256$390000$LiQ4UAc9S2c1RiKTCzVsFd$cneCcM50LGkvsYlMJvahtPIiUbLmgGna2Un+uGWCoug=','2023-08-28 10:23:51.596093',1,'admin1','Master','Admin','j@gmial.com',1,1,'2023-08-22 02:33:42.000000'),(44,'pbkdf2_sha256$390000$UKbRAKfkm4g1NcalsC14Xu$rawcEP+4R4KpcZjeAs6l0Nal3njBi+BUXZTpSQRsvsI=',NULL,0,'lewis.capaldi57','Lewis','Capaldi','lewi@st.ug.edu.gh',0,1,'2023-08-27 10:02:04.265257'),(46,'pbkdf2_sha256$390000$RO8UxrMiZLfXM2sJKHJe49$teykzUyikv+MLqOPIAruZGDhyhayJUwxl+JkuJC5QDw=',NULL,0,'mith','Mayer','Bobla','mitch@st.ug.edu.gh',0,1,'2023-08-28 05:55:58.000000'),(47,'pbkdf2_sha256$390000$Q0vlPLBDanxF2Hog9OXUvQ$zVaZHXOedzYzbustD2luFZoQGAxec2YFalWb7Fdj8TE=',NULL,0,'PrinceJan','Prince','Jan','janprince002@gmail.com',0,1,'2023-08-28 12:05:30.000000');
/*!40000 ALTER TABLE `auth_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_groups`
--

DROP TABLE IF EXISTS `auth_user_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user_groups` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `group_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_groups_user_id_group_id_94350c0c_uniq` (`user_id`,`group_id`),
  KEY `auth_user_groups_group_id_97559544_fk_auth_group_id` (`group_id`),
  CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_groups`
--

LOCK TABLES `auth_user_groups` WRITE;
/*!40000 ALTER TABLE `auth_user_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_user_permissions`
--

DROP TABLE IF EXISTS `auth_user_user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user_user_permissions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq` (`user_id`,`permission_id`),
  KEY `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_user_permissions`
--

LOCK TABLES `auth_user_user_permissions` WRITE;
/*!40000 ALTER TABLE `auth_user_user_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_user_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `authtoken_token`
--

DROP TABLE IF EXISTS `authtoken_token`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `authtoken_token` (
  `key` varchar(40) NOT NULL,
  `created` datetime(6) NOT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`key`),
  UNIQUE KEY `user_id` (`user_id`),
  CONSTRAINT `authtoken_token_user_id_35299eff_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `authtoken_token`
--

LOCK TABLES `authtoken_token` WRITE;
/*!40000 ALTER TABLE `authtoken_token` DISABLE KEYS */;
INSERT INTO `authtoken_token` VALUES ('0ef3de8290554204823615fe8a991e97e4fcba09','2023-08-23 17:06:15.395524',20),('193746528b7741bb9984a5f50d336cf1f2f358e6','2023-06-16 02:40:50.384287',12),('4f635cc760e6dd53859f0c461f59a0b65ea57521','2023-08-21 10:24:35.827772',13),('8d795a5d7a42527aa97d2caaee6aa72bb77fe3af','2023-06-27 18:26:24.451385',19),('ae4d9d30e8b3af428054a5c942d6580c62e8ab83','2023-08-22 14:41:37.560480',43),('cd64cbde5178c6a7a45957536e9a23e0ba55ee94','2023-08-21 08:20:00.226782',30),('f6a7f337c4ce9ab7a0c4b6513ddd819ad19ace9d','2023-08-27 23:40:38.673698',42);
/*!40000 ALTER TABLE `authtoken_token` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_admin_log`
--

DROP TABLE IF EXISTS `django_admin_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_admin_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint unsigned NOT NULL,
  `change_message` longtext NOT NULL,
  `content_type_id` int DEFAULT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6_fk_auth_user_id` (`user_id`),
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`),
  CONSTRAINT `django_admin_log_chk_1` CHECK ((`action_flag` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=264 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_admin_log`
--

LOCK TABLES `django_admin_log` WRITE;
/*!40000 ALTER TABLE `django_admin_log` DISABLE KEYS */;
INSERT INTO `django_admin_log` VALUES (183,'2023-08-22 12:21:27.093054','5','Comment: srufhe fes...',2,'[{\"changed\": {\"fields\": [\"Text\"]}}]',11,43),(184,'2023-08-22 14:41:37.564592','43','ae4d9d30e8b3af428054a5c942d6580c62e8ab83',1,'[{\"added\": {}}]',20,43),(185,'2023-08-22 14:43:49.758314','37','admin1',1,'[{\"added\": {}}]',15,43),(186,'2023-08-23 11:59:52.522059','7','Derrick',2,'[{\"changed\": {\"fields\": [\"Position\"]}}]',15,43),(187,'2023-08-23 12:00:02.187317','8','N.Yaw',2,'[{\"changed\": {\"fields\": [\"Position\"]}}]',15,43),(188,'2023-08-23 12:00:14.439203','34','Mothasaim',2,'[{\"changed\": {\"fields\": [\"Position\"]}}]',15,43),(189,'2023-08-23 12:00:24.254975','9','marilyn.sohah97',2,'[{\"changed\": {\"fields\": [\"Position\"]}}]',15,43),(190,'2023-08-23 12:00:32.170767','22','Sawas1971',2,'[{\"changed\": {\"fields\": [\"Position\"]}}]',15,43),(191,'2023-08-23 12:00:40.510165','31','Riess2000',2,'[{\"changed\": {\"fields\": [\"Position\"]}}]',15,43),(192,'2023-08-23 12:00:47.435011','10','kofi.adu54',2,'[{\"changed\": {\"fields\": [\"Position\"]}}]',15,43),(193,'2023-08-23 12:00:56.596006','6','JanPrince',2,'[]',15,43),(194,'2023-08-23 12:01:04.089871','6','JanPrince',2,'[{\"changed\": {\"fields\": [\"Position\"]}}]',15,43),(195,'2023-08-23 12:01:12.127249','21','Bantais',2,'[{\"changed\": {\"fields\": [\"Position\"]}}]',15,43),(196,'2023-08-23 12:01:21.664319','2','LeoSam',2,'[{\"changed\": {\"fields\": [\"Position\"]}}]',15,43),(197,'2023-08-23 12:01:29.398922','25','Sibacted60',2,'[{\"changed\": {\"fields\": [\"Position\"]}}]',15,43),(198,'2023-08-23 12:01:42.182982','20','Towled',2,'[{\"changed\": {\"fields\": [\"Position\"]}}]',15,43),(199,'2023-08-23 12:01:52.319437','4','Miles',2,'[{\"changed\": {\"fields\": [\"Position\"]}}]',15,43),(200,'2023-08-23 12:01:59.801970','30','Coudifter2004',2,'[{\"changed\": {\"fields\": [\"Position\"]}}]',15,43),(201,'2023-08-23 12:02:07.434200','33','Wasuacts',2,'[{\"changed\": {\"fields\": [\"Position\"]}}]',15,43),(202,'2023-08-23 12:02:18.739684','17','Piten1994',2,'[{\"changed\": {\"fields\": [\"Position\"]}}]',15,43),(203,'2023-08-23 17:06:15.397051','20','0ef3de8290554204823615fe8a991e97e4fcba09',1,'[{\"added\": {}}]',20,43),(204,'2023-08-23 17:19:29.011209','46','dghjsd',1,'[{\"added\": {}}]',9,43),(205,'2023-08-23 17:21:07.773005','46','dghjsd',2,'[{\"changed\": {\"fields\": [\"Update access\"]}}]',9,43),(206,'2023-08-24 19:15:45.073066','32','You have b',3,'',10,43),(207,'2023-08-24 19:15:45.087240','31','You have b',3,'',10,43),(208,'2023-08-24 19:15:45.094750','30','You have b',3,'',10,43),(209,'2023-08-24 19:15:45.103516','29','You have b',3,'',10,43),(210,'2023-08-24 19:15:45.112827','28','You have b',3,'',10,43),(211,'2023-08-24 19:15:45.120072','27','You have b',3,'',10,43),(212,'2023-08-24 19:15:45.127345','26','You have b',3,'',10,43),(213,'2023-08-24 19:15:45.134115','23','You have b',3,'',10,43),(214,'2023-08-24 19:15:45.141019','22','You have b',3,'',10,43),(215,'2023-08-24 19:15:45.154427','21','You have b',3,'',10,43),(216,'2023-08-24 19:15:45.159822','20','You have b',3,'',10,43),(217,'2023-08-24 19:15:45.166449','19','You have b',3,'',10,43),(218,'2023-08-24 19:15:45.172951','18','You have b',3,'',10,43),(219,'2023-08-24 19:15:45.179388','17','You have b',3,'',10,43),(220,'2023-08-24 19:15:45.186575','16','You have b',3,'',10,43),(221,'2023-08-24 19:15:45.192578','15','You have b',3,'',10,43),(222,'2023-08-24 19:15:45.199083','14','You have b',3,'',10,43),(223,'2023-08-24 19:15:45.205855','13','You have b',3,'',10,43),(224,'2023-08-24 19:15:45.212908','12','You have b',3,'',10,43),(225,'2023-08-24 19:15:45.226460','11','You have b',3,'',10,43),(226,'2023-08-24 19:15:45.237181','8','You have b',3,'',10,43),(227,'2023-08-24 19:15:45.244130','7','You have b',3,'',10,43),(228,'2023-08-24 19:15:45.250839','6','You have b',3,'',10,43),(229,'2023-08-24 19:15:45.257542','5','You have b',3,'',10,43),(230,'2023-08-24 19:18:03.907680','34','You have b',3,'',10,43),(231,'2023-08-24 19:18:03.915659','33','You have b',3,'',10,43),(232,'2023-08-24 19:28:12.865001','35','qwerty',1,'[{\"added\": {}}]',10,43),(233,'2023-08-24 19:30:38.211764','37','qwert',1,'[{\"added\": {}}]',10,43),(234,'2023-08-24 22:41:37.632657','12','samuel',2,'[{\"changed\": {\"fields\": [\"Email address\"]}}]',4,43),(235,'2023-08-24 23:28:42.055878','12','samuel',2,'[{\"changed\": {\"fields\": [\"Email address\"]}}]',4,43),(236,'2023-08-25 00:10:53.386453','47','place',2,'[{\"changed\": {\"fields\": [\"Read access\"]}}]',9,43),(237,'2023-08-25 00:13:19.520133','47','place',2,'[{\"changed\": {\"fields\": [\"Read access\"]}}]',9,43),(238,'2023-08-25 06:44:08.724834','12','samuel',2,'[{\"changed\": {\"fields\": [\"Email address\"]}}]',4,43),(239,'2023-08-25 06:44:54.006143','9','N.Yaw',2,'[{\"changed\": {\"fields\": [\"Email address\"]}}]',4,43),(240,'2023-08-25 06:45:25.059199','24','Histitandul',2,'[{\"changed\": {\"fields\": [\"Last name\"]}}]',4,43),(241,'2023-08-25 06:46:50.750291','43','admin1',2,'[{\"changed\": {\"fields\": [\"First name\", \"Last name\"]}}]',4,43),(242,'2023-08-27 23:40:38.675071','42','f6a7f337c4ce9ab7a0c4b6513ddd819ad19ace9d',1,'[{\"added\": {}}]',20,43),(243,'2023-08-27 23:41:14.936052','42','Thiciathy',2,'[{\"changed\": {\"fields\": [\"password\"]}}]',4,43),(244,'2023-08-28 05:55:58.705389','46','mith',1,'[{\"added\": {}}]',4,43),(245,'2023-08-28 05:56:52.033396','46','mith',2,'[{\"changed\": {\"fields\": [\"First name\", \"Last name\", \"Email address\"]}}]',4,43),(246,'2023-08-28 05:59:58.525437','40','mith',1,'[{\"added\": {}}]',15,43),(247,'2023-08-28 10:24:23.552037','13','marilyn.sohah97',2,'[{\"changed\": {\"fields\": [\"Email address\"]}}]',4,43),(248,'2023-08-28 11:54:59.068156','30','Coudifter2004',2,'[{\"changed\": {\"fields\": [\"Position\"]}}]',15,43),(249,'2023-08-28 11:55:50.508705','40','mith',2,'[{\"changed\": {\"fields\": [\"Position\"]}}]',15,43),(250,'2023-08-28 11:56:18.379002','25','Sibacted60',2,'[{\"changed\": {\"fields\": [\"Position\"]}}]',15,43),(251,'2023-08-28 11:56:59.410965','22','Sawas1971',2,'[{\"changed\": {\"fields\": [\"Position\"]}}]',15,43),(252,'2023-08-28 12:05:30.869467','47','PrinceJan',1,'[{\"added\": {}}]',4,43),(253,'2023-08-28 12:05:44.348757','47','PrinceJan',2,'[{\"changed\": {\"fields\": [\"Email address\"]}}]',4,43),(254,'2023-08-28 12:06:25.734935','41','PrinceJan',1,'[{\"added\": {}}]',15,43),(255,'2023-08-28 12:08:43.459854','47','PrinceJan',2,'[{\"changed\": {\"fields\": [\"First name\", \"Last name\"]}}]',4,43),(256,'2023-09-02 11:26:31.819829','79','staff access',3,'',9,43),(257,'2023-09-02 11:26:31.843524','65','exel?',3,'',9,43),(258,'2023-09-02 11:26:31.858309','18','does it work?',3,'',9,43),(259,'2023-09-02 11:26:31.874789','16','Test',3,'',9,43),(260,'2023-09-02 11:27:15.182629','35','Bastoofter',3,'',15,43),(261,'2023-09-02 11:27:15.198861','23','Succurs',3,'',15,43),(262,'2023-09-02 11:27:15.214044','19','Witich',3,'',15,43),(263,'2023-09-02 11:28:44.834035','20','Towled',3,'',15,43);
/*!40000 ALTER TABLE `django_admin_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_content_type`
--

DROP TABLE IF EXISTS `django_content_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_content_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (1,'admin','logentry'),(13,'api','accessrequest'),(14,'api','approval'),(12,'api','auditlog'),(17,'api','category'),(11,'api','comment'),(9,'api','document'),(10,'api','notification'),(18,'api','permission'),(7,'api','position'),(15,'api','profile'),(8,'api','rank'),(16,'api','version'),(3,'auth','group'),(2,'auth','permission'),(4,'auth','user'),(19,'authtoken','token'),(20,'authtoken','tokenproxy'),(5,'contenttypes','contenttype'),(6,'sessions','session');
/*!40000 ALTER TABLE `django_content_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_migrations`
--

DROP TABLE IF EXISTS `django_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_migrations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=58 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES (1,'contenttypes','0001_initial','2023-06-14 21:23:45.034564'),(2,'auth','0001_initial','2023-06-14 21:23:46.055291'),(3,'admin','0001_initial','2023-06-14 21:23:46.283208'),(4,'admin','0002_logentry_remove_auto_add','2023-06-14 21:23:46.297959'),(5,'admin','0003_logentry_add_action_flag_choices','2023-06-14 21:23:46.312851'),(6,'contenttypes','0002_remove_content_type_name','2023-06-14 21:23:46.432830'),(7,'api','0001_initial','2023-06-14 21:23:46.914505'),(8,'api','0002_documentcategory_alter_userprofile_phone','2023-06-14 21:23:46.966085'),(9,'api','0003_document_alter_userprofile_phone_and_more','2023-06-14 21:23:48.043128'),(10,'api','0004_remove_document_approved_document_status','2023-06-14 21:23:48.179730'),(11,'api','0005_accessrequest_approval_profile_version_and_more','2023-06-14 21:23:49.912004'),(12,'api','0006_category','2023-06-14 21:23:49.965710'),(13,'api','0007_document_category','2023-06-14 21:23:50.117847'),(14,'api','0008_rename_documentaccess_permission','2023-06-14 21:23:50.202517'),(15,'api','0009_alter_permission_unique_together','2023-06-14 21:23:50.334994'),(16,'api','0010_alter_permission_user','2023-06-14 21:23:50.360107'),(17,'api','0011_alter_permission_document','2023-06-14 21:23:50.380699'),(18,'api','0012_alter_profile_position_alter_profile_rank','2023-06-14 21:23:50.415872'),(19,'api','0013_profile_is_admin','2023-06-14 21:23:50.482793'),(20,'api','0014_alter_profile_staff_id_alter_profile_title','2023-06-14 21:23:50.513847'),(21,'api','0015_alter_profile_staff_id','2023-06-14 21:23:50.565265'),(22,'auth','0002_alter_permission_name_max_length','2023-06-14 21:23:50.671439'),(23,'auth','0003_alter_user_email_max_length','2023-06-14 21:23:50.799031'),(24,'auth','0004_alter_user_username_opts','2023-06-14 21:23:50.821919'),(25,'auth','0005_alter_user_last_login_null','2023-06-14 21:23:50.922424'),(26,'auth','0006_require_contenttypes_0002','2023-06-14 21:23:50.931174'),(27,'auth','0007_alter_validators_add_error_messages','2023-06-14 21:23:50.954694'),(28,'auth','0008_alter_user_username_max_length','2023-06-14 21:23:51.087343'),(29,'auth','0009_alter_user_last_name_max_length','2023-06-14 21:23:51.193596'),(30,'auth','0010_alter_group_name_max_length','2023-06-14 21:23:51.299617'),(31,'auth','0011_update_proxy_permissions','2023-06-14 21:23:51.322218'),(32,'auth','0012_alter_user_first_name_max_length','2023-06-14 21:23:51.445869'),(33,'authtoken','0001_initial','2023-06-14 21:23:51.599319'),(34,'authtoken','0002_auto_20160226_1747','2023-06-14 21:23:51.719546'),(35,'authtoken','0003_tokenproxy','2023-06-14 21:23:51.728645'),(36,'sessions','0001_initial','2023-06-14 21:23:51.797364'),(37,'api','0016_alter_profile_rank_alter_profile_staff_id','2023-06-15 21:36:17.207120'),(38,'api','0017_alter_position_name_alter_rank_name','2023-06-16 18:35:52.144692'),(39,'api','0018_profile_gender','2023-06-18 04:33:16.752167'),(40,'api','0019_alter_document_category_alter_document_uploaded_by_and_more','2023-06-19 15:47:38.669126'),(41,'api','0020_alter_profile_position','2023-06-19 18:07:22.206793'),(42,'api','0021_remove_document_allowed_access_document_read_access_and_more','2023-06-21 09:31:07.045277'),(43,'api','0022_alter_document_read_access_and_more','2023-06-21 09:31:07.084548'),(44,'api','0023_remove_document_status_approval_approver_and_more','2023-06-21 09:31:08.259902'),(45,'api','0024_alter_document_options_and_more','2023-06-25 09:03:12.329763'),(46,'api','0025_notification_document','2023-08-21 19:40:04.393087'),(47,'api','0026_remove_notification_receiver_notification_receivers','2023-08-21 19:40:05.389394'),(48,'api','0027_remove_notification_receivers_notification_receiver','2023-08-21 19:40:05.724974'),(49,'api','0028_alter_profile_position','2023-08-23 12:02:39.310688'),(50,'api','0029_alter_document_position_access','2023-08-23 17:19:05.775878'),(51,'api','0030_alter_notification_message','2023-08-24 19:24:40.551032'),(52,'api','0031_alter_notification_message','2023-08-24 19:26:34.495765'),(53,'api','0032_alter_notification_unique_together','2023-08-24 19:27:44.623358'),(54,'api','0033_remove_version_file_version_changes','2023-08-26 22:33:22.588535'),(55,'api','0034_version_changed_by','2023-08-26 22:33:22.914321'),(56,'api','0035_rename_changes_auditlog_rationale','2023-08-27 10:51:09.176259'),(57,'api','0036_alter_document_file_type','2023-08-27 20:55:33.637069');
/*!40000 ALTER TABLE `django_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_session`
--

DROP TABLE IF EXISTS `django_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_session`
--

LOCK TABLES `django_session` WRITE;
/*!40000 ALTER TABLE `django_session` DISABLE KEYS */;
INSERT INTO `django_session` VALUES ('0irjjrci83spkj22tgj2gmium217qtju','.eJxVjMsOwiAQRf-FtSHAMFBduvcbmhkeUjWQlHZl_HdD0oVu7znnvsVM-1bmvad1XqK4CAvi9DsyhWeqg8QH1XuTodVtXVgORR60y1uL6XU93L-DQr2MGgGJIStvczCUNZ5hAsU4cdYRPVNCCsqx8sTRWG219gG086yM4yQ-XxFmOBI:1qaPNa:WDWKFpJlRqggbWahv6t-uNqLOD-ZJH4vGKrHyYmDW9E','2023-09-10 23:41:14.971077'),('2220y3nwgsbx1eaeklz251btl41xkbqk','.eJxVjDsOwjAQBe_iGlk2TmKbkj5niHb91iSAbCmfCnF3iJQC2jcz76UG2tZx2BaZhwnqoqw6_W5M6SFlB7hTuVWdalnnifWu6IMuuq-Q5_Vw_w5GWsZvLSEHZAJYoo9svAODu7aNJiRkECwbywH2TLlrODbOeXKpEeMRYdX7AycIOSU:1qIwOQ:zV_8EN9t_ho3ZhDqKE87A5KMpf_Hne0VxxQv2qnRGhw','2023-07-24 19:17:54.174417'),('5i1kvpdm3fq88s1efenpuwal61k5akmo','.eJxVjMsOwiAQRf-FtSHAMFBduvcbmhkeUjWQlHZl_HdD0oVu7znnvsVM-1bmvad1XqK4CAvi9DsyhWeqg8QH1XuTodVtXVgORR60y1uL6XU93L-DQr2MGgGJIStvczCUNZ5hAsU4cdYRPVNCCsqx8sTRWG219gG086yM4yQ-XxFmOBI:1qaDrW:YZ3AWvstU-xBvBp_iEzlpirDW9_lCQFLklKhFXlh9pQ','2023-09-10 11:23:22.361639'),('8ftaexxfupno6pdqv62idekw2glhrvzv','.eJxVjDsOwjAQBe_iGlk2TmKbkj5niHb91iSAbCmfCnF3iJQC2jcz76UG2tZx2BaZhwnqoqw6_W5M6SFlB7hTuVWdalnnifWu6IMuuq-Q5_Vw_w5GWsZvLSEHZAJYoo9svAODu7aNJiRkECwbywH2TLlrODbOeXKpEeMRYdX7AycIOSU:1qMIFV:kmQPBYgukwimlkOW0H99KJ6yPrCP4KgvSmRd_V9c87Q','2023-08-03 01:14:33.661856'),('98fhb0qto8d21vj8ccw96h6gj6rdme2h','.eJxVjDsOwjAQBe_iGlk2TmKbkj5niHb91iSAbCmfCnF3iJQC2jcz76UG2tZx2BaZhwnqoqw6_W5M6SFlB7hTuVWdalnnifWu6IMuuq-Q5_Vw_w5GWsZvLSEHZAJYoo9svAODu7aNJiRkECwbywH2TLlrODbOeXKpEeMRYdX7AycIOSU:1qEDNh:1oH4S-GfPiAfWy46UldWdzQ82aZuRLb5aR0IPrO9Wik','2023-07-11 18:25:37.356646'),('98jo8c5j0k0lofcw2ay4mq8hrx2m69gf','.eJxVjDsOwjAQBe_iGlk2TmKbkj5niHb91iSAbCmfCnF3iJQC2jcz76UG2tZx2BaZhwnqoqw6_W5M6SFlB7hTuVWdalnnifWu6IMuuq-Q5_Vw_w5GWsZvLSEHZAJYoo9svAODu7aNJiRkECwbywH2TLlrODbOeXKpEeMRYdX7AycIOSU:1qIwRd:ycSOuw4OwFBvCjErHx1vKJw8qDZS6PvvczxXuiRnh9c','2023-07-24 19:21:13.220955'),('dm42rgyoo2reddn84s29zw3thyeci45s','.eJxVjDsOwjAQBe_iGlk2TmKbkj5niHb91iSAbCmfCnF3iJQC2jcz76UG2tZx2BaZhwnqoqw6_W5M6SFlB7hTuVWdalnnifWu6IMuuq-Q5_Vw_w5GWsZvLSEHZAJYoo9svAODu7aNJiRkECwbywH2TLlrODbOeXKpEeMRYdX7AycIOSU:1qAfS4:wWeZNO4VhEGlLJ8Xx6U09tUUEpBv9bTkWFuxHXA9gjo','2023-07-01 23:35:28.588204'),('ehjak4bus6svau12t5n318jvpz0aqnw0','.eJxVjMsOwiAQRf-FtSHAMFBduvcbmhkeUjWQlHZl_HdD0oVu7znnvsVM-1bmvad1XqK4CAvi9DsyhWeqg8QH1XuTodVtXVgORR60y1uL6XU93L-DQr2MGgGJIStvczCUNZ5hAsU4cdYRPVNCCsqx8sTRWG219gG086yM4yQ-XxFmOBI:1qaCIT:W2Wez587JKBb0PeS_vZNSF-0_UHFCvpwpC6OKCdEAaE','2023-09-10 09:43:05.283701'),('jwj59hszvqm0l0elp0yofyc9giazuewd','.eJxVjDsOwjAQBe_iGlk2TmKbkj5niHb91iSAbCmfCnF3iJQC2jcz76UG2tZx2BaZhwnqoqw6_W5M6SFlB7hTuVWdalnnifWu6IMuuq-Q5_Vw_w5GWsZvLSEHZAJYoo9svAODu7aNJiRkECwbywH2TLlrODbOeXKpEeMRYdX7AycIOSU:1qY24d:gxvZdRhnUynl6-grktHHDLKMWM382hwuwuPBlMaRDfg','2023-09-04 10:23:51.414622'),('kn0tmqvdq5yvolz5zkx21rytu2bcymjs','.eJxVjDsOwjAQBe_iGlk2TmKbkj5niHb91iSAbCmfCnF3iJQC2jcz76UG2tZx2BaZhwnqoqw6_W5M6SFlB7hTuVWdalnnifWu6IMuuq-Q5_Vw_w5GWsZvLSEHZAJYoo9svAODu7aNJiRkECwbywH2TLlrODbOeXKpEeMRYdX7AycIOSU:1qAsxP:4gDRmAZWxcMyzDvSKiQRJ5-6Q9aAbt2DiCLP7unhDmk','2023-07-02 14:00:43.052144'),('nd2guk9vvhnzr5j8643fczxfvhnmq9mv','.eJxVjDsOwjAQBe_iGlk2TmKbkj5niHb91iSAbCmfCnF3iJQC2jcz76UG2tZx2BaZhwnqoqw6_W5M6SFlB7hTuVWdalnnifWu6IMuuq-Q5_Vw_w5GWsZvLSEHZAJYoo9svAODu7aNJiRkECwbywH2TLlrODbOeXKpEeMRYdX7AycIOSU:1q9uIN:Z8n2Uln14yKja7QMTBR8ZE0KWccyjlwX3-uAp3obqxg','2023-06-29 21:14:19.016994'),('p1n8cd7rwavphzmb1ar2h6cedcie7ryi','.eJxVjMsOwiAQRf-FtSHAMFBduvcbmhkeUjWQlHZl_HdD0oVu7znnvsVM-1bmvad1XqK4CAvi9DsyhWeqg8QH1XuTodVtXVgORR60y1uL6XU93L-DQr2MGgGJIStvczCUNZ5hAsU4cdYRPVNCCsqx8sTRWG219gG086yM4yQ-XxFmOBI:1qaZPT:eS5F3pzUSArV-jd3FKssVBAxPQ8uSHyZ47m93F75npc','2023-09-11 10:23:51.615052'),('t290beg7wyqziafsdp1p4jgihd7ytdsq','.eJxVjMsOwiAQRf-FtSHAMFBduvcbmhkeUjWQlHZl_HdD0oVu7znnvsVM-1bmvad1XqK4CAvi9DsyhWeqg8QH1XuTodVtXVgORR60y1uL6XU93L-DQr2MGgGJIStvczCUNZ5hAsU4cdYRPVNCCsqx8sTRWG219gG086yM4yQ-XxFmOBI:1qYHDp:yvf8dJR6XdttjWTZk8g1O4kS3Fwn0oQI_OtZhjqZP-8','2023-09-05 02:34:21.247493'),('tzrv2yle93vyl92t3zqazla5k0mzv4n8','.eJxVjDsOwjAQBe_iGlk2TmKbkj5niHb91iSAbCmfCnF3iJQC2jcz76UG2tZx2BaZhwnqoqw6_W5M6SFlB7hTuVWdalnnifWu6IMuuq-Q5_Vw_w5GWsZvLSEHZAJYoo9svAODu7aNJiRkECwbywH2TLlrODbOeXKpEeMRYdX7AycIOSU:1qIwSi:1vS3DlDlee8ZhJfwhINb1EFq6VNiKa3UzZ5sm76BzAQ','2023-07-24 19:22:20.782037'),('u4ejpvwoh98y5mphb5nm5aeogpjaxvjn','.eJxVjDsOwjAQBe_iGlk2TmKbkj5niHb91iSAbCmfCnF3iJQC2jcz76UG2tZx2BaZhwnqoqw6_W5M6SFlB7hTuVWdalnnifWu6IMuuq-Q5_Vw_w5GWsZvLSEHZAJYoo9svAODu7aNJiRkECwbywH2TLlrODbOeXKpEeMRYdX7AycIOSU:1qAbN9:l09oqjnZceQvkc2cs1mMrux5v-3HPWkcmx2iGpJYVgc','2023-07-01 19:14:07.109476');
/*!40000 ALTER TABLE `django_session` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-09-02 11:34:34

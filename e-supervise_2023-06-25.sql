# ************************************************************
# Sequel Pro SQL dump
# Version 5446
#
# https://www.sequelpro.com/
# https://github.com/sequelpro/sequelpro
#
# Host: rm-uf6ey11nt8pju24wcno.mysql.rds.aliyuncs.com (MySQL 8.0.25)
# Database: cgone-test
# Generation Time: 2023-06-25 15:02:39 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
SET NAMES utf8mb4;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table archives
# ------------------------------------------------------------

DROP TABLE IF EXISTS `archives`;

CREATE TABLE `archives` (
  `id` int NOT NULL AUTO_INCREMENT,
  `entityId` int NOT NULL COMMENT '关联表单实例id',
  `orgId` int DEFAULT NULL COMMENT '部门Id',
  `userId` int DEFAULT NULL COMMENT '人员Id',
  `archivesType` enum('惩处','信访','帮教记录','帮教列管') NOT NULL COMMENT '惩处|信访|帮教列管|帮教记录',
  `keywords` varchar(2000) NOT NULL COMMENT '关键词合集',
  `createdAt` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updatedAt` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  `deletedAt` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_ac11169bad66b46a91e00489023` (`entityId`),
  KEY `FK_7fe5d4dfc1e43af3a1eb0ae1a8a` (`orgId`),
  KEY `FK_9eb1e848bb6bb8bf54c1b8ab212` (`userId`),
  CONSTRAINT `FK_7fe5d4dfc1e43af3a1eb0ae1a8a` FOREIGN KEY (`orgId`) REFERENCES `user_org` (`id`),
  CONSTRAINT `FK_9eb1e848bb6bb8bf54c1b8ab212` FOREIGN KEY (`userId`) REFERENCES `user_account` (`id`),
  CONSTRAINT `FK_ac11169bad66b46a91e00489023` FOREIGN KEY (`entityId`) REFERENCES `entity` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;



# Dump of table assessment_item
# ------------------------------------------------------------

DROP TABLE IF EXISTS `assessment_item`;

CREATE TABLE `assessment_item` (
  `id` int NOT NULL AUTO_INCREMENT,
  `assessmentType` enum('四责协同考核','驻派纪检干部考核','双排查规定') NOT NULL COMMENT '考核表类型',
  `year` int NOT NULL COMMENT '年份',
  `projectName` varchar(500) NOT NULL COMMENT '项目名称',
  `serialName` varchar(2000) NOT NULL COMMENT '子项目编号名称',
  `serialNumber` int NOT NULL COMMENT '子项目编号',
  `baseValue` decimal(10,0) DEFAULT NULL COMMENT '分值',
  `standard` varchar(2000) DEFAULT NULL COMMENT '评分标准',
  `templateKeys` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '关联模板',
  `systemHalf1st` decimal(10,0) DEFAULT NULL COMMENT '系统上半年评分',
  `manualHalf1st` decimal(10,0) DEFAULT NULL COMMENT '手动上半年评分',
  `systemHalf2end` decimal(10,0) DEFAULT NULL COMMENT '系统下半年评分',
  `manualHalf2end` decimal(10,0) DEFAULT NULL COMMENT '手动下半年评分',
  `systemValue` decimal(10,0) DEFAULT NULL COMMENT '系统年度评分',
  `manualValue` decimal(10,0) DEFAULT NULL COMMENT '手动年度评分',
  `leadingGroupValue` decimal(10,0) DEFAULT NULL COMMENT '领导小组总和评估分',
  `yearlyValue` decimal(10,0) DEFAULT NULL COMMENT '年度考核分、部门年度考核总分',
  `yearlylevel` varchar(255) DEFAULT NULL COMMENT '评级',
  `orgId` int DEFAULT NULL COMMENT '所属机构Id',
  `createdById` int DEFAULT NULL COMMENT '提交人Id',
  `createdAt` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updatedAt` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  `deletedAt` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;



# Dump of table entity
# ------------------------------------------------------------

DROP TABLE IF EXISTS `entity`;

CREATE TABLE `entity` (
  `id` int NOT NULL AUTO_INCREMENT,
  `key` varchar(200) NOT NULL COMMENT '模板文件',
  `name` varchar(200) NOT NULL COMMENT '模板名称',
  `majorMenu` varchar(64) DEFAULT NULL COMMENT '主模块，例如：四责协同',
  `minorMenu` varchar(64) DEFAULT NULL COMMENT '次级模块，例如：双排查',
  `orgId` int DEFAULT NULL COMMENT '所属机构Id',
  `roleId` int DEFAULT NULL COMMENT '提交人所属角色Id',
  `dataStr` text COMMENT '关联数据',
  `completedAt` datetime DEFAULT NULL COMMENT '完成日期 精确到日',
  `createdById` int DEFAULT NULL COMMENT '提交人Id',
  `dateRange` int NOT NULL COMMENT '周期数',
  `dateRangeType` enum('月','季','半年','年') DEFAULT '月' COMMENT '月|季|半年|年',
  `templateId` int DEFAULT NULL COMMENT '所属表单模板Id',
  `status` enum('未开始','草稿','已提交','已完成') NOT NULL DEFAULT '草稿' COMMENT '状态',
  `handlerId` int DEFAULT NULL COMMENT '负责人，承办人',
  `handlers` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin COMMENT '承办人们',
  `plannedCompletionAt` datetime DEFAULT NULL COMMENT '计划完成日期',
  `keywords` varchar(2000) NOT NULL COMMENT '关键词合集',
  `updatedAt` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  `createdAt` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `deletedAt` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_2e56d797d6ec3d3e41d303b90b3` (`templateId`),
  KEY `FK_9a37974dfff4856c37c44682433` (`createdById`),
  KEY `FK_f57fe700ff2f7d2003bb8281175` (`handlerId`),
  CONSTRAINT `FK_2e56d797d6ec3d3e41d303b90b3` FOREIGN KEY (`templateId`) REFERENCES `template` (`id`),
  CONSTRAINT `FK_9a37974dfff4856c37c44682433` FOREIGN KEY (`createdById`) REFERENCES `user_account` (`id`),
  CONSTRAINT `FK_f57fe700ff2f7d2003bb8281175` FOREIGN KEY (`handlerId`) REFERENCES `user_account` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;



# Dump of table mission_record
# ------------------------------------------------------------

DROP TABLE IF EXISTS `mission_record`;

CREATE TABLE `mission_record` (
  `id` int NOT NULL AUTO_INCREMENT,
  `serialNumber` int NOT NULL COMMENT '序号',
  `entityId` int NOT NULL COMMENT '关联四责协同表单实例id',
  `roleId` int DEFAULT NULL COMMENT '角色Id',
  `orgId` int DEFAULT NULL COMMENT '部门Id',
  `dateRange` int NOT NULL COMMENT '周期数',
  `dateRangeType` enum('月','季','半年','年') DEFAULT '月' COMMENT '月|季|半年|年',
  `remindedAt` datetime DEFAULT NULL COMMENT '提醒日期 精确到日',
  `status` enum('进行中','已完成') NOT NULL DEFAULT '进行中' COMMENT '状态',
  `completedAt` datetime DEFAULT NULL COMMENT '完成日期 精确到日',
  `createdAt` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updatedAt` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  `deletedAt` datetime(6) DEFAULT NULL,
  `name` varchar(2000) NOT NULL COMMENT '责任清单名称',
  `templateKey` varchar(200) NOT NULL COMMENT '关联四责协同表单模板Key',
  `templateId` int DEFAULT NULL COMMENT '所属表单模板Id',
  PRIMARY KEY (`id`),
  KEY `FK_c8113f782c3e8e317de13e478d5` (`orgId`),
  KEY `FK_299da888194bb6067dc9d1e34d5` (`roleId`),
  KEY `FK_3376e9fd114d8d3e51062acc951` (`templateId`),
  CONSTRAINT `FK_299da888194bb6067dc9d1e34d5` FOREIGN KEY (`roleId`) REFERENCES `user_role` (`id`),
  CONSTRAINT `FK_3376e9fd114d8d3e51062acc951` FOREIGN KEY (`templateId`) REFERENCES `template` (`id`),
  CONSTRAINT `FK_c8113f782c3e8e317de13e478d5` FOREIGN KEY (`orgId`) REFERENCES `user_org` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;



# Dump of table reminder
# ------------------------------------------------------------

DROP TABLE IF EXISTS `reminder`;

CREATE TABLE `reminder` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键Id',
  `name` varchar(500) NOT NULL COMMENT '名称',
  `majorMenu` varchar(50) NOT NULL COMMENT '主模块',
  `minorMenu` varchar(50) NOT NULL COMMENT '次级模块',
  `entityId` int DEFAULT NULL COMMENT '所属表单Id',
  `templateId` int DEFAULT NULL COMMENT '所属表单模板Id',
  `reminderType` enum('系统消息','到期提醒','我的草稿','我下属的','我发起的','指派给我的') NOT NULL DEFAULT '我的草稿' COMMENT '系统消息|到期提醒|我的草稿|我下属的|我发起的|指派给我的',
  `status` enum('未开始','草稿','已提交','已完成') NOT NULL DEFAULT '草稿' COMMENT '状态',
  `isRead` tinyint(1) DEFAULT '0' COMMENT '已阅',
  `ownerId` int DEFAULT NULL COMMENT '提醒接收者',
  `orgId` int DEFAULT NULL COMMENT '所属机构',
  `keywords` varchar(2000) NOT NULL COMMENT '关键词合集',
  `createdById` int DEFAULT NULL COMMENT '提交人Id',
  `createdAt` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updatedAt` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  `deletedAt` datetime(6) DEFAULT NULL,
  `plannedCompletionAt` datetime DEFAULT NULL COMMENT '计划完成日期',
  PRIMARY KEY (`id`),
  KEY `FK_4005f459d20756f07bccaa0b35f` (`createdById`),
  CONSTRAINT `FK_4005f459d20756f07bccaa0b35f` FOREIGN KEY (`createdById`) REFERENCES `user_account` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

LOCK TABLES `reminder` WRITE;
/*!40000 ALTER TABLE `reminder` DISABLE KEYS */;

INSERT INTO `reminder` (`id`, `name`, `majorMenu`, `minorMenu`, `entityId`, `templateId`, `reminderType`, `status`, `isRead`, `ownerId`, `orgId`, `keywords`, `createdById`, `createdAt`, `updatedAt`, `deletedAt`, `plannedCompletionAt`)
VALUES
	(1,'部门推进全面从严管党治警“四责协同”年度重点项目表','szxt','zdxm',0,3,'系统消息','未开始',0,100330,101,'zhc,100330,指挥处,部门,部门推进全面从严管党治警“四责协同”年度重点项目表,年,系统消息,',100330,'2022-07-04 11:47:30.686297','2022-07-04 11:47:30.686297',NULL,NULL),
	(2,'重点项目推进情况表','szxt','zdxm',0,4,'系统消息','未开始',0,100330,101,'zhc,100330,指挥处,部门,重点项目推进情况表,半年,系统消息,',100330,'2022-07-04 11:47:31.005774','2022-07-04 11:47:31.005774',NULL,NULL),
	(3,'高风险重点问题排查表','szxt','spc',0,8,'系统消息','未开始',0,100330,101,'zhc,100330,指挥处,部门,高风险重点问题排查表,季,系统消息,',100330,'2022-07-04 11:47:31.324900','2022-07-04 11:47:31.324900',NULL,NULL),
	(4,'部门推进全面从严管党治警“四责协同”机制责任清单','szxt','bsmz',0,32,'系统消息','未开始',0,100330,101,'zhc,100330,指挥处,部门,部门推进全面从严管党治警“四责协同”机制责任清单,年,系统消息,',100330,'2022-07-04 11:47:31.639778','2022-07-04 11:47:31.639778',NULL,NULL),
	(5,'部门年度党风廉政建设会议召开情况表','szxt','bsmz',0,36,'系统消息','未开始',0,100330,101,'zhc,100330,指挥处,部门,部门年度党风廉政建设会议召开情况表,年,系统消息,',100330,'2022-07-04 11:47:31.954927','2022-07-04 11:47:31.954927',NULL,NULL),
	(6,'廉政教育工作部署记录表','szxt','lzjy',0,25,'系统消息','未开始',0,10033,101,'zhc1,10033,指挥处,一把手,廉政教育工作部署记录表,季,系统消息,',10033,'2022-07-04 11:47:46.420564','2022-07-04 11:47:46.420564',NULL,NULL),
	(7,'廉政党课记录表','szxt','lzjy',0,26,'系统消息','未开始',0,10033,101,'zhc1,10033,指挥处,一把手,廉政党课记录表,年,系统消息,',10033,'2022-07-04 11:47:46.745441','2022-07-04 11:47:46.745441',NULL,NULL),
	(8,'部门党（总）支部书记推进全面从严管党治警“四责协同”机制第一责任清单','szxt','bsmz',0,33,'系统消息','未开始',0,10033,101,'zhc1,10033,指挥处,一把手,部门党（总）支部书记推进全面从严管党治警“四责协同”机制第一责任清单,年,系统消息,',10033,'2022-07-04 11:47:47.068501','2022-07-04 11:47:47.068501',NULL,NULL),
	(9,'部门队伍管理责任制责任链条','szxt','bmqk',0,37,'系统消息','未开始',0,10033,101,'zhc1,10033,指挥处,一把手,部门队伍管理责任制责任链条,年,系统消息,',10033,'2022-07-04 11:47:47.402537','2022-07-04 11:47:47.402537',NULL,NULL),
	(10,'部门队伍基本情况','szxt','bmqk',0,38,'系统消息','未开始',0,10033,101,'zhc1,10033,指挥处,一把手,部门队伍基本情况,年,系统消息,',10033,'2022-07-04 11:47:47.728610','2022-07-04 11:47:47.728610',NULL,NULL),
	(11,'党（总）支部书记每半年向分管局领导汇报“四责协同”机制建设情况记录表','szxt','bndhb',0,40,'系统消息','未开始',0,10033,101,'zhc1,10033,指挥处,一把手,党（总）支部书记每半年向分管局领导汇报“四责协同”机制建设情况记录表,半年,系统消息,',10033,'2022-07-04 11:47:48.048383','2022-07-04 11:47:48.048383',NULL,NULL),
	(12,'部门推进全面从严管党治警“四责协同”年度重点项目表','szxt','zdxm',0,3,'系统消息','未开始',0,20214,103,'kjk,60214,科技科,部门,部门推进全面从严管党治警“四责协同”年度重点项目表,年,系统消息,',20214,'2022-07-04 11:48:00.027492','2022-07-04 11:48:00.027492',NULL,NULL),
	(13,'重点项目推进情况表','szxt','zdxm',0,4,'系统消息','未开始',0,20214,103,'kjk,60214,科技科,部门,重点项目推进情况表,半年,系统消息,',20214,'2022-07-04 11:48:00.365764','2022-07-04 11:48:00.365764',NULL,NULL),
	(14,'高风险重点问题排查表','szxt','spc',0,8,'系统消息','未开始',0,20214,103,'kjk,60214,科技科,部门,高风险重点问题排查表,季,系统消息,',20214,'2022-07-04 11:48:00.680205','2022-07-04 11:48:00.680205',NULL,NULL),
	(15,'部门推进全面从严管党治警“四责协同”机制责任清单','szxt','bsmz',0,32,'系统消息','未开始',0,20214,103,'kjk,60214,科技科,部门,部门推进全面从严管党治警“四责协同”机制责任清单,年,系统消息,',20214,'2022-07-04 11:48:01.007357','2022-07-04 11:48:01.007357',NULL,NULL),
	(16,'部门年度党风廉政建设会议召开情况表','szxt','bsmz',0,36,'系统消息','未开始',0,20214,103,'kjk,60214,科技科,部门,部门年度党风廉政建设会议召开情况表,年,系统消息,',20214,'2022-07-04 11:48:01.345789','2022-07-04 11:48:01.345789',NULL,NULL);

/*!40000 ALTER TABLE `reminder` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table supervise_record
# ------------------------------------------------------------

DROP TABLE IF EXISTS `supervise_record`;

CREATE TABLE `supervise_record` (
  `id` int NOT NULL AUTO_INCREMENT,
  `entityId` int NOT NULL COMMENT '所属表单Id',
  `templateId` int NOT NULL COMMENT '所属表单模板Id',
  `orgId` int DEFAULT NULL COMMENT '部门Id',
  `illegalBehaviorType` enum('作息制度执行情况','警容风纪情况','内务环境情况','窗口服务工作情况','规范化执法情况','公务用车使用情况','信访举报核查情况','公务用枪使用情况','其他内部管理情况') DEFAULT NULL COMMENT '存在问题类型',
  `involveUserId` int NOT NULL COMMENT '涉及人Id',
  `createdById` int NOT NULL COMMENT '提交人Id',
  `checkedAt` datetime DEFAULT NULL COMMENT '检查日期 精确到日',
  `createdAt` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updatedAt` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  `deletedAt` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_88112f788c3e8ea17de13e478d8` (`orgId`),
  CONSTRAINT `FK_88112f788c3e8ea17de13e478d8` FOREIGN KEY (`orgId`) REFERENCES `user_org` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;



# Dump of table system_logger
# ------------------------------------------------------------

DROP TABLE IF EXISTS `system_logger`;

CREATE TABLE `system_logger` (
  `id` int NOT NULL AUTO_INCREMENT,
  `userId` int DEFAULT NULL COMMENT '人员Id',
  `moduleName` enum('四责协同','责任清单','任务管理','信息监督','档案','考核','权限管理','用户信息','表单草稿') DEFAULT NULL COMMENT '模块',
  `operation` enum('新增','更新','提交','完成','转发','删除','签收') DEFAULT NULL COMMENT '操作',
  `operationDetails` varchar(500) DEFAULT NULL COMMENT '操作详情',
  `operationDataStr` text COMMENT '关联数据',
  `createdAt` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updatedAt` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  `deletedAt` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_6b95b444f0564955e2db0560179` (`userId`),
  CONSTRAINT `FK_6b95b444f0564955e2db0560179` FOREIGN KEY (`userId`) REFERENCES `user_account` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;



# Dump of table template
# ------------------------------------------------------------

DROP TABLE IF EXISTS `template`;

CREATE TABLE `template` (
  `id` int NOT NULL AUTO_INCREMENT,
  `key` varchar(200) NOT NULL COMMENT '模板文件',
  `name` varchar(200) NOT NULL COMMENT '模板名称',
  `dateRangeType` enum('月','季','半年','年') DEFAULT '月' COMMENT '月|季|半年|年',
  `repeatable` tinyint(1) DEFAULT '0' COMMENT '是否可以多次提交',
  `roleIds` text COMMENT '所属角色Id，可以属于多个',
  `majorMenu` varchar(64) DEFAULT NULL COMMENT '主模块，例如：四责协同',
  `minorMenu` varchar(64) DEFAULT NULL COMMENT '次级模块，例如：双排查',
  `assessment` tinyint(1) DEFAULT '1' COMMENT '是否参与评分',
  `needRemind` tinyint(1) DEFAULT '1' COMMENT '是否需要提醒',
  `reminderDays` tinyint DEFAULT '15' COMMENT '提醒提前天数',
  `personnelSelectionRange` varchar(64) DEFAULT NULL COMMENT '人员选择范围',
  `updatedAt` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

LOCK TABLES `template` WRITE;
/*!40000 ALTER TABLE `template` DISABLE KEYS */;

INSERT INTO `template` (`id`, `key`, `name`, `dateRangeType`, `repeatable`, `roleIds`, `majorMenu`, `minorMenu`, `assessment`, `needRemind`, `reminderDays`, `personnelSelectionRange`, `updatedAt`)
VALUES
	(1,'部门加强作风建设情况表','部门加强作风建设情况表','月',1,'3','szxt','zfjs',1,1,15,'部门内','2021-05-27 10:03:04.170608'),
	(2,'部门加强作风建设情况监督评价表','部门加强作风建设情况监督评价表','月',1,'7','szxt','zfjs',1,1,15,'部门内','2021-05-27 10:03:04.485327'),
	(3,'部门推进全面从严管党治警“四责协同”年度重点项目表','部门推进全面从严管党治警“四责协同”年度重点项目表','年',0,'3','szxt','zdxm',1,1,15,'部门内','2021-05-27 10:03:03.813576'),
	(4,'党支部书记重点项目推进情况表','重点项目推进情况表','半年',0,'3','szxt','zdxm',1,1,15,'部门内','2021-06-10 21:41:34.848683'),
	(5,'部门重点项目推进情况表','重点项目推进情况表','半年',1,'4','szxt','zdxm',1,1,15,'无','2021-10-19 15:13:22.855890'),
	(6,'重点项目推进落实情况表','重点项目推进落实情况表','半年',1,'5,6','szxt','zdxm',1,1,15,'部门内','2021-10-19 15:13:25.887715'),
	(7,'部门推进全面从严管党治警“四责协同”年度重点项目监督评价表','部门推进全面从严管党治警“四责协同”年度重点项目监督评价表','季',0,'7','szxt','zdxm',1,1,15,'部门内','2021-05-27 10:03:03.663443'),
	(8,'高风险重点问题排查表','高风险重点问题排查表','季',0,'3','szxt','spc',1,1,15,'部门内','2021-05-27 10:03:03.625065'),
	(9,'低风险重点问题教育情况汇总表','低风险重点问题教育情况汇总表','季',1,'3','szxt','spc',1,1,15,'无','2021-05-27 10:03:04.447355'),
	(10,'重点帮教人员排查表','重点帮教人员排查表','季',1,'3','szxt','spc',1,1,15,'部门内','2021-05-30 11:41:17.792657'),
	(11,'推进双排查工作记录表','推进双排查工作记录表','季',1,'4','szxt','spc',1,0,15,'部门内','2021-05-27 10:03:04.408371'),
	(12,'重点帮教人员帮教记录表','重点帮教人员帮教记录表','月',1,'4,5,6','szxt','spc',1,0,15,'部门内','2021-05-27 10:03:04.370474'),
	(13,'重点问题排查整改教育工作汇总表','重点问题排查整改教育工作汇总表','季',0,'5','szxt','spc',1,1,15,'部门内','2021-05-27 10:03:03.422596'),
	(14,'高风险重点问题整改工作记录表','高风险重点问题整改工作记录表','季',1,'6','szxt','spc',1,0,15,'部门内','2021-05-27 10:03:04.331849'),
	(15,'继续整改高风险重点问题整改工作记录表','继续整改高风险重点问题整改工作记录表','季',0,'5','szxt','spc',1,1,15,'无','2021-05-27 10:01:29.650209'),
	(16,'重点帮教人员列管告知记录表','重点帮教人员列管告知记录表','月',1,'5,6','szxt','spc',1,0,15,'部门内','2021-05-27 10:03:04.293636'),
	(17,'重点帮教人员管控记录表','重点帮教人员管控记录表','月',1,'5,6','szxt','spc',1,0,15,'部门内','2021-05-27 10:03:04.255096'),
	(18,'重点问题排查整改监督评价表','重点问题排查整改监督评价表','季',0,'7','szxt','spc',1,1,15,'部门内','2021-05-27 10:03:03.264089'),
	(19,'重点帮教人员排查帮教情况监督评价表','重点帮教人员排查帮教情况监督评价表','季',0,'7','szxt','spc',1,1,15,'部门内','2021-05-27 10:03:03.224058'),
	(20,'牵头组织开展高风险重点问题整改工作记录表','牵头组织开展高风险重点问题整改工作记录表','季',1,'5','szxt','spc',1,0,15,'部门内','2021-05-27 10:03:04.213471'),
	(21,'重要事项集体决策汇总表','重要事项集体决策汇总表','月',1,'4','szxt','szyd',0,0,15,'无','2021-05-27 10:03:03.852070'),
	(22,'谈心谈话记录','谈心谈话记录','月',1,'4,5,6,7','szxt','rcjl',1,0,15,'部门内','2021-05-27 10:03:04.118347'),
	(23,'队伍日常教育管理记录','队伍日常教育管理记录','月',1,'4,5,6,7','szxt','rcjl',1,0,15,'部门内','2021-05-27 10:03:04.080617'),
	(24,'部门推进全面从严管党治警“四责协同”廉政教育工作记录表','部门推进全面从严管党治警“四责协同”廉政教育工作记录表','月',1,'3','szxt','lzjy',1,1,15,'部门内','2021-05-27 10:03:04.040833'),
	(25,'廉政教育工作部署记录表','廉政教育工作部署记录表','季',0,'4','szxt','lzjy',1,1,15,'无','2021-05-27 10:03:03.024711'),
	(26,'廉政党课记录表','廉政党课记录表','年',0,'4','szxt','lzjy',1,1,15,'部门内','2021-05-27 10:03:02.984807'),
	(27,'部门班子成员（实职干部）廉政谈话情况记录表','部门班子成员（实职干部）廉政谈话情况记录表','季',1,'4','szxt','lzjy',1,0,15,'部门内','2021-10-10 15:13:20.343514'),
	(28,'廉政教育工作推进记录表','廉政教育工作推进记录表','季',0,'5,6','szxt','lzjy',1,1,15,'无','2021-08-20 18:34:13.065712'),
	(29,'分管人员廉政谈话情况记录表','分管人员廉政谈话情况记录表','月',1,'5,6','szxt','lzjy',1,0,15,'部门内','2021-05-27 10:03:03.929074'),
	(30,'部门年度党风廉政建设会议召开情况监督评价表','部门年度党风廉政建设会议召开情况监督评价表','年',0,'7','szxt','lzjy',1,1,15,'部门内','2021-05-27 10:03:03.065547'),
	(31,'部门推进全面从严管党治警“四责协同”廉政教育工作监督评价表','部门推进全面从严管党治警“四责协同”廉政教育工作监督评价表','月',1,'7','szxt','lzjy',1,1,15,'无','2021-05-27 10:03:03.891209'),
	(32,'部门推进全面从严管党治警“四责协同”机制责任清单','部门推进全面从严管党治警“四责协同”机制责任清单','年',0,'3','szxt','bsmz',1,1,15,'无','2021-05-27 10:03:03.104314'),
	(33,'部门党（总）支部书记推进全面从严管党治警“四责协同”机制第一责任清单','部门党（总）支部书记推进全面从严管党治警“四责协同”机制第一责任清单','年',0,'4','szxt','bsmz',1,1,15,'无','2021-05-27 10:03:03.146357'),
	(34,'部门政工领导推进全面从严管党治警“四责协同”机制队伍主抓责任清单','部门政工领导推进全面从严管党治警“四责协同”机制队伍主抓责任清单','年',0,'5','szxt','bsmz',1,1,15,'无','2021-05-27 10:03:03.184444'),
	(35,'部门班子成员推进全面从严管党治警“四责协同”机制“一岗双责”清单','部门班子成员推进全面从严管党治警“四责协同”机制“一岗双责”清单','年',0,'6','szxt','bsmz',1,1,15,'无','2021-05-27 10:03:03.305060'),
	(36,'部门年度党风廉政建设会议召开情况表','部门年度党风廉政建设会议召开情况表','年',0,'3','szxt','bsmz',1,1,15,'部门内','2021-05-27 10:03:03.344063'),
	(37,'部门队伍管理责任制责任链条','部门队伍管理责任制责任链条','年',0,'4,5,6','szxt','bmqk',1,1,15,'无','2021-05-27 10:03:03.383352'),
	(38,'部门队伍基本情况','部门队伍基本情况','年',0,'4,5,6','szxt','bmqk',0,1,15,'无','2021-05-27 10:03:03.461062'),
	(39,'派驻部门基本情况','派驻部门基本情况','年',0,'7','szxt','bmqk',0,1,15,'无','2021-05-27 10:03:03.506090'),
	(40,'党（总）支部书记每半年向分管局领导汇报“四责协同”机制建设情况记录表','党（总）支部书记每半年向分管局领导汇报“四责协同”机制建设情况记录表','半年',0,'4','szxt','bndhb',1,1,15,'部门内','2021-05-27 10:03:03.586822'),
	(41,'惩处','部门惩处','月',1,'3','szxt','rcjl',1,0,15,'部门内','2021-05-27 15:45:04.411701'),
	(42,'部门信访','部门信访','月',1,'3,4,5,6','xxjd','bmxf',1,1,3,'全部门','2021-05-27 10:53:50.759999'),
	(43,'三个规定','三个规定','月',1,'3,4,5,6,7','xxjd','bmxf',1,0,0,'全部门','2021-06-01 15:47:41.140541'),
	(44,'纪委信访','纪委信访','月',1,'1,2,7','xxjd','jwxf',1,1,3,'全部门','2021-05-27 10:53:50.759999'),
	(45,'问题线索','问题线索','月',1,'1,2,3,4,5,6,7','xxjd','djd',1,0,0,'全部门','2021-05-27 10:53:50.759999'),
	(46,'任务下发','任务下发','月',1,'1,2,7','rwgl','rwxf',1,1,3,'全部门','2021-05-28 14:42:00.948759'),
	(47,'专职纪检监察干部日常监督记录表','专职纪检监察干部日常监督记录表','月',1,'1,2,3,4,5,6,7','xxjd','rcjd',0,1,15,'无','2021-10-25 09:57:59.467832'),
	(48,'职能监督','职能监督','月',1,'1,2,3,4,5,6,7','xxjd','djd',1,0,0,'全部门','2021-10-28 20:24:47.015584');

/*!40000 ALTER TABLE `template` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table user_account
# ------------------------------------------------------------

DROP TABLE IF EXISTS `user_account`;

CREATE TABLE `user_account` (
  `id` int NOT NULL COMMENT '人员职位信息Id',
  `name` varchar(64) DEFAULT NULL COMMENT '姓名',
  `userCode` varchar(64) DEFAULT NULL COMMENT '身份证号',
  `userType` int DEFAULT NULL COMMENT '身份类型',
  `username` varchar(128) DEFAULT NULL,
  `md5Password` varchar(256) DEFAULT 'bc9b5718afdffe85fb13555347969ff5' COMMENT 'pwd',
  `policeId` varchar(32) DEFAULT NULL COMMENT '警号',
  `orgId` int DEFAULT NULL COMMENT '所属机构Id',
  `accessOrgCodes` varchar(256) DEFAULT NULL COMMENT '所属机构s',
  `jobDesc` varchar(256) DEFAULT NULL COMMENT '职务',
  `quater` varchar(128) DEFAULT NULL COMMENT '工作岗位',
  `roleId` int DEFAULT NULL COMMENT '角色Id',
  `purviewValue` bigint DEFAULT NULL COMMENT '人员权限值',
  `sex` int DEFAULT NULL COMMENT '性别',
  `img` text COMMENT '照片（base64编码）',
  `partType` int DEFAULT NULL COMMENT '任职',
  `orgCode` varchar(64) DEFAULT NULL COMMENT '所属机构编码',
  `orgName` varchar(64) DEFAULT NULL COMMENT '机构全称/部门',
  `avatar` varchar(50) DEFAULT NULL COMMENT '自定义头像',
  `authStatus` int DEFAULT '0' COMMENT '认证状态0-未认证1-微信2-人脸',
  `is4ANew` int DEFAULT '0' COMMENT '4A有更新',
  `createdAt` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updatedAt` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  `deletedAt` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_173558c2f5b54c156ee72a5b1be` (`orgId`),
  KEY `FK_c7262238be35c25da9bc8d85863` (`roleId`),
  CONSTRAINT `FK_173558c2f5b54c156ee72a5b1be` FOREIGN KEY (`orgId`) REFERENCES `user_org` (`id`),
  CONSTRAINT `FK_c7262238be35c25da9bc8d85863` FOREIGN KEY (`roleId`) REFERENCES `user_role` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

LOCK TABLES `user_account` WRITE;
/*!40000 ALTER TABLE `user_account` DISABLE KEYS */;

INSERT INTO `user_account` (`id`, `name`, `userCode`, `userType`, `username`, `md5Password`, `policeId`, `orgId`, `accessOrgCodes`, `jobDesc`, `quater`, `roleId`, `purviewValue`, `sex`, `img`, `partType`, `orgCode`, `orgName`, `avatar`, `authStatus`, `is4ANew`, `createdAt`, `updatedAt`, `deletedAt`)
VALUES
	(10033,'zhc1','zhc1',NULL,'zhc1','e10adc3949ba59abbe56e057f20f883e','10033',101,NULL,NULL,NULL,4,621544452,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.014221','2022-07-04 11:47:49.000000',NULL),
	(10034,'zzc1','zzc1',NULL,'zzc1','e10adc3949ba59abbe56e057f20f883e','10034',102,NULL,NULL,NULL,4,621544452,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.037970','2022-01-20 11:43:52.769954',NULL),
	(10035,'jbc1','jbc1',NULL,'jbc1','e10adc3949ba59abbe56e057f20f883e','10035',103,NULL,NULL,NULL,4,621544452,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.041474','2022-01-20 11:43:52.769954',NULL),
	(10036,'kjk1','kjk1',NULL,'kjk1','e10adc3949ba59abbe56e057f20f883e','10036',103,NULL,NULL,NULL,4,621544452,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.043963','2022-01-24 17:46:44.000000',NULL),
	(10037,'gbc1','gbc1',NULL,'gbc1','e10adc3949ba59abbe56e057f20f883e','10037',104,NULL,NULL,NULL,4,621544452,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.045287','2022-01-20 11:43:52.769954',NULL),
	(10038,'jzzd1','jzzd1',NULL,'jzzd1','e10adc3949ba59abbe56e057f20f883e','10038',105,NULL,NULL,NULL,4,621544452,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.046841','2022-01-20 11:43:52.769954',NULL),
	(10039,'zazd1','zazd1',NULL,'zazd1','e10adc3949ba59abbe56e057f20f883e','10039',106,NULL,NULL,NULL,4,621544452,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.048362','2022-01-20 11:43:52.769954',NULL),
	(10040,'xzzd1','xzzd1',NULL,'xzzd1','e10adc3949ba59abbe56e057f20f883e','10040',107,NULL,NULL,NULL,4,621544452,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.049533','2022-01-20 11:43:52.769954',NULL),
	(10041,'crjb1','crjb1',NULL,'crjb1','e10adc3949ba59abbe56e057f20f883e','10041',108,NULL,NULL,NULL,4,621544452,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.050527','2022-01-20 11:43:52.769954',NULL),
	(10042,'jjzd1','jjzd1',NULL,'jjzd1','e10adc3949ba59abbe56e057f20f883e','10042',109,NULL,NULL,NULL,4,621544452,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.051568','2022-01-20 11:43:52.769954',NULL),
	(10043,'tjzd1','tjzd1',NULL,'tjzd1','e10adc3949ba59abbe56e057f20f883e','10043',110,NULL,NULL,NULL,4,621544452,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.052555','2022-01-20 11:43:52.769954',NULL),
	(10044,'kss1','kss1',NULL,'kss1','e10adc3949ba59abbe56e057f20f883e','10044',111,NULL,NULL,NULL,4,621544452,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.053622','2022-01-20 11:43:52.769954',NULL),
	(10045,'jls1','jls1',NULL,'jls1','e10adc3949ba59abbe56e057f20f883e','10045',112,NULL,NULL,NULL,4,621544452,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.054883','2022-01-20 11:43:52.769954',NULL),
	(10046,'wazd1','wazd1',NULL,'wazd1','e10adc3949ba59abbe56e057f20f883e','10046',113,NULL,NULL,NULL,4,621544452,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.060479','2022-01-20 11:43:52.769954',NULL),
	(10047,'fkzd1','fkzd1',NULL,'fkzd1','e10adc3949ba59abbe56e057f20f883e','10047',113,NULL,NULL,NULL,4,621544452,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.061619','2022-01-20 11:43:52.769954',NULL),
	(10048,'fzzd1','fzzd1',NULL,'fzzd1','e10adc3949ba59abbe56e057f20f883e','10048',114,NULL,NULL,NULL,4,621544452,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.063398','2022-01-20 11:43:52.769954',NULL),
	(10049,'rkb1','rkb1',NULL,'rkb1','e10adc3949ba59abbe56e057f20f883e','10049',115,NULL,NULL,NULL,4,621544452,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.064544','2022-01-20 11:43:52.769954',NULL),
	(10050,'zqs1','zqs1',NULL,'zqs1','e10adc3949ba59abbe56e057f20f883e','10050',116,NULL,NULL,NULL,4,621544452,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.065980','2022-01-20 11:43:52.769954',NULL),
	(10051,'tmxs1','tmxs1',NULL,'tmxs1','e10adc3949ba59abbe56e057f20f883e','10051',117,NULL,NULL,NULL,4,621544452,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.067406','2022-01-20 11:43:52.769954',NULL),
	(10052,'bzs1','bzs1',NULL,'bzs1','e10adc3949ba59abbe56e057f20f883e','10052',118,NULL,NULL,NULL,4,621544452,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.068671','2022-01-20 11:43:52.769954',NULL),
	(10053,'bss1','bss1',NULL,'bss1','e10adc3949ba59abbe56e057f20f883e','10053',119,NULL,NULL,NULL,4,621544452,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.070434','2022-01-20 11:43:52.769954',NULL),
	(10054,'zjxs1','zjxs1',NULL,'zjxs1','e10adc3949ba59abbe56e057f20f883e','10054',120,NULL,NULL,NULL,4,621544452,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.071528','2022-01-20 11:43:52.769954',NULL),
	(10055,'ghxs1','ghxs1',NULL,'ghxs1','e10adc3949ba59abbe56e057f20f883e','10055',121,NULL,NULL,NULL,4,621544452,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.072564','2022-01-20 11:43:52.769954',NULL),
	(10056,'dns1','dns1',NULL,'dns1','e10adc3949ba59abbe56e057f20f883e','10056',122,NULL,NULL,NULL,4,621544452,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.073481','2022-01-20 11:43:52.769954',NULL),
	(10057,'ppzs1','ppzs1',NULL,'ppzs1','e10adc3949ba59abbe56e057f20f883e','10057',123,NULL,NULL,NULL,4,621544452,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.074292','2022-01-20 11:43:52.769954',NULL),
	(10058,'ppxcs1','ppxcs1',NULL,'ppxcs1','e10adc3949ba59abbe56e057f20f883e','10058',124,NULL,NULL,NULL,4,621544452,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.075014','2022-01-20 11:43:52.769954',NULL),
	(10059,'sqs1','sqs1',NULL,'sqs1','e10adc3949ba59abbe56e057f20f883e','10059',125,NULL,NULL,NULL,4,621544452,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.075730','2022-01-20 11:43:52.769954',NULL),
	(10060,'lfs1','lfs1',NULL,'lfs1','e10adc3949ba59abbe56e057f20f883e','10060',126,NULL,NULL,NULL,4,621544452,NULL,NULL,NULL,NULL,NULL,'http://www.bba.com/1.jpg',0,0,'2022-01-20 10:04:43.076722','2022-01-20 11:43:52.769954',NULL),
	(10061,'nxs1','nxs1',NULL,'nxs1','e10adc3949ba59abbe56e057f20f883e','10061',127,NULL,NULL,NULL,4,621544452,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.077722','2022-01-20 11:43:52.769954',NULL),
	(10062,'jns1','jns1',NULL,'jns1','e10adc3949ba59abbe56e057f20f883e','10062',128,NULL,NULL,NULL,4,621544452,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.079120','2022-01-20 11:43:52.769954',NULL),
	(10063,'ses1','ses1',NULL,'ses1','e10adc3949ba59abbe56e057f20f883e','10063',129,NULL,NULL,NULL,4,621544452,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.080752','2022-01-20 11:43:52.769954',NULL),
	(10064,'jass1','jass1',NULL,'jass1','e10adc3949ba59abbe56e057f20f883e','10064',130,NULL,NULL,NULL,4,621544452,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.081998','2022-01-20 11:43:52.769954',NULL),
	(10065,'cjds1','cjds1',NULL,'cjds1','e10adc3949ba59abbe56e057f20f883e','10065',131,NULL,NULL,NULL,4,621544452,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.083307','2022-01-20 11:43:52.769954',NULL),
	(10066,'zhc2','zhc2',NULL,'zhc2','e10adc3949ba59abbe56e057f20f883e','10066',101,NULL,NULL,NULL,5,621544452,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.084667','2022-02-22 18:00:01.000000',NULL),
	(10067,'zzc2','zzc2',NULL,'zzc2','e10adc3949ba59abbe56e057f20f883e','10067',102,NULL,NULL,NULL,5,621544452,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.085819','2022-01-20 11:43:52.769954',NULL),
	(10068,'jbc2','jbc2',NULL,'jbc2','e10adc3949ba59abbe56e057f20f883e','10068',103,NULL,NULL,NULL,5,621544452,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.086965','2022-01-20 11:43:52.769954',NULL),
	(10069,'kjk2','kjk2',NULL,'kjk2','e10adc3949ba59abbe56e057f20f883e','10069',103,NULL,NULL,NULL,5,621544452,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.088571','2022-01-20 11:43:52.769954',NULL),
	(10070,'gbc2','gbc2',NULL,'gbc2','e10adc3949ba59abbe56e057f20f883e','10070',104,NULL,NULL,NULL,5,621544452,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.089989','2022-01-20 11:43:52.769954',NULL),
	(10071,'jzzd2','jzzd2',NULL,'jzzd2','e10adc3949ba59abbe56e057f20f883e','10071',105,NULL,NULL,NULL,5,621544452,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.091211','2022-01-20 11:43:52.769954',NULL),
	(10072,'zazd2','zazd2',NULL,'zazd2','e10adc3949ba59abbe56e057f20f883e','10072',106,NULL,NULL,NULL,5,621544452,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.092402','2022-01-20 11:43:52.769954',NULL),
	(10073,'xzzd2','xzzd2',NULL,'xzzd2','e10adc3949ba59abbe56e057f20f883e','10073',107,NULL,NULL,NULL,5,621544452,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.094036','2022-01-20 11:43:52.769954',NULL),
	(10074,'crjb2','crjb2',NULL,'crjb2','e10adc3949ba59abbe56e057f20f883e','10074',108,NULL,NULL,NULL,5,621544452,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.095487','2022-01-20 11:43:52.769954',NULL),
	(10075,'jjzd2','jjzd2',NULL,'jjzd2','e10adc3949ba59abbe56e057f20f883e','10075',109,NULL,NULL,NULL,5,621544452,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.096618','2022-01-20 11:43:52.769954',NULL),
	(10076,'tjzd2','tjzd2',NULL,'tjzd2','e10adc3949ba59abbe56e057f20f883e','10076',110,NULL,NULL,NULL,5,621544452,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.097559','2022-01-20 11:43:52.769954',NULL),
	(10077,'kss2','kss2',NULL,'kss2','e10adc3949ba59abbe56e057f20f883e','10077',111,NULL,NULL,NULL,5,621544452,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.098470','2022-01-20 11:43:52.769954',NULL),
	(10078,'jls2','jls2',NULL,'jls2','e10adc3949ba59abbe56e057f20f883e','10078',112,NULL,NULL,NULL,5,621544452,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.099389','2022-01-20 11:43:52.769954',NULL),
	(10079,'wazd2','wazd2',NULL,'wazd2','e10adc3949ba59abbe56e057f20f883e','10079',113,NULL,NULL,NULL,5,621544452,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.100404','2022-01-20 11:43:52.769954',NULL),
	(10080,'fkzd2','fkzd2',NULL,'fkzd2','e10adc3949ba59abbe56e057f20f883e','10080',113,NULL,NULL,NULL,5,621544452,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.101331','2022-01-20 11:43:52.769954',NULL),
	(10081,'fzzd2','fzzd2',NULL,'fzzd2','e10adc3949ba59abbe56e057f20f883e','10081',114,NULL,NULL,NULL,5,621544452,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.102244','2022-01-20 11:43:52.769954',NULL),
	(10082,'rkb2','rkb2',NULL,'rkb2','e10adc3949ba59abbe56e057f20f883e','10082',115,NULL,NULL,NULL,5,621544452,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.103837','2022-01-20 11:43:52.769954',NULL),
	(10083,'zqs2','zqs2',NULL,'zqs2','e10adc3949ba59abbe56e057f20f883e','10083',116,NULL,NULL,NULL,5,621544452,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.105770','2022-01-20 11:43:52.769954',NULL),
	(10084,'tmxs2','tmxs2',NULL,'tmxs2','e10adc3949ba59abbe56e057f20f883e','10084',117,NULL,NULL,NULL,5,621544452,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.106703','2022-01-20 11:43:52.769954',NULL),
	(10085,'bzs2','bzs2',NULL,'bzs2','e10adc3949ba59abbe56e057f20f883e','10085',118,NULL,NULL,NULL,5,621544452,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.107629','2022-01-20 11:43:52.769954',NULL),
	(10086,'bss2','bss2',NULL,'bss2','e10adc3949ba59abbe56e057f20f883e','10086',119,NULL,NULL,NULL,5,621544452,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.108866','2022-01-20 11:43:52.769954',NULL),
	(10087,'zjxs2','zjxs2',NULL,'zjxs2','e10adc3949ba59abbe56e057f20f883e','10087',120,NULL,NULL,NULL,5,621544452,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.110605','2022-01-20 11:43:52.769954',NULL),
	(10088,'ghxs2','ghxs2',NULL,'ghxs2','e10adc3949ba59abbe56e057f20f883e','10088',121,NULL,NULL,NULL,5,621544452,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.112439','2022-01-20 11:43:52.769954',NULL),
	(10089,'dns2','dns2',NULL,'dns2','e10adc3949ba59abbe56e057f20f883e','10089',122,NULL,NULL,NULL,5,621544452,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.113825','2022-01-20 11:43:52.769954',NULL),
	(10090,'ppzs2','ppzs2',NULL,'ppzs2','e10adc3949ba59abbe56e057f20f883e','10090',123,NULL,NULL,NULL,5,621544452,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.115225','2022-01-20 11:43:52.769954',NULL),
	(10091,'ppxcs2','ppxcs2',NULL,'ppxcs2','e10adc3949ba59abbe56e057f20f883e','10091',124,NULL,NULL,NULL,5,621544452,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.116477','2022-01-20 11:43:52.769954',NULL),
	(10092,'sqs2','sqs2',NULL,'sqs2','e10adc3949ba59abbe56e057f20f883e','10092',125,NULL,NULL,NULL,5,621544452,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.117389','2022-01-20 11:43:52.769954',NULL),
	(10093,'lfs2','lfs2',NULL,'lfs2','e10adc3949ba59abbe56e057f20f883e','10093',126,NULL,NULL,NULL,5,621544452,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.118433','2022-01-20 11:43:52.769954',NULL),
	(10094,'nxs2','nxs2',NULL,'nxs2','e10adc3949ba59abbe56e057f20f883e','10094',127,NULL,NULL,NULL,5,621544452,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.119420','2022-01-20 11:43:52.769954',NULL),
	(10095,'jns2','jns2',NULL,'jns2','e10adc3949ba59abbe56e057f20f883e','10095',128,NULL,NULL,NULL,5,621544452,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.121572','2022-01-20 11:43:52.769954',NULL),
	(10096,'ses2','ses2',NULL,'ses2','e10adc3949ba59abbe56e057f20f883e','10096',129,NULL,NULL,NULL,5,621544452,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.122794','2022-01-20 11:43:52.769954',NULL),
	(10097,'jass2','jass2',NULL,'jass2','e10adc3949ba59abbe56e057f20f883e','10097',130,NULL,NULL,NULL,5,621544452,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.124147','2022-01-20 11:43:52.769954',NULL),
	(10098,'cjds2','cjds2',NULL,'cjds2','e10adc3949ba59abbe56e057f20f883e','10098',131,NULL,NULL,NULL,5,621544452,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.125311','2022-01-20 11:43:52.769954',NULL),
	(10099,'zhc3','zhc3',NULL,'zhc3','e10adc3949ba59abbe56e057f20f883e','10099',101,NULL,NULL,NULL,6,604505092,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.126193','2022-02-23 14:11:46.000000',NULL),
	(10100,'zzc3','zzc3',NULL,'zzc3','e10adc3949ba59abbe56e057f20f883e','10100',102,NULL,NULL,NULL,6,604505092,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.127085','2022-01-20 11:43:52.769954',NULL),
	(10101,'jbc3','jbc3',NULL,'jbc3','e10adc3949ba59abbe56e057f20f883e','10101',103,NULL,NULL,NULL,6,604505092,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.127936','2022-01-20 11:43:52.769954',NULL),
	(10102,'kjk3','kjk3',NULL,'kjk3','e10adc3949ba59abbe56e057f20f883e','10102',103,NULL,NULL,NULL,6,604505092,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.129048','2022-01-20 11:43:52.769954',NULL),
	(10103,'gbc3','gbc3',NULL,'gbc3','e10adc3949ba59abbe56e057f20f883e','10103',104,NULL,NULL,NULL,6,604505092,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.130018','2022-01-20 11:43:52.769954',NULL),
	(10104,'jzzd3','jzzd3',NULL,'jzzd3','e10adc3949ba59abbe56e057f20f883e','10104',105,NULL,NULL,NULL,6,604505092,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.131189','2022-01-20 11:43:52.769954',NULL),
	(10105,'zazd3','zazd3',NULL,'zazd3','e10adc3949ba59abbe56e057f20f883e','10105',106,NULL,NULL,NULL,6,604505092,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.132196','2022-01-20 11:43:52.769954',NULL),
	(10106,'xzzd3','xzzd3',NULL,'xzzd3','e10adc3949ba59abbe56e057f20f883e','10106',107,NULL,NULL,NULL,6,604505092,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.133203','2022-01-20 11:43:52.769954',NULL),
	(10107,'crjb3','crjb3',NULL,'crjb3','e10adc3949ba59abbe56e057f20f883e','10107',108,NULL,NULL,NULL,6,604505092,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.134460','2022-01-20 11:43:52.769954',NULL),
	(10108,'jjzd3','jjzd3',NULL,'jjzd3','e10adc3949ba59abbe56e057f20f883e','10108',109,NULL,NULL,NULL,6,604505092,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.135656','2022-01-20 11:43:52.769954',NULL),
	(10109,'tjzd3','tjzd3',NULL,'tjzd3','e10adc3949ba59abbe56e057f20f883e','10109',110,NULL,NULL,NULL,6,604505092,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.136693','2022-01-20 11:43:52.769954',NULL),
	(10110,'kss3','kss3',NULL,'kss3','e10adc3949ba59abbe56e057f20f883e','10110',111,NULL,NULL,NULL,6,604505092,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.138167','2022-01-20 11:43:52.769954',NULL),
	(10111,'jls3','jls3',NULL,'jls3','e10adc3949ba59abbe56e057f20f883e','10111',112,NULL,NULL,NULL,6,604505092,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.139019','2022-01-20 11:43:52.769954',NULL),
	(10112,'wazd3','wazd3',NULL,'wazd3','e10adc3949ba59abbe56e057f20f883e','10112',113,NULL,NULL,NULL,6,604505092,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.139727','2022-01-20 11:43:52.769954',NULL),
	(10113,'fkzd3','fkzd3',NULL,'fkzd3','e10adc3949ba59abbe56e057f20f883e','10113',113,NULL,NULL,NULL,6,604505092,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.140355','2022-01-20 11:43:52.769954',NULL),
	(10114,'fzzd3','fzzd3',NULL,'fzzd3','e10adc3949ba59abbe56e057f20f883e','10114',114,NULL,NULL,NULL,6,604505092,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.140943','2022-01-20 11:43:52.769954',NULL),
	(10115,'rkb3','rkb3',NULL,'rkb3','e10adc3949ba59abbe56e057f20f883e','10115',115,NULL,NULL,NULL,6,604505092,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.141530','2022-01-20 11:43:52.769954',NULL),
	(10116,'zqs3','zqs3',NULL,'zqs3','e10adc3949ba59abbe56e057f20f883e','10116',116,NULL,NULL,NULL,6,604505092,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.142117','2022-01-20 11:43:52.769954',NULL),
	(10117,'tmxs3','tmxs3',NULL,'tmxs3','e10adc3949ba59abbe56e057f20f883e','10117',117,NULL,NULL,NULL,6,604505092,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.142706','2022-01-20 11:43:52.769954',NULL),
	(10118,'bzs3','bzs3',NULL,'bzs3','e10adc3949ba59abbe56e057f20f883e','10118',118,NULL,NULL,NULL,6,604505092,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.143311','2022-01-20 11:43:52.769954',NULL),
	(10119,'bss3','bss3',NULL,'bss3','e10adc3949ba59abbe56e057f20f883e','10119',119,NULL,NULL,NULL,6,604505092,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.143896','2022-01-20 11:43:52.769954',NULL),
	(10120,'zjxs3','zjxs3',NULL,'zjxs3','e10adc3949ba59abbe56e057f20f883e','10120',120,NULL,NULL,NULL,6,604505092,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.144515','2022-01-20 11:43:52.769954',NULL),
	(10121,'ghxs3','ghxs3',NULL,'ghxs3','e10adc3949ba59abbe56e057f20f883e','10121',121,NULL,NULL,NULL,6,604505092,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.145141','2022-01-20 11:43:52.769954',NULL),
	(10122,'dns3','dns3',NULL,'dns3','e10adc3949ba59abbe56e057f20f883e','10122',122,NULL,NULL,NULL,6,604505092,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.146018','2022-01-20 11:43:52.769954',NULL),
	(10123,'ppzs3','ppzs3',NULL,'ppzs3','e10adc3949ba59abbe56e057f20f883e','10123',123,NULL,NULL,NULL,6,604505092,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.147003','2022-01-20 11:43:52.769954',NULL),
	(10124,'ppxcs3','ppxcs3',NULL,'ppxcs3','e10adc3949ba59abbe56e057f20f883e','10124',124,NULL,NULL,NULL,6,604505092,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.147685','2022-01-20 11:43:52.769954',NULL),
	(10125,'sqs3','sqs3',NULL,'sqs3','e10adc3949ba59abbe56e057f20f883e','10125',125,NULL,NULL,NULL,6,604505092,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.148430','2022-01-20 11:43:52.769954',NULL),
	(10126,'lfs3','lfs3',NULL,'lfs3','e10adc3949ba59abbe56e057f20f883e','10126',126,NULL,NULL,NULL,6,604505092,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.149320','2022-01-20 11:43:52.769954',NULL),
	(10127,'nxs3','nxs3',NULL,'nxs3','e10adc3949ba59abbe56e057f20f883e','10127',127,NULL,NULL,NULL,6,604505092,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.150695','2022-01-20 11:43:52.769954',NULL),
	(10128,'jns3','jns3',NULL,'jns3','e10adc3949ba59abbe56e057f20f883e','10128',128,NULL,NULL,NULL,6,604505092,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.152982','2022-01-20 11:43:52.769954',NULL),
	(10129,'ses3','ses3',NULL,'ses3','e10adc3949ba59abbe56e057f20f883e','10129',129,NULL,NULL,NULL,6,604505092,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.165673','2022-01-20 11:43:52.769954',NULL),
	(10130,'jass3','jass3',NULL,'jass3','e10adc3949ba59abbe56e057f20f883e','10130',130,NULL,NULL,NULL,6,604505092,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.167011','2022-01-20 11:43:52.769954',NULL),
	(10131,'cjds3','cjds3',NULL,'cjds3','e10adc3949ba59abbe56e057f20f883e','10131',131,NULL,NULL,NULL,6,604505092,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.167992','2022-01-20 11:43:52.769954',NULL),
	(20110,'jjzd','jjzd',NULL,'jjzd','e10adc3949ba59abbe56e057f20f883e','60010',109,NULL,NULL,NULL,3,621741324,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.051568','2022-01-20 11:43:52.769954',NULL),
	(20111,'tjzd','tjzd',NULL,'tjzd','e10adc3949ba59abbe56e057f20f883e','60011',110,NULL,NULL,NULL,3,621741324,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.052555','2022-01-20 11:43:52.769954',NULL),
	(20112,'kss','kss',NULL,'kss','e10adc3949ba59abbe56e057f20f883e','60012',111,NULL,NULL,NULL,3,621741324,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.053622','2022-01-20 11:43:52.769954',NULL),
	(20113,'jls','jls',NULL,'jls','e10adc3949ba59abbe56e057f20f883e','60013',112,NULL,NULL,NULL,3,621741324,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.054883','2022-01-20 11:43:52.769954',NULL),
	(20114,'wazd','wazd',NULL,'wazd','e10adc3949ba59abbe56e057f20f883e','60014',113,NULL,NULL,NULL,3,621741324,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.060479','2022-01-20 11:43:52.769954',NULL),
	(20115,'fkzd','fkzd',NULL,'fkzd','e10adc3949ba59abbe56e057f20f883e','60015',113,NULL,NULL,NULL,3,621741324,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.061619','2022-01-20 11:43:52.769954',NULL),
	(20116,'fzzd','fzzd',NULL,'fzzd','e10adc3949ba59abbe56e057f20f883e','60016',114,NULL,NULL,NULL,3,621741324,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.063398','2022-01-20 11:43:52.769954',NULL),
	(20117,'rkb','rkb',NULL,'rkb','e10adc3949ba59abbe56e057f20f883e','60017',115,NULL,NULL,NULL,3,621741324,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.064544','2022-01-20 11:43:52.769954',NULL),
	(20118,'zqs','zqs',NULL,'zqs','e10adc3949ba59abbe56e057f20f883e','60018',116,NULL,NULL,NULL,3,621741324,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.065980','2022-01-20 11:43:52.769954',NULL),
	(20119,'tmxs','tmxs',NULL,'tmxs','e10adc3949ba59abbe56e057f20f883e','60019',117,NULL,NULL,NULL,3,621741324,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.067406','2022-01-20 11:43:52.769954',NULL),
	(20120,'bzs','bzs',NULL,'bzs','e10adc3949ba59abbe56e057f20f883e','60020',118,NULL,NULL,NULL,3,621741324,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.068670','2022-01-20 11:43:52.769954',NULL),
	(20121,'bss','bss',NULL,'bss','e10adc3949ba59abbe56e057f20f883e','60021',119,NULL,NULL,NULL,3,621741324,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.070434','2022-01-20 11:43:52.769954',NULL),
	(20122,'zjxs','zjxs',NULL,'zjxs','e10adc3949ba59abbe56e057f20f883e','60022',120,NULL,NULL,NULL,3,621741324,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.071528','2022-01-20 11:43:52.769954',NULL),
	(20123,'ghxs','ghxs',NULL,'ghxs','e10adc3949ba59abbe56e057f20f883e','60023',121,NULL,NULL,NULL,3,621741324,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.072564','2022-01-20 11:43:52.769954',NULL),
	(20124,'dns','dns',NULL,'dns','e10adc3949ba59abbe56e057f20f883e','60024',122,NULL,NULL,NULL,3,621741324,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.073480','2022-01-20 11:43:52.769954',NULL),
	(20125,'ppzs','ppzs',NULL,'ppzs','e10adc3949ba59abbe56e057f20f883e','60025',123,NULL,NULL,NULL,3,621741324,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.074292','2022-01-20 11:43:52.769954',NULL),
	(20126,'ppxcs','ppxcs',NULL,'ppxcs','e10adc3949ba59abbe56e057f20f883e','60026',124,NULL,NULL,NULL,3,621741324,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.075014','2022-01-20 11:43:52.769954',NULL),
	(20127,'sqs','sqs',NULL,'sqs','e10adc3949ba59abbe56e057f20f883e','60027',125,NULL,NULL,NULL,3,621741324,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.075730','2022-01-20 11:43:52.769954',NULL),
	(20128,'lfs','lfs',NULL,'lfs','e10adc3949ba59abbe56e057f20f883e','60028',126,NULL,NULL,NULL,3,621741324,NULL,NULL,NULL,NULL,NULL,'http://www.bba.com/1.jpg',0,0,'2022-01-20 10:04:43.076722','2022-01-20 11:43:52.769954',NULL),
	(20129,'nxs','nxs',NULL,'nxs','e10adc3949ba59abbe56e057f20f883e','60029',127,NULL,NULL,NULL,3,621741324,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.077722','2022-01-20 11:43:52.769954',NULL),
	(20130,'jns','jns',NULL,'jns','e10adc3949ba59abbe56e057f20f883e','60030',128,NULL,NULL,NULL,3,621741324,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.079120','2022-01-20 11:43:52.769954',NULL),
	(20131,'ses','ses',NULL,'ses','e10adc3949ba59abbe56e057f20f883e','60031',129,NULL,NULL,NULL,3,621741324,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.080752','2022-01-20 11:43:52.769954',NULL),
	(20132,'jass','jass',NULL,'jass','e10adc3949ba59abbe56e057f20f883e','60032',130,NULL,NULL,NULL,3,621741324,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.081998','2022-01-20 11:43:52.769954',NULL),
	(20133,'cjds','cjds',NULL,'cjds','e10adc3949ba59abbe56e057f20f883e','60033',131,NULL,NULL,NULL,3,621741324,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.083307','2022-01-20 11:43:52.769954',NULL),
	(20212,'zzc','zzc',NULL,'zzc','e10adc3949ba59abbe56e057f20f883e','60212',102,NULL,NULL,NULL,3,621741324,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.037970','2022-01-20 11:43:52.769954',NULL),
	(20213,'jbc','jbc',NULL,'jbc','e10adc3949ba59abbe56e057f20f883e','60213',103,NULL,NULL,NULL,3,621741324,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.041474','2022-01-20 11:43:52.769954',NULL),
	(20214,'kjk','kjk',NULL,'kjk','e10adc3949ba59abbe56e057f20f883e','60214',103,NULL,NULL,NULL,3,621741324,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.043963','2022-01-24 17:46:44.000000',NULL),
	(20215,'gbc','gbc',NULL,'gbc','e10adc3949ba59abbe56e057f20f883e','60215',104,NULL,NULL,NULL,3,621741324,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.045287','2022-01-20 11:43:52.769954',NULL),
	(20216,'jzzd','jzzd',NULL,'jzzd','e10adc3949ba59abbe56e057f20f883e','60216',105,NULL,NULL,NULL,3,621741324,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.046840','2022-01-20 11:43:52.769954',NULL),
	(20217,'zazd','zazd',NULL,'zazd','e10adc3949ba59abbe56e057f20f883e','60217',106,NULL,NULL,NULL,3,621741324,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.048362','2022-01-20 11:43:52.769954',NULL),
	(20218,'xzzd','xzzd',NULL,'xzzd','e10adc3949ba59abbe56e057f20f883e','60218',107,NULL,NULL,NULL,3,621741324,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.049533','2022-01-20 11:43:52.769954',NULL),
	(20219,'crjb','crjb',NULL,'crjb','e10adc3949ba59abbe56e057f20f883e','60219',108,NULL,NULL,NULL,3,621741324,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.050527','2022-01-20 11:43:52.769954',NULL),
	(100132,'zhc4','zhc4',NULL,'zhc4','e10adc3949ba59abbe56e057f20f883e','100132',101,NULL,NULL,NULL,7,655242316,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.169566','2022-02-22 17:56:01.000000',NULL),
	(100133,'zzc4','zzc4',NULL,'zzc4','e10adc3949ba59abbe56e057f20f883e','100133',102,NULL,NULL,NULL,7,655242316,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.173046','2022-01-20 11:43:52.769954',NULL),
	(100134,'jbc4','jbc4',NULL,'jbc4','e10adc3949ba59abbe56e057f20f883e','100134',103,NULL,NULL,NULL,7,655242316,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.174341','2022-01-20 11:43:52.769954',NULL),
	(100135,'kjk4','kjk4',NULL,'kjk4','e10adc3949ba59abbe56e057f20f883e','100135',103,NULL,NULL,NULL,7,655242316,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.175321','2022-01-20 11:43:52.769954',NULL),
	(100136,'gbc4','gbc4',NULL,'gbc4','e10adc3949ba59abbe56e057f20f883e','100136',104,NULL,NULL,NULL,7,655242316,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.176765','2022-01-20 11:43:52.769954',NULL),
	(100137,'jzzd4','jzzd4',NULL,'jzzd4','e10adc3949ba59abbe56e057f20f883e','100137',105,NULL,NULL,NULL,7,655242316,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.178377','2022-01-20 11:43:52.769954',NULL),
	(100138,'zazd4','zazd4',NULL,'zazd4','e10adc3949ba59abbe56e057f20f883e','100138',106,NULL,NULL,NULL,7,655242316,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.179647','2022-01-20 11:43:52.769954',NULL),
	(100139,'xzzd4','xzzd4',NULL,'xzzd4','e10adc3949ba59abbe56e057f20f883e','100139',107,NULL,NULL,NULL,7,655242316,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.180818','2022-01-20 11:43:52.769954',NULL),
	(100140,'crjb4','crjb4',NULL,'crjb4','e10adc3949ba59abbe56e057f20f883e','100140',108,NULL,NULL,NULL,7,655242316,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.182086','2022-01-20 11:43:52.769954',NULL),
	(100141,'jjzd4','jjzd4',NULL,'jjzd4','e10adc3949ba59abbe56e057f20f883e','100141',109,NULL,NULL,NULL,7,655242316,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.183615','2022-01-20 11:43:52.769954',NULL),
	(100142,'tjzd4','tjzd4',NULL,'tjzd4','e10adc3949ba59abbe56e057f20f883e','100142',110,NULL,NULL,NULL,7,655242316,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.184749','2022-01-20 11:43:52.769954',NULL),
	(100143,'kss4','kss4',NULL,'kss4','e10adc3949ba59abbe56e057f20f883e','100143',111,NULL,NULL,NULL,7,655242316,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.185686','2022-01-20 11:43:52.769954',NULL),
	(100144,'jls4','jls4',NULL,'jls4','e10adc3949ba59abbe56e057f20f883e','100144',112,NULL,NULL,NULL,7,655242316,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.186916','2022-01-20 11:43:52.769954',NULL),
	(100145,'wazd4','wazd4',NULL,'wazd4','e10adc3949ba59abbe56e057f20f883e','100145',113,NULL,NULL,NULL,7,655242316,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.188258','2022-01-20 11:43:52.769954',NULL),
	(100146,'fkzd4','fkzd4',NULL,'fkzd4','e10adc3949ba59abbe56e057f20f883e','100146',113,NULL,NULL,NULL,7,655242316,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.189243','2022-01-20 11:43:52.769954',NULL),
	(100147,'fzzd4','fzzd4',NULL,'fzzd4','e10adc3949ba59abbe56e057f20f883e','100147',114,NULL,NULL,NULL,7,655242316,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.190135','2022-01-20 11:43:52.769954',NULL),
	(100148,'rkb4','rkb4',NULL,'rkb4','e10adc3949ba59abbe56e057f20f883e','100148',115,NULL,NULL,NULL,7,655242316,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.190995','2022-01-20 11:43:52.769954',NULL),
	(100149,'zqs4','zqs4',NULL,'zqs4','e10adc3949ba59abbe56e057f20f883e','100149',116,NULL,NULL,NULL,7,655242316,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.191958','2022-01-20 11:43:52.769954',NULL),
	(100150,'tmxs4','tmxs4',NULL,'tmxs4','e10adc3949ba59abbe56e057f20f883e','100150',117,NULL,NULL,NULL,7,655242316,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.192874','2022-01-20 11:43:52.769954',NULL),
	(100151,'bzs4','bzs4',NULL,'bzs4','e10adc3949ba59abbe56e057f20f883e','100151',118,NULL,NULL,NULL,7,655242316,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.193854','2022-01-20 11:43:52.769954',NULL),
	(100152,'bss4','bss4',NULL,'bss4','e10adc3949ba59abbe56e057f20f883e','100152',119,NULL,NULL,NULL,7,655242316,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.195056','2022-01-20 11:43:52.769954',NULL),
	(100153,'zjxs4','zjxs4',NULL,'zjxs4','e10adc3949ba59abbe56e057f20f883e','100153',120,NULL,NULL,NULL,7,655242316,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.196559','2022-01-20 11:43:52.769954',NULL),
	(100154,'ghxs4','ghxs4',NULL,'ghxs4','e10adc3949ba59abbe56e057f20f883e','100154',121,NULL,NULL,NULL,7,655242316,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.197886','2022-01-20 11:43:52.769954',NULL),
	(100155,'dns4','dns4',NULL,'dns4','e10adc3949ba59abbe56e057f20f883e','100155',122,NULL,NULL,NULL,7,655242316,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.199473','2022-01-20 11:43:52.769954',NULL),
	(100156,'ppzs4','ppzs4',NULL,'ppzs4','e10adc3949ba59abbe56e057f20f883e','100156',123,NULL,NULL,NULL,7,655242316,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.200505','2022-01-20 11:43:52.769954',NULL),
	(100157,'ppxcs4','ppxcs4',NULL,'ppxcs4','e10adc3949ba59abbe56e057f20f883e','100157',124,NULL,NULL,NULL,7,655242316,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.201432','2022-01-20 11:43:52.769954',NULL),
	(100158,'sqs4','sqs4',NULL,'sqs4','e10adc3949ba59abbe56e057f20f883e','100158',125,NULL,NULL,NULL,7,655242316,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.202273','2022-01-20 11:43:52.769954',NULL),
	(100159,'lfs4','lfs4',NULL,'lfs4','e10adc3949ba59abbe56e057f20f883e','100159',126,NULL,NULL,NULL,7,655242316,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.203103','2022-01-20 11:43:52.769954',NULL),
	(100160,'nxs4','nxs4',NULL,'nxs4','e10adc3949ba59abbe56e057f20f883e','100160',127,NULL,NULL,NULL,7,655242316,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.205309','2022-01-20 11:43:52.769954',NULL),
	(100161,'jns4','jns4',NULL,'jns4','e10adc3949ba59abbe56e057f20f883e','100161',128,NULL,NULL,NULL,7,655242316,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.206951','2022-01-20 11:43:52.769954',NULL),
	(100162,'ses4','ses4',NULL,'ses4','e10adc3949ba59abbe56e057f20f883e','100162',129,NULL,NULL,NULL,7,655242316,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.207911','2022-01-20 11:43:52.769954',NULL),
	(100163,'jass4','jass4',NULL,'jass4','e10adc3949ba59abbe56e057f20f883e','100163',130,NULL,NULL,NULL,7,655242316,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.209108','2022-01-20 11:43:52.769954',NULL),
	(100164,'cjds4','cjds4',NULL,'cjds4','e10adc3949ba59abbe56e057f20f883e','100164',131,NULL,NULL,NULL,7,655242316,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.210643','2022-01-20 11:43:52.769954',NULL),
	(100165,'民警A','民警A',NULL,'民警A','e10adc3949ba59abbe56e057f20f883e','100165',101,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:50.974574','2022-01-20 11:43:52.769954',NULL),
	(100166,'民警B','民警B',NULL,'民警B','e10adc3949ba59abbe56e057f20f883e','100166',101,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:50.980732','2022-01-20 11:43:52.769954',NULL),
	(100167,'民警C','民警C',NULL,'民警C','e10adc3949ba59abbe56e057f20f883e','100167',101,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:50.981666','2022-01-20 11:43:52.769954',NULL),
	(100168,'民警A','民警A',NULL,'民警A','e10adc3949ba59abbe56e057f20f883e','100168',102,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:50.999978','2022-01-20 11:43:52.769954',NULL),
	(100169,'民警B','民警B',NULL,'民警B','e10adc3949ba59abbe56e057f20f883e','100169',102,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.002276','2022-01-20 11:43:52.769954',NULL),
	(100170,'民警C','民警C',NULL,'民警C','e10adc3949ba59abbe56e057f20f883e','100170',102,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.005162','2022-01-20 11:43:52.769954',NULL),
	(100171,'民警A','民警A',NULL,'民警A','e10adc3949ba59abbe56e057f20f883e','100171',103,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.007462','2022-01-20 11:43:52.769954',NULL),
	(100172,'民警B','民警B',NULL,'民警B','e10adc3949ba59abbe56e057f20f883e','100172',103,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.009127','2022-01-20 11:43:52.769954',NULL),
	(100173,'民警C','民警C',NULL,'民警C','e10adc3949ba59abbe56e057f20f883e','100173',103,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.010610','2022-01-20 11:43:52.769954',NULL),
	(100174,'民警A','民警A',NULL,'民警A','e10adc3949ba59abbe56e057f20f883e','100174',103,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.011664','2022-01-20 11:43:52.769954',NULL),
	(100175,'民警B','民警B',NULL,'民警B','e10adc3949ba59abbe56e057f20f883e','100175',103,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.012469','2022-01-20 11:43:52.769954',NULL),
	(100176,'民警C','民警C',NULL,'民警C','e10adc3949ba59abbe56e057f20f883e','100176',103,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.013275','2022-01-20 11:43:52.769954',NULL),
	(100177,'民警A','民警A',NULL,'民警A','e10adc3949ba59abbe56e057f20f883e','100177',104,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.014050','2022-01-20 11:43:52.769954',NULL),
	(100178,'民警B','民警B',NULL,'民警B','e10adc3949ba59abbe56e057f20f883e','100178',104,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.014945','2022-01-20 11:43:52.769954',NULL),
	(100179,'民警C','民警C',NULL,'民警C','e10adc3949ba59abbe56e057f20f883e','100179',104,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.016013','2022-01-20 11:43:52.769954',NULL),
	(100180,'民警A','民警A',NULL,'民警A','e10adc3949ba59abbe56e057f20f883e','100180',105,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.016955','2022-01-20 11:43:52.769954',NULL),
	(100181,'民警B','民警B',NULL,'民警B','e10adc3949ba59abbe56e057f20f883e','100181',105,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.018208','2022-01-20 11:43:52.769954',NULL),
	(100182,'民警C','民警C',NULL,'民警C','e10adc3949ba59abbe56e057f20f883e','100182',105,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.020611','2022-01-20 11:43:52.769954',NULL),
	(100183,'民警A','民警A',NULL,'民警A','e10adc3949ba59abbe56e057f20f883e','100183',106,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.021686','2022-01-20 11:43:52.769954',NULL),
	(100184,'民警B','民警B',NULL,'民警B','e10adc3949ba59abbe56e057f20f883e','100184',106,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.022657','2022-01-20 11:43:52.769954',NULL),
	(100185,'民警C','民警C',NULL,'民警C','e10adc3949ba59abbe56e057f20f883e','100185',106,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.023656','2022-01-20 11:43:52.769954',NULL),
	(100186,'民警A','民警A',NULL,'民警A','e10adc3949ba59abbe56e057f20f883e','100186',107,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.024628','2022-01-20 11:43:52.769954',NULL),
	(100187,'民警B','民警B',NULL,'民警B','e10adc3949ba59abbe56e057f20f883e','100187',107,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.025575','2022-01-20 11:43:52.769954',NULL),
	(100188,'民警C','民警C',NULL,'民警C','e10adc3949ba59abbe56e057f20f883e','100188',107,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.026495','2022-01-20 11:43:52.769954',NULL),
	(100189,'民警A','民警A',NULL,'民警A','e10adc3949ba59abbe56e057f20f883e','100189',108,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.027411','2022-01-20 11:43:52.769954',NULL),
	(100190,'民警B','民警B',NULL,'民警B','e10adc3949ba59abbe56e057f20f883e','100190',108,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.028546','2022-01-20 11:43:52.769954',NULL),
	(100191,'民警C','民警C',NULL,'民警C','e10adc3949ba59abbe56e057f20f883e','100191',108,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.029519','2022-01-20 11:43:52.769954',NULL),
	(100192,'民警A','民警A',NULL,'民警A','e10adc3949ba59abbe56e057f20f883e','100192',109,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.030374','2022-01-20 11:43:52.769954',NULL),
	(100193,'民警B','民警B',NULL,'民警B','e10adc3949ba59abbe56e057f20f883e','100193',109,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.031397','2022-01-20 11:43:52.769954',NULL),
	(100194,'民警C','民警C',NULL,'民警C','e10adc3949ba59abbe56e057f20f883e','100194',109,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.032249','2022-01-20 11:43:52.769954',NULL),
	(100195,'民警A','民警A',NULL,'民警A','e10adc3949ba59abbe56e057f20f883e','100195',110,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.033036','2022-01-20 11:43:52.769954',NULL),
	(100196,'民警B','民警B',NULL,'民警B','e10adc3949ba59abbe56e057f20f883e','100196',110,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.033854','2022-01-20 11:43:52.769954',NULL),
	(100197,'民警C','民警C',NULL,'民警C','e10adc3949ba59abbe56e057f20f883e','100197',110,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.034691','2022-01-20 11:43:52.769954',NULL),
	(100198,'民警A','民警A',NULL,'民警A','e10adc3949ba59abbe56e057f20f883e','100198',111,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.035546','2022-01-20 11:43:52.769954',NULL),
	(100199,'民警B','民警B',NULL,'民警B','e10adc3949ba59abbe56e057f20f883e','100199',111,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.036389','2022-01-20 11:43:52.769954',NULL),
	(100200,'民警C','民警C',NULL,'民警C','e10adc3949ba59abbe56e057f20f883e','100200',111,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.037175','2022-01-20 11:43:52.769954',NULL),
	(100201,'民警A','民警A',NULL,'民警A','e10adc3949ba59abbe56e057f20f883e','100201',112,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.037955','2022-01-20 11:43:52.769954',NULL),
	(100202,'民警B','民警B',NULL,'民警B','e10adc3949ba59abbe56e057f20f883e','100202',112,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.038738','2022-01-20 11:43:52.769954',NULL),
	(100203,'民警C','民警C',NULL,'民警C','e10adc3949ba59abbe56e057f20f883e','100203',112,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.039532','2022-01-20 11:43:52.769954',NULL),
	(100204,'民警A','民警A',NULL,'民警A','e10adc3949ba59abbe56e057f20f883e','100204',113,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.040318','2022-01-20 11:43:52.769954',NULL),
	(100205,'民警B','民警B',NULL,'民警B','e10adc3949ba59abbe56e057f20f883e','100205',113,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.041138','2022-01-20 11:43:52.769954',NULL),
	(100206,'民警C','民警C',NULL,'民警C','e10adc3949ba59abbe56e057f20f883e','100206',113,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.042122','2022-01-20 11:43:52.769954',NULL),
	(100207,'民警A','民警A',NULL,'民警A','e10adc3949ba59abbe56e057f20f883e','100207',113,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.043145','2022-01-20 11:43:52.769954',NULL),
	(100208,'民警B','民警B',NULL,'民警B','e10adc3949ba59abbe56e057f20f883e','100208',113,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.044117','2022-01-20 11:43:52.769954',NULL),
	(100209,'民警C','民警C',NULL,'民警C','e10adc3949ba59abbe56e057f20f883e','100209',113,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.045753','2022-01-20 11:43:52.769954',NULL),
	(100210,'民警A','民警A',NULL,'民警A','e10adc3949ba59abbe56e057f20f883e','100210',114,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.046956','2022-01-20 11:43:52.769954',NULL),
	(100211,'民警B','民警B',NULL,'民警B','e10adc3949ba59abbe56e057f20f883e','100211',114,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.048725','2022-01-20 11:43:52.769954',NULL),
	(100212,'民警C','民警C',NULL,'民警C','e10adc3949ba59abbe56e057f20f883e','100212',114,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.049797','2022-01-20 11:43:52.769954',NULL),
	(100213,'民警A','民警A',NULL,'民警A','e10adc3949ba59abbe56e057f20f883e','100213',115,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.050753','2022-01-20 11:43:52.769954',NULL),
	(100214,'民警B','民警B',NULL,'民警B','e10adc3949ba59abbe56e057f20f883e','100214',115,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.051946','2022-01-20 11:43:52.769954',NULL),
	(100215,'民警C','民警C',NULL,'民警C','e10adc3949ba59abbe56e057f20f883e','100215',115,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.052765','2022-01-20 11:43:52.769954',NULL),
	(100216,'民警A','民警A',NULL,'民警A','e10adc3949ba59abbe56e057f20f883e','100216',116,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.053572','2022-01-20 11:43:52.769954',NULL),
	(100217,'民警B','民警B',NULL,'民警B','e10adc3949ba59abbe56e057f20f883e','100217',116,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.054347','2022-01-20 11:43:52.769954',NULL),
	(100218,'民警C','民警C',NULL,'民警C','e10adc3949ba59abbe56e057f20f883e','100218',116,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.055133','2022-01-20 11:43:52.769954',NULL),
	(100219,'民警A','民警A',NULL,'民警A','e10adc3949ba59abbe56e057f20f883e','100219',117,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.055921','2022-01-20 11:43:52.769954',NULL),
	(100220,'民警B','民警B',NULL,'民警B','e10adc3949ba59abbe56e057f20f883e','100220',117,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.056873','2022-01-20 11:43:52.769954',NULL),
	(100221,'民警C','民警C',NULL,'民警C','e10adc3949ba59abbe56e057f20f883e','100221',117,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.057738','2022-01-20 11:43:52.769954',NULL),
	(100222,'民警A','民警A',NULL,'民警A','e10adc3949ba59abbe56e057f20f883e','100222',118,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.058615','2022-01-20 11:43:52.769954',NULL),
	(100223,'民警B','民警B',NULL,'民警B','e10adc3949ba59abbe56e057f20f883e','100223',118,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.059469','2022-01-20 11:43:52.769954',NULL),
	(100224,'民警C','民警C',NULL,'民警C','e10adc3949ba59abbe56e057f20f883e','100224',118,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.060335','2022-01-20 11:43:52.769954',NULL),
	(100225,'民警A','民警A',NULL,'民警A','e10adc3949ba59abbe56e057f20f883e','100225',119,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.061214','2022-01-20 11:43:52.769954',NULL),
	(100226,'民警B','民警B',NULL,'民警B','e10adc3949ba59abbe56e057f20f883e','100226',119,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.062181','2022-01-20 11:43:52.769954',NULL),
	(100227,'民警C','民警C',NULL,'民警C','e10adc3949ba59abbe56e057f20f883e','100227',119,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.063229','2022-01-20 11:43:52.769954',NULL),
	(100228,'民警A','民警A',NULL,'民警A','e10adc3949ba59abbe56e057f20f883e','100228',120,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.065296','2022-01-20 11:43:52.769954',NULL),
	(100229,'民警B','民警B',NULL,'民警B','e10adc3949ba59abbe56e057f20f883e','100229',120,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.066628','2022-01-20 11:43:52.769954',NULL),
	(100230,'民警C','民警C',NULL,'民警C','e10adc3949ba59abbe56e057f20f883e','100230',120,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.068155','2022-01-20 11:43:52.769954',NULL),
	(100231,'民警A','民警A',NULL,'民警A','e10adc3949ba59abbe56e057f20f883e','100231',121,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.069929','2022-01-20 11:43:52.769954',NULL),
	(100232,'民警B','民警B',NULL,'民警B','e10adc3949ba59abbe56e057f20f883e','100232',121,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.072507','2022-01-20 11:43:52.769954',NULL),
	(100233,'民警C','民警C',NULL,'民警C','e10adc3949ba59abbe56e057f20f883e','100233',121,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.073738','2022-01-20 11:43:52.769954',NULL),
	(100234,'民警A','民警A',NULL,'民警A','e10adc3949ba59abbe56e057f20f883e','100234',122,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.074754','2022-01-20 11:43:52.769954',NULL),
	(100235,'民警B','民警B',NULL,'民警B','e10adc3949ba59abbe56e057f20f883e','100235',122,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.075685','2022-01-20 11:43:52.769954',NULL),
	(100236,'民警C','民警C',NULL,'民警C','e10adc3949ba59abbe56e057f20f883e','100236',122,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.076749','2022-01-20 11:43:52.769954',NULL),
	(100237,'民警A','民警A',NULL,'民警A','e10adc3949ba59abbe56e057f20f883e','100237',123,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.077789','2022-01-20 11:43:52.769954',NULL),
	(100238,'民警B','民警B',NULL,'民警B','e10adc3949ba59abbe56e057f20f883e','100238',123,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.079035','2022-01-20 11:43:52.769954',NULL),
	(100239,'民警C','民警C',NULL,'民警C','e10adc3949ba59abbe56e057f20f883e','100239',123,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.080613','2022-01-20 11:43:52.769954',NULL),
	(100240,'民警A','民警A',NULL,'民警A','e10adc3949ba59abbe56e057f20f883e','100240',124,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.081901','2022-01-20 11:43:52.769954',NULL),
	(100241,'民警B','民警B',NULL,'民警B','e10adc3949ba59abbe56e057f20f883e','100241',124,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.082924','2022-01-20 11:43:52.769954',NULL),
	(100242,'民警C','民警C',NULL,'民警C','e10adc3949ba59abbe56e057f20f883e','100242',124,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.083900','2022-01-20 11:43:52.769954',NULL),
	(100243,'民警A','民警A',NULL,'民警A','e10adc3949ba59abbe56e057f20f883e','100243',125,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.084812','2022-01-20 11:43:52.769954',NULL),
	(100244,'民警B','民警B',NULL,'民警B','e10adc3949ba59abbe56e057f20f883e','100244',125,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.085803','2022-01-20 11:43:52.769954',NULL),
	(100245,'民警C','民警C',NULL,'民警C','e10adc3949ba59abbe56e057f20f883e','100245',125,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.086761','2022-01-20 11:43:52.769954',NULL),
	(100246,'民警A','民警A',NULL,'民警A','e10adc3949ba59abbe56e057f20f883e','100246',126,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.087650','2022-01-20 11:43:52.769954',NULL),
	(100247,'民警B','民警B',NULL,'民警B','e10adc3949ba59abbe56e057f20f883e','100247',126,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.088678','2022-01-20 11:43:52.769954',NULL),
	(100248,'民警C','民警C',NULL,'民警C','e10adc3949ba59abbe56e057f20f883e','100248',126,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.089887','2022-01-20 11:43:52.769954',NULL),
	(100249,'民警A','民警A',NULL,'民警A','e10adc3949ba59abbe56e057f20f883e','100249',127,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.090938','2022-01-20 11:43:52.769954',NULL),
	(100250,'民警B','民警B',NULL,'民警B','e10adc3949ba59abbe56e057f20f883e','100250',127,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.091873','2022-01-20 11:43:52.769954',NULL),
	(100251,'民警C','民警C',NULL,'民警C','e10adc3949ba59abbe56e057f20f883e','100251',127,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.092808','2022-01-20 11:43:52.769954',NULL),
	(100252,'民警A','民警A',NULL,'民警A','e10adc3949ba59abbe56e057f20f883e','100252',128,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.093932','2022-01-20 11:43:52.769954',NULL),
	(100253,'民警B','民警B',NULL,'民警B','e10adc3949ba59abbe56e057f20f883e','100253',128,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.098456','2022-01-20 11:43:52.769954',NULL),
	(100254,'民警C','民警C',NULL,'民警C','e10adc3949ba59abbe56e057f20f883e','100254',128,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.099828','2022-01-20 11:43:52.769954',NULL),
	(100255,'民警A','民警A',NULL,'民警A','e10adc3949ba59abbe56e057f20f883e','100255',129,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.101207','2022-01-20 11:43:52.769954',NULL),
	(100256,'民警B','民警B',NULL,'民警B','e10adc3949ba59abbe56e057f20f883e','100256',129,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.102983','2022-01-20 11:43:52.769954',NULL),
	(100257,'民警C','民警C',NULL,'民警C','e10adc3949ba59abbe56e057f20f883e','100257',129,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.104813','2022-01-20 11:43:52.769954',NULL),
	(100258,'民警A','民警A',NULL,'民警A','e10adc3949ba59abbe56e057f20f883e','100258',130,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.105916','2022-01-20 11:43:52.769954',NULL),
	(100259,'民警B','民警B',NULL,'民警B','e10adc3949ba59abbe56e057f20f883e','100259',130,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.106938','2022-01-20 11:43:52.769954',NULL),
	(100260,'民警C','民警C',NULL,'民警C','e10adc3949ba59abbe56e057f20f883e','100260',130,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.107794','2022-01-20 11:43:52.769954',NULL),
	(100261,'民警A','民警A',NULL,'民警A','e10adc3949ba59abbe56e057f20f883e','100261',131,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.108700','2022-01-20 11:43:52.769954',NULL),
	(100262,'民警B','民警B',NULL,'民警B','e10adc3949ba59abbe56e057f20f883e','100262',131,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.109582','2022-01-20 11:43:52.769954',NULL),
	(100263,'民警C','民警C',NULL,'民警C','e10adc3949ba59abbe56e057f20f883e','100263',131,NULL,NULL,NULL,6,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:51.110452','2022-01-20 11:43:52.769954',NULL),
	(100330,'zhc','zhc',NULL,'zhc','e10adc3949ba59abbe56e057f20f883e','100330',101,NULL,NULL,NULL,3,621741324,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.014221','2022-07-04 11:47:41.000000',NULL),
	(1000009,'jw','jw',NULL,'jw','e10adc3949ba59abbe56e057f20f883e','1000009',101,NULL,NULL,NULL,1,3388996344,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2022-01-20 10:04:43.014221','2022-07-04 11:47:21.000000',NULL);

/*!40000 ALTER TABLE `user_account` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table user_org
# ------------------------------------------------------------

DROP TABLE IF EXISTS `user_org`;

CREATE TABLE `user_org` (
  `id` int NOT NULL COMMENT '所属机构Id',
  `code` varchar(64) NOT NULL COMMENT '所属机构编码',
  `name` varchar(64) NOT NULL COMMENT '机构全称/部门',
  `createdAt` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updatedAt` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  `deletedAt` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

LOCK TABLES `user_org` WRITE;
/*!40000 ALTER TABLE `user_org` DISABLE KEYS */;

INSERT INTO `user_org` (`id`, `code`, `name`, `createdAt`, `updatedAt`, `deletedAt`)
VALUES
	(1,'code-111','特警支队','2021-11-23 03:04:27.448254','2021-11-29 22:20:03.653474','2021-11-28 16:46:10.690668'),
	(2,'code-112','大宁路派出所','2021-11-23 03:04:27.448254','2021-11-29 22:20:03.653474','2021-11-28 16:46:10.690668'),
	(3,'code-113','天目西路派出所','2021-11-23 03:04:27.448254','2021-11-29 22:20:03.653474','2021-11-28 16:46:10.690668'),
	(4,'code-114','静安寺派出所','2021-11-23 03:04:27.448254','2021-11-29 22:20:03.653474','2021-11-28 16:46:10.690668'),
	(5,'code-115','纪委部门','2021-11-23 03:04:27.448254','2021-11-23 03:04:27.448254',NULL),
	(6,'code-116','测试部门','2021-11-23 03:04:27.448254','2021-12-16 09:44:32.644465',NULL),
	(7,'code-117','JLS部门','2021-11-23 03:04:27.448254','2021-11-29 22:20:03.653474','2021-11-28 16:46:10.690668'),
	(8,'code-118','BSLPCS部门','2021-11-23 03:04:27.448254','2021-11-29 22:20:03.653474','2021-11-28 16:46:10.690668'),
	(9,'code-19','开发测试部','2021-11-23 03:04:27.448254','2021-11-29 22:20:03.653474','2021-11-28 16:46:10.690668'),
	(101,'code-101','指挥处','2021-11-29 21:56:38.055831','2021-11-29 21:56:38.055831',NULL),
	(102,'code-102','政治处','2021-11-29 21:56:38.093068','2021-11-29 21:56:38.093068',NULL),
	(103,'code-103','科技科','2021-11-29 21:56:38.134087','2021-12-29 20:40:44.068949',NULL),
	(104,'code-104','有关部门一','2021-11-29 21:56:38.174703','2021-11-29 21:56:38.174703',NULL),
	(105,'code-105','经侦支队','2021-11-29 21:56:38.216316','2021-11-29 21:56:38.216316',NULL),
	(106,'code-106','治安支队','2021-11-29 21:56:38.254313','2021-11-29 21:56:38.254313',NULL),
	(107,'code-107','刑侦支队','2021-11-29 21:56:38.291592','2021-11-29 21:56:38.291592',NULL),
	(108,'code-108','出入境办','2021-11-29 21:56:38.329584','2021-11-29 21:56:38.329584',NULL),
	(109,'code-109','交警支队','2021-11-29 21:56:38.367837','2021-11-29 21:56:38.367837',NULL),
	(110,'code-110','特警支队','2021-11-29 21:56:38.406207','2021-11-29 21:56:38.406207',NULL),
	(111,'code-111','看守所','2021-11-29 21:56:38.445324','2021-11-29 21:56:38.445324',NULL),
	(112,'code-112','拘留所','2021-11-29 21:56:38.495240','2021-11-29 21:56:38.495240',NULL),
	(113,'code-113','有关部门三','2021-11-29 21:56:38.542861','2021-12-29 20:39:39.159945',NULL),
	(114,'code-114','法制支队','2021-11-29 21:56:38.599851','2021-11-29 21:56:38.599851',NULL),
	(115,'code-115','人口办','2021-11-29 21:56:38.649857','2021-11-29 21:56:38.649857',NULL),
	(116,'code-116','站区所','2021-11-29 21:56:38.687226','2021-11-29 21:56:38.687226',NULL),
	(117,'code-117','天目西所','2021-11-29 21:56:38.725604','2021-11-29 21:56:38.725604',NULL),
	(118,'code-118','北站所','2021-11-29 21:56:38.762336','2021-11-29 21:56:38.762336',NULL),
	(119,'code-119','宝山所','2021-11-29 21:56:38.800612','2021-11-29 21:56:38.800612',NULL),
	(120,'code-120','芷江西所','2021-11-29 21:56:38.839563','2021-11-29 21:56:38.839563',NULL),
	(121,'code-121','共和新所','2021-11-29 21:56:38.878841','2021-11-29 21:56:38.878841',NULL),
	(122,'code-122','大宁所','2021-11-29 21:56:38.915362','2021-11-29 21:56:38.915362',NULL),
	(123,'code-123','彭浦镇所','2021-11-29 21:56:38.954851','2021-11-29 21:56:38.954851',NULL),
	(124,'code-124','彭浦新村所','2021-11-29 21:56:38.994231','2021-11-29 21:56:38.994231',NULL),
	(125,'code-125','三泉所','2021-11-29 21:56:39.031122','2021-11-29 21:56:39.031122',NULL),
	(126,'code-126','临汾所','2021-11-29 21:56:39.096002','2021-11-29 21:56:39.096002',NULL),
	(127,'code-127','南西所','2021-11-29 21:56:39.153646','2021-11-29 21:56:39.153646',NULL),
	(128,'code-128','江宁所','2021-11-29 21:56:39.190161','2021-11-29 21:56:39.190161',NULL),
	(129,'code-129','石二所','2021-11-29 21:56:39.226855','2021-11-29 21:56:39.226855',NULL),
	(130,'code-130','静安寺所','2021-11-29 21:56:39.263854','2021-11-29 21:56:39.263854',NULL),
	(131,'code-131','曹家渡所','2021-11-29 21:56:39.302859','2021-11-29 21:56:39.302859',NULL),
	(132,'code-132','督查支队','2021-12-17 12:10:38.663271','2021-12-17 12:10:38.663271',NULL),
	(133,'code-133','有关部门四','2021-12-29 20:43:23.750823','2021-12-29 20:45:56.420061',NULL),
	(134,'code-134','警保处','2021-12-29 20:43:25.458768','2021-12-29 20:43:25.458768',NULL),
	(5350,'code-20','静安分局','2021-11-23 03:05:59.017358','2021-11-23 03:08:05.159006',NULL);

/*!40000 ALTER TABLE `user_org` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table user_purview
# ------------------------------------------------------------

DROP TABLE IF EXISTS `user_purview`;

CREATE TABLE `user_purview` (
  `id` int NOT NULL,
  `moduleName` varchar(50) NOT NULL COMMENT '所属模块',
  `moduleAlias` varchar(50) NOT NULL COMMENT '所属模块别名',
  `action` varchar(50) NOT NULL COMMENT '行为，操作',
  `value` bigint NOT NULL COMMENT '权值',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

LOCK TABLES `user_purview` WRITE;
/*!40000 ALTER TABLE `user_purview` DISABLE KEYS */;

INSERT INTO `user_purview` (`id`, `moduleName`, `moduleAlias`, `action`, `value`)
VALUES
	(1,'四责协同','szxt','新建表单',4),
	(2,'四责协同','szxt','查看部门表单',8),
	(3,'四责协同','szxt','查看所有表单',16),
	(4,'四责协同','szxt','管理部门情况',16777216),
	(5,'任务管理','rwgl','任务下发',32),
	(6,'任务管理','rwgl','查看任务',64),
	(7,'任务管理','rwgl','任务模板管理',128),
	(8,'信息监督','xxjd','新建部门信访',256),
	(9,'信息监督','xxjd','审核部门信访',512),
	(10,'信息监督','xxjd','查看部门信访',1024),
	(11,'信息监督','xxjd','查看所有信访',16384),
	(12,'信息监督','xxjd','新建纪委信访',2048),
	(13,'信息监督','xxjd','审核纪委信访',4096),
	(14,'信息监督','xxjd','查看纪委信访',8192),
	(15,'信息监督','xxjd','新增问题',65536),
	(16,'信息监督','xxjd','问题签收',131072),
	(17,'信息监督','xxjd','查看部门问题',262144),
	(18,'信息监督','xxjd','查看所有问题',32768),
	(19,'档案','dangan','查看部门档案',524288),
	(20,'档案','dangan','查看所有档案',1048576),
	(21,'考核','kaohe','查看考核',4194304),
	(22,'考核','kaohe','修改考核评分',2097152),
	(23,'权限管理','qxgl','权限设置',8388608),
	(24,'信息监督','xxjd','新增日常监督',33554432),
	(25,'信息监督','xxjd','查看部门日常监督',67108864),
	(26,'信息监督','xxjd','查看所有日常监督',134217728),
	(27,'信息监督','xxjd','新增职能监督',268435456),
	(28,'信息监督','xxjd','查看部门职能监督',536870912),
	(29,'信息监督','xxjd','查看所有职能监督',1073741824),
	(30,'信息监督','xxjd','查看监督统计',2147483648);

/*!40000 ALTER TABLE `user_purview` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table user_role
# ------------------------------------------------------------

DROP TABLE IF EXISTS `user_role`;

CREATE TABLE `user_role` (
  `id` int NOT NULL COMMENT '角色Id',
  `name` varchar(50) NOT NULL COMMENT '角色名称',
  `purview` bigint NOT NULL COMMENT '角色默认权值',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

LOCK TABLES `user_role` WRITE;
/*!40000 ALTER TABLE `user_role` DISABLE KEYS */;

INSERT INTO `user_role` (`id`, `name`, `purview`)
VALUES
	(1,'纪委',3388996344),
	(2,'纪委成员',1386720),
	(3,'部门',621741324),
	(4,'一把手',621544452),
	(5,'政工领导',621544452),
	(6,'班子成员',604505092),
	(7,'专职纪检监察干部',655242316);

/*!40000 ALTER TABLE `user_role` ENABLE KEYS */;
UNLOCK TABLES;



/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

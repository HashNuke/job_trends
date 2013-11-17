CREATE TABLE IF NOT EXISTS `stack_jobs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `locations` text DEFAULT NULL,
  `posted_date` datetime,
  `url` varchar(255) NOT NULL,
  `external_job_id` varchar(20) NOT NULL,
  `company` varchar(255) NOT NULL,
  `desc_role` text NOT NULL,
  `desc_qual` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;


CREATE TABLE IF NOT EXISTS `github_jobs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `locations` text DEFAULT NULL,
  `posted_date` datetime,
  `url` varchar(255) NOT NULL,
  `company` varchar(255) NOT NULL,
  `company_url` varchar(255) DEFAULT NULL,
  `company_logo` varchar(255) DEFAULT NULL,
  `external_job_id` varchar(50) NOT NULL,
  `type` varchar(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
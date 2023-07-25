INSERT INTO `addon_account` (`name`, `label`, `shared`) VALUES
	('society_vigne','vineyard',1)
;

INSERT INTO `addon_inventory` (`name`, `label`, `shared`) VALUES
	('society_vigne','vineyard', 1)
;
INSERT INTO `datastore` (`name`, `label`, `shared`) VALUES
	('society_vigne', 'vineyard', 1)
;

INSERT INTO `jobs`(`name`, `label`) VALUES
	('vigne', 'vineyard')
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
	('vigne', 0, 'rookie', 'Rookie', 12, '{}', '{}'),
	('vigne', 1, 'novice', 'Novice', 24, '{}', '{}'),
	('vigne', 2, 'experienced', 'Experienced', 36, '{}', '{}'),
	('vigne', 3, 'chief', 'Team Leader', 48, '{}', '{}'),
	('vigne', 4, 'boss', 'Boss', 0, '{}', '{}')
;

-- Check README for items
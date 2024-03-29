INSERT INTO `addon_account` (`name`, `label`, `shared`) VALUES
	('society_vigne','Vigneron',1)
;

INSERT INTO `addon_inventory` (`name`, `label`, `shared`) VALUES
	('society_vigne','Vigneron', 1)
;
INSERT INTO `datastore` (`name`, `label`, `shared`) VALUES
	('society_vigne', 'Vigneron', 1)
;

INSERT INTO `jobs`(`name`, `label`, `whitelisted`) VALUES
	('vigne', 'Vigneron', 1)
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
	('vigne', 0, 'rookie', 'Recrue', 12, '{}', '{}'),
	('vigne', 1, 'novice', 'Novice', 24, '{}', '{}'),
	('vigne', 2, 'experienced', 'Expérimenté', 36, '{}', '{}'),
	('vigne', 3, 'chief', "Chef d\'équipe", 48, '{}', '{}'),
	('vigne', 4, 'boss', 'Patron', 0, '{}', '{}')
;

-- Check README for items
-- Data Exploration
SELECT
	*
FROM
	nashhouse;
-- ---------------------------------------------------------------------------------------------------------
-- 1. Standardize Date Format
SELECT
	sale_date
FROM
	nashhouse;
    
    
UPDATE nashhouse
SET sale_date = DATE(saledate);
-- ----------------------------------------------------------------------------------------------------------
-- 3. Breaking out  Property address into individual columns (address, city,state)
SELECT
	SUBSTRING(PropertyAddress, 1, POSITION(',' IN PropertyAddress)-1) AS Address,
    SUBSTRING(PropertyAddress, POSITION(',' IN PropertyAddress) +1, length(PropertyAddress)) AS City
FROM
	nashhouse;
    
    ALTER TABLE nashhouse
ADD Prop_Address  nvarchar(255);

UPDATE nashhouse
SET Prop_Address = SUBSTRING(PropertyAddress, 1, POSITION(',' IN PropertyAddress)-1);

ALTER TABLE nashhouse
ADD Prop_City nvarchar(255);

UPDATE nashhouse
SET Prop_City = SUBSTRING(PropertyAddress, POSITION(',' IN PropertyAddress) +1, length(PropertyAddress));
-- -------------------------------------------------------------------------------------------------------------
-- 4. Splitting Owner Address column into Address and City Columns

SELECT
	OwnerAddress,
    SUBSTRING(OwnerAddress, 1, POSITION(',' IN OwnerAddress) -1) AS Owner_Address,
    SUBSTRING(OwnerAddress,  position(',' IN OwnerAddress) +1, length(OwnerAddress)) AS Owner_City
FROM
	nashhouse;
    
ALTER TABLE nashhouse
ADD Owner_address VARCHAR(255);

UPDATE nashhouse
SET Owner_Address = SUBSTRING(OwnerAddress, 1, POSITION(',' IN OwnerAddress) -1);


ALTER TABLE nashhouse
ADD Owner_City VARCHAR(255);

UPDATE nashhouse
SET Owner_City = SUBSTRING(OwnerAddress,  position(',' IN OwnerAddress) +1, length(OwnerAddress));

-- ---------------------------------------------------------------------------------------------------------------
-- 5. Converting 'Y' to 'Yes' and 'N' to 'No' in SoldAsVacant Column
SELECT
	SoldAsVacant,
    CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
		 WHEN SoldAsVacant = 'N' THEN 'No'
         ELSE SoldAsVacant
         END
FROM
	nashhouse;
    
UPDATE nashhouse
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
		 WHEN SoldAsVacant = 'N' THEN 'No'
         ELSE SoldAsVacant
         END;



SELECT 
	DISTINCT(SoldAsVacant),
    COUNT(SoldAsVacant)
FROM
	nashhouse
GROUP BY SoldAsVacant
ORDER BY COUNT(SoldAsVacant) DESC;

-- --------------------------------------------------------------------------------------------------------------
-- 6. Delete Unused Columns

ALTER TABLE nashhouse
DROP COLUMN TaxDistrict;

ALTER TABLE nashhouse
DROP COLUMN PropertyAddress;

ALTER TABLE nashhouse
DROP COLUMN OwnerAddress;

-- ----------------------------------------------------------------------------------------------------------------
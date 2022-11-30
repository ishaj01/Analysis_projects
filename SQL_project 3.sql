/* CLEANING THE NASHVILLE HOUSING DATASET USING SQL	*/

SELECT *
FROM Data

/*Standardize Date format*/

 SELECT SaleDate, CONVERT(Date, SaleDate)
FROM Data

UPDATE Data
SET SaleDate = CONVERT(Date, SaleDate)
 
ALTER TABLE Data
ADD SaleDateConverted Date;
UPDATE Data
SET SaleDateConverted = CONVERT(Date, SaleDate)

-- Breaking out Address into induvidual columns (Address, City)

SELECT PropertyAddress  -- The delimiter is a comma
FROM Data

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) AS Address
FROM Data

ALTER TABLE Data -- Address
ADD OwnerSplitAdress NVARCHAR(255); 
UPDATE Data
SET OwnerSplitAdress = PARSENAME(REPLACE(OwnerAddress,',','.'), 3)


ALTER TABLE Data -- City
ADD OwnerSplitCity NVARCHAR(255); 
UPDATE Data
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'), 2)
 

ALTER TABLE Data -- State
ADD OwnerSplitState NVARCHAR(255);
UPDATE Data
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'), 1) 

-- Changing Y an N to Yes and No in SoldAsVacant field

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM Data
GROUP BY SoldAsVacant
ORDER BY 2


SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes' 
     WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END
FROM Data

UPDATE  Data
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes' 
				   WHEN SoldAsVacant = 'N' THEN 'No'
				   ELSE SoldAsVacant
				   END


-- Removing duplicates  
 ; WITH CTE AS (
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 LegalReference
				 ORDER BY
					UniqueID )
				AS	DuplicateCount				
FROM Data )
--ORDER BY ParcelID 
DELETE FROM CTE
WHERE DuplicateCount > 1;	

--Removing unused columns 

SELECT *
FROM Data
ALTER TABLE Data
DROP COLUMN OwnerAddress, PropertyAddress

ALTER TABLE Data
DROP COLUMN SaleDate






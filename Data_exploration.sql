---Cleaning Data in SQL Queries
Select *
From Dataexploration.dbo.NashvilleHousing

---Standarize Data Format

SELECT SaleDate, CONVERT(Date, SaleDate)
FROM Dataexploration.dbo.NashvilleHousing;


Update NashvilleHousing
SET SaleDate= CONVERT(Date,SaleDate)

--TER TABLE dbo.NashvilleHousing
--d SaleDate Date;

Update dbo.NashvilleHousing
SET SaleDate= CONVERT(Date,SaleDate)

-----Populate Property Address data
Select *
From Dataexploration.dbo.NashvilleHousing
order  by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
From Dataexploration.dbo.NashvilleHousing a
JOIN Dataexploration.dbo.NashvilleHousing b
    on a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From Dataexploration.dbo.NashvilleHousing a
JOIN Dataexploration.dbo.NashvilleHousing b
    on a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is null

---Breaking out Address into individual Columns (Address, city, State)

Select propertyAddress
From Dataexploration.dbo.NashvilleHousing

SELECT
  SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)) as Address
  ,SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1 ,LEN(PropertyAddress)) as Address
 From Dataexploration.dbo.NashvilleHousing

SELECT
    SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS Address,
    CHARINDEX(',', PropertyAddress) AS CommaIndex
FROM Dataexploration.dbo.NashvilleHousing;

SELECT
    SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS Address,
       SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) AS Address
FROM Dataexploration.dbo.NashvilleHousing;

ALTER TABLE dbo.NashvilleHousing
Add PropertySplitAddress Nvarchar(225);

Update dbo.NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE dbo.NashvilleHousing
Add  PropertySplitCity Nvarchar(225);

Update dbo.NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))

Select *
From Dataexploration.dbo.NashvilleHousing

Select OwnerAddress
From Dataexploration.dbo.NashvilleHousing

Select
PARSENAME(OwnerAddress,1)
From Dataexploration.dbo.NashvilleHousing

Select
PARSENAME(REPLACE(OwnerAddress,',','.'),3)
,PARSENAME(REPLACE(OwnerAddress,',','.'),2)
,PARSENAME(REPLACE(OwnerAddress,',','.'),1)
From Dataexploration.dbo.NashvilleHousing


ALTER TABLE dbo.NashvilleHousing
Add OwnerSplitAdd Nvarchar(225);

Update dbo.NashvilleHousing
SET OwnerSplitAdd = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

ALTER TABLE dbo.NashvilleHousing
Add OwnerSplitC Nvarchar(225);

Update dbo.NashvilleHousing
SET OwnerSplitC = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

ALTER TABLE dbo.NashvilleHousing
Add OwnerSplitS Nvarchar(225);

Update dbo.NashvilleHousing
SET OwnerSplitS = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

Select *
From Dataexploration.dbo.NashvilleHousing

---- change CITY OF BERRY HILL and 'CITY OF BELLE MEADE to 21 and 235 in "TaxDistrict"

Select Distinct(TaxDistrict)
From Dataexploration.dbo.NashvilleHousing

Select Distinct(TaxDistrict), Count(TaxDistrict)
From Dataexploration.dbo.NashvilleHousing
Group by TaxDistrict
order by 2

Select TaxDistrict
, CASE When TaxDistrict = 'CITY OF BERRY HILL' THEN '21'
       When TaxDistrict = 'CITY OF BELLE MEADE' THEN '235'
	   ELSE TaxDistrict
	   END
From Dataexploration.dbo.NashvilleHousing

Update dbo.NashvilleHousing
SET TaxDistrict = CASE When TaxDistrict = 'CITY OF BERRY HILL' THEN '21'
       When TaxDistrict = 'CITY OF BELLE MEADE' THEN '235'
	   ELSE TaxDistrict
	   END

-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From Dataexploration.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From Dataexploration.dbo.NashvilleHousing


Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From Dataexploration.dbo.NashvilleHousing
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From Dataexploration.dbo.NashvilleHousing


-- Delete Unused Columns





ALTER TABLE Dataexploration.dbo.NashvilleHousing
DROP COLUMN OwnerAddress;


ALTER TABLE Dataexploration.dbo.NashvilleHousing
DROP COLUMN TaxDistrict;

ALTER TABLE Dataexploration.dbo.NashvilleHousing
DROP COLUMN PropertyAddress;

ALTER TABLE Dataexploration.dbo.NashvilleHousing
DROP COLUMN SaleDate;










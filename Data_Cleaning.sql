/*

Cleaning Data in SQL Queries

*/

Use Projects
Select * from NashvilleHousing

------------------------------------------------------------------------------
--Standardize Date Format


Select * from NashvilleHousing

Alter Table NashvilleHousing
Add Saledateconverted Date;

Update NashvilleHousing
set Saledateconverted = CONVERT(Date,SaleDate)


-------------------------------------------------------------------------------
--Populate Property Address data

Select *
from NashvilleHousing
--where PropertyAddress is null
order by ParcelID

Select a.ParcelID,b.ParcelID,a.PropertyAddress,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
from NashvilleHousing a
JOIN NashvilleHousing b 
    on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null
	

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from NashvilleHousing a
JOIN NashvilleHousing b 
    on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Select PropertyAddress from NashvilleHousing
Where PropertyAddress is null


---------------------------------------------------------------------------------------

--Breaking Out Address into Indidvidual Columns (Address,City,State)

Select PropertyAddress,OwnerAddress
from NashvilleHousing 

Select 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Addrress
, SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,len(PropertyAddress)) as Addrress
from NashvilleHousing



Alter Table NashvilleHousing
Add PropertyAddressSplit Nvarchar(255);

Update NashvilleHousing
set PropertyAddressSplit = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)
 
 
Alter Table NashvilleHousing
Add PropertyCitySplit Nvarchar(255);

Update NashvilleHousing
set PropertyCitySplit = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,len(PropertyAddress))

 
Select * from NashvilleHousing


-- Now,Splitting OwnerAddress

Select OwnerAddress
from NashvilleHousing 

Select 
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
from NashvilleHousing

 
Alter Table NashvilleHousing
Add OwnerAddressSplit Nvarchar(255);

Update NashvilleHousing
set OwnerAddressSplit = PARSENAME(REPLACE(OwnerAddress,',','.'),3)


 
Alter Table NashvilleHousing
Add OwnerCitySplit Nvarchar(255);

Update NashvilleHousing
set OwnerCitySplit = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

 
Alter Table NashvilleHousing
Add OwnerStateSplit Nvarchar(255);

Update NashvilleHousing
set OwnerStateSplit = PARSENAME(REPLACE(OwnerAddress,',','.'),1)


Select * from NashvilleHousing

 ---------------------------------------------------------------------------------------

--Change Y & N to 'Yes' & 'No' in SoldAsVacant 

Select distinct(SoldAsVacant),count(SoldAsVacant)
From NashvilleHousing 
Group by SoldAsVacant
order by 2

Select SoldAsVacant ,
CASE When SoldAsVacant = 'Y' Then 'Yes'
	 when SoldAsVacant = 'N' Then 'No'
	 Else SoldAsVacant
	 END
From NashvilleHousing

UPDATE NashvilleHousing 
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' Then 'Yes'
	 when SoldAsVacant = 'N' Then 'No'
	 Else SoldAsVacant
	 END



------------------------------------------------------------------------------------------

-- Remove Duplicates

With RowNumCTE as (
Select *, 
   ROW_NUMBER()
   OVER (PARTITION BY 
         ParcelID,PropertyAddress,SaleDate,SalePrice,LegalReference 
		 Order by UniqueID) row_num
From NashvilleHousing )

DELETE
from RowNumCTE
Where row_num > 1
--Order by PropertyAddress


----------------------------------------------------------------------------------------------------

--Delete Unused Columns

Select *
from NashvilleHousing

ALTER TABLE NashvilleHousing
DROP COLUMN PropertyAddress,SaleDate,OwnerAddress,TaxDistrict





EXECUTE AS LOGIN='QueryFileUser'
GO

with ParentContact AS
(
SELECT DISTINCT 
           stu.STUDENT_GU
         , stu.SIS_NUMBER
         , ROW_NUMBER() OVER(PARTITION BY stu.STUDENT_GU ORDER BY plist.CALL_ORDER) PGNum
         , plist.HomePhone
         , plist.CellPhone
         , plist.OtherPhone
         , plist.EMAIL
         , plist.CALL_ORDER
         , plist.PrimaryPhone
		 , RELATION
		 , plist.FIRST_NAME
		 , plist.LAST_NAME
		 , plist.ADDRESS
		 , plist.STREET_NAME
		 , plist.CITY
		 , plist.STATE
		 , plist.ZIP_4
		 , plist.ZIPCODE
		 , plist.ZIP_5
FROM rev.EPC_STU_YR syr
JOIN rev.EPC_STU_SCH_YR ssyr        ON ssyr.STUDENT_SCHOOL_YEAR_GU = syr.STU_SCHOOL_YEAR_GU
JOIN rev.EPC_STU stu                ON stu.STUDENT_GU = syr.STUDENT_GU
JOIN rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_YEAR_GU = ssyr.ORGANIZATION_YEAR_GU 
JOIN rev.REV_ORGANIZATION org       ON org.ORGANIZATION_GU = oyr.ORGANIZATION_GU
JOIN rev.REV_YEAR yr                ON yr.YEAR_GU = oyr.YEAR_GU
JOIN (
      SELECT  DISTINCT
           stu.STUDENT_GU
         , stupar.ORDERBY CALL_ORDER
         , phone.H HomePhone
         , phone.C CellPhone
         , phone.O OtherPhone
         , par.EMAIL
         , ParPriPhone.Y PrimaryPhone
		 , stupar.RELATION_TYPE RELATION
		 , PAR.FIRST_NAME
		 , PAR.LAST_NAME
		 , ADDR.[ADDRESS]
		 , ADDR.CITY
		 , ADDR.[STATE]
		 , ADDR.STREET_NAME
		 , ADDR.ZIP_4
		 , ADDR.ZIPCODE
		 , ADDR.ZIP_5

      FROM rev.EPC_STU_PARENT  stupar
           JOIN rev.REV_PERSON par ON par.PERSON_GU = stupar.PARENT_GU and stupar.CONTACT_ALLOWED = 'Y'
           JOIN rev.EPC_STU stu    ON stu.STUDENT_GU = stupar.STUDENT_GU
           LEFT JOIN (SELECT phn.PERSON_GU, phn.PHONE, phn.PHONE_TYPE FROM rev.REV_PERSON_PHONE phn) pl
                      PIVOT (min(phone) FOR phone_type in ([H], [C],  [O])) phone ON phone.PERSON_GU = par.PERSON_GU
           LEFT JOIN (SELECT phn.PERSON_GU, phn.PHONE, phn.PRIMARY_PHONE FROM rev.REV_PERSON_PHONE phn) ParPhn
                      PIVOT (min(phone) FOR PRIMARY_PHONE in ([Y])) ParPriPhone ON ParPriPhone.PERSON_GU = par.PERSON_GU
		   LEFT JOIN REV.REV_ADDRESS  ADDR ON ADDRESS_GU = PAR.HOME_ADDRESS_GU

     ) plist on plist.STUDENT_GU = stu.STUDENT_GU

GROUP BY
           stu.STUDENT_GU
         , stu.SIS_NUMBER
         , plist.HomePhone
         , plist.CellPhone
         , plist.OtherPhone
         , plist.EMAIL
         , plist.CALL_ORDER
         , plist.PrimaryPhone
		 , plist.RELATION
		 , plist.FIRST_NAME
		 , plist.LAST_NAME
		 , plist.ADDRESS
		 , plist.STREET_NAME
		 , plist.CITY
		 , plist.STATE
		 , plist.ZIP_4
		 , plist.ZIPCODE
		 , plist.ZIP_5
)

SELECT
	DISTINCT
	STUDENTID
	,STU.STUDENT_GU AS STUDENT_GU
	,DISTRICTCODE
	,LASTNAME
	,FIRSTNAME
	,DOB
	,XX.GENDER
	,ETHNICITY
	,EVERELL
	,EVERIEP
	,FRL
	--,XX.MIGRANT
	--,XX.SPED_REASONCODE
	--,SPED_REASON
	,TOTALSNAPSHOTS
	,OUTCOME
	,OUTCOMESCHOOLYEAR
	,OUTCOMEUNKNOWN
	,OUTCOMEDESC
	,ENTER9GRADE
	,TRANSFERIN10GRADE
	,TRANSFERIN11GRADE
	,TRANSFERIN12GRADE
	--,ENTER10GRADE
	--,ENTER11GRADE
	--,ENTER12GRADE
	,LASTLOCATION
	--,DUALCREDIT
	--,ID
	,XX.[LOCATIONID_1]
	,XX.[LOCATIONID_2]
	,XX.[LOCATIONID_3]
	,XX.[LOCATIONID_4]
	,XX.[LOCATIONID_5]
	,XX.[LOCATIONID_6]
	,XX.[NUMSNAPSHOTS_1]
	,XX.[NUMSNAPSHOTS_2]
	,XX.[NUMSNAPSHOTS_3]
	,XX.[NUMSNAPSHOTS_4]
	,XX.[NUMSNAPSHOTS_5]
	,XX.[NUMSNAPSHOTS_6]
	,SOR2.SCHOOL_CODE AS SOR_SCHOOL_CODE
	,SOR2.SCHOOL_NAME AS SOR_SCHOOL_NAME
	,SOR2.SCHOOL_YEAR AS SOR_SCHOOL_YEAR
	,SOR2.ENTER_DATE AS SOR_ENTER_DATE
	,SOR2.LEAVE_DATE AS SOR_LEAVE_DAE
	,SOR2.LEAVE_DESCRIPTION AS SOR_LEAVE_DESCRIPTION
	,SOR2.LEAVE_CODE AS SOR_LEAVE_CODE
	,SOR2.GRADE AS SOR_GRADE
	,STU.GRADUATION_DATE
	,STU.GRADUATION_STATUS
	,STU.DIPLOMA_TYPE
	,PC.Parent1FirstName
	,PC.Parent1LastName
	,PC.Parent1Relation
	,PC.Parent1PrimaryPhone
	,PC.Parent1CellPhone
	,PC.Parent1CallOrder
	,PC.Parent1Address
	,PC.Parent1City
	,PC.Parent1State
	,PC.Parent1Zip
	,PC.Parent2FirstName
	,PC.Parent2LastName
	,PC.Parent2Relation
	,PC.Parent2PrimaryPhone
	,PC.Parent2CellPhone
	,PC.Parent2CallOrder
	,PC.Parent2Address
	,PC.Parent2City
	,PC.Parent2State
	,PC.Parent2Zip
	,RELEASE_DATE
	,SCHOOL_Non_District.NAME AS NON_DISTRICT_SCHOOL_NAME
	,PERSON_RELEASED_TO
	,PERSON_TITLE
	,RELEASE_PURPOSE
FROM
--SELECT * FROM
    OPENROWSET (
        'Microsoft.ACE.OLEDB.12.0', 
        'Text;Database=\\SynTempSSIS.APS.EDU.ACTD\Files\TempQuery\;', 
        'SELECT * FROM cohort_15_graduation_verfication_5_year_flattened.csv'  
    )AS XX

	LEFT JOIN
	REV.EPC_STU AS STU
	ON STU.STATE_STUDENT_NUMBER = XX.STUDENTID

	LEFT JOIN
	(
				SELECT 
					*
				FROM
				(
				SELECT 
					  ROW_NUMBER () OVER (PARTITION BY STUDENT_GU ORDER BY ENTER_DATE DESC) AS RN
					  ,[SCHOOL_CODE]
					  ,[SCHOOL_NAME]
					  ,[ENTER_DATE]
					  ,[ENTER_CODE]
					  ,[ENTER_DESCRIPTION]
					  ,[LEAVE_DATE]
					  ,[LEAVE_CODE]
					  ,[LEAVE_DESCRIPTION]
					  ,[SUMMER_WITHDRAWL_CODE]
					  ,[YEAR_END_STATUS]
					  ,[GRADE]
					  ,[LIST_ORDER]
					  ,[EXCLUDE_ADA_ADM]
					  ,[ACCESS_504]
					  ,[CONCURRENT]
					  ,SOR.[SCHOOL_YEAR]
					  ,SOR.[EXTENSION]
					  ,[STUDENT_GU]
					  ,[STUDENT_SCHOOL_YEAR_GU]
					  ,[ORGANIZATION_YEAR_GU]
					  ,[ORGANIZATION_GU]
					  ,SOR.[YEAR_GU]
					  ,[HOMEROOM_SECTION_GU]
					  ,[STU_YEAR_GU]
				  FROM [ST_Production].[APS].[StudentSchoolOfRecord] SOR
				) AS SOR
				WHERE RN = 1
				) AS SOR2
				ON SOR2.STUDENT_GU = STU.STUDENT_GU

			LEFT JOIN
			(
		SELECT DISTINCT 
		  S.SIS_NUMBER                 AS [STUDENT ID NUMBER]
		, SP.FIRST_NAME                AS [FIRST NAME]
		, SP.LAST_NAME                 AS [LAST NAME]
		, SP.PRIMARY_PHONE             AS [PHONE]
		, SCH.SCHOOL_CODE              AS [SCHOOL ID]
		-----------------
		, Par1.HomePhone               AS [Parent1HomePhone]
		, Par1.CellPhone               AS [Parent1CellPhone]
		, Par1.OtherPhone              AS [Parent1OtherPhone]
		, Par1.EMAIL                   AS [Parent1Email]
		, Par1.RELATION				   AS Parent1Relation
		, Par1.CALL_ORDER              AS [Parent1CallOrder]
		, Par1.PrimaryPhone            AS [Parent1PrimaryPhone]
		, Par1.FIRST_NAME		       AS Parent1FirstName
		, Par1.LAST_NAME			   AS Parent1LastName
		, Par2.HomePhone               AS [Parent2HomePhone]
		, Par2.CellPhone               AS [Parent2CellPhone]
		, Par2.OtherPhone              AS [Parent2OtherPhone]
		, Par2.EMAIL                   AS [Parent2Email]
		, Par2.RELATION				   AS Parent2Relation
		, Par2.CALL_ORDER              AS [Parent2CallOrder]
		, Par2.PrimaryPhone            AS [Parent2PrimaryPhone]
		, Par2.FIRST_NAME			   AS Parent2FirstName
		, Par2.LAST_NAME			   AS Parent2LastName
		, PAR1.ADDRESS                 AS Parent1Address
		, PAR1.CITY                    AS Parent1City
		, PAR1.STATE                   AS Parent1State
		, PAR1.ZIP_5                  AS Parent1Zip
		, PAR2.ADDRESS				   AS Parent2Address
		, PAR2.CITY                    AS Parent2City
		, PAR2.STATE                   AS Parent2State
		, PAR2.ZIP_5               AS Parent2Zip
		-----------------
		, ssy.STATUS
		FROM rev.EPC_STU               AS S 
		JOIN rev.REV_PERSON            AS SP     ON SP.PERSON_GU            = S.STUDENT_GU 
		JOIN rev.EPC_STU_SCH_YR        AS SSY    ON SSY.STUDENT_GU          = S.STUDENT_GU 
													--AND SSY.LEAVE_DATE IS NULL 
													--AND SSY.STATUS IS NULL 
		--JOIN rev.EPC_STU_YR            AS SY     ON SY.STU_SCHOOL_YEAR_GU   = SSY.STUDENT_SCHOOL_YEAR_GU
		JOIN rev.REV_ORGANIZATION_YEAR AS OY     ON OY.ORGANIZATION_YEAR_GU = SSY.ORGANIZATION_YEAR_GU
		JOIN rev.REV_YEAR              AS Y      ON Y.YEAR_GU               = SSY.YEAR_GU 
													--AND (y.YEAR_GU IN (SELECT [YEAR_GU] FROM [rev].[REV_YEAR] WHERE [SCHOOL_YEAR]=(SELECT [SCHOOL_YEAR] FROM [rev].[SIF_22_Common_CurrentYear]) AND [EXTENSION] IN ('N', 'R'))
											  -- OR y.SCHOOL_YEAR IN (SELECT [SCHOOL_YEAR] FROM [rev].[SIF_22_Common_CurrentYear])
											  -- AND [y].[EXTENSION]='S')
		JOIN rev.REV_ORGANIZATION      AS O      ON O.ORGANIZATION_GU       = OY.ORGANIZATION_GU 
		JOIN rev.EPC_SCH               AS SCH    ON SCH.ORGANIZATION_GU     = O.ORGANIZATION_GU
		LEFT JOIN rev.EPC_STU_PGM_ELL  AS ell    ON ell.STUDENT_GU          = s.STUDENT_GU 

		------------------
		LEFT JOIN ParentContact        AS Par1   ON par1.STUDENT_GU         = S.STUDENT_GU
													AND Par1.PGNum          = 1
		LEFT JOIN ParentContact        AS Par2   ON par2.STUDENT_GU         = S.STUDENT_GU
													AND Par2.PGNum          = 2
		-------------------
		-------------------
		--WHERE SCH.SCHOOL_CODE IS NOT NULL
		--	  AND Par2.PGNum          = 2
	) AS PC
	ON PC.[STUDENT ID NUMBER] = STU.SIS_NUMBER

	LEFT JOIN
             rev.[EPC_STU_REQUEST_TRACKING] AS [REQUEST_TRACKING]
             ON
             STU.STUDENT_GU = [REQUEST_TRACKING].[STUDENT_GU]
             
             LEFT OUTER JOIN
             rev.[UD_STU_REQUEST_TRACKING] AS [REQUEST_TRACKING_NOTES]
             ON
             [REQUEST_TRACKING].[STU_REQUEST_TRACKING_GU] = [REQUEST_TRACKING_NOTES].[STU_REQUEST_TRACKING_GU]
             
             -- Get location details and name
             LEFT OUTER JOIN
              rev.[EPC_SCH_NON_DST] AS [SCHOOL_Non_District] -- Contains the School Name
             ON 
             [REQUEST_TRACKING].[SCHOOL_NON_DISTRICT_GU] = [SCHOOL_Non_District].[SCHOOL_NON_DISTRICT_GU]

WHERE studentid in ('100107234', '100067933')
ORDER BY STUDENTID
REVERT 
GO

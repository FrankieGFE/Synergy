
  
    SELECT    FamilyMembers.ID_NBR,                     --- Get basic student information from the CE020 Family Member table... 
              FamilyMembers.LST_NME AS StudentLastName,
              FamilyMembers.FRST_NME AS StudentFirstName,
              FamilyMembers.M_NME AS StudentMiddleName,
              FamilyMembers.BRTH_DT,
              FamilyMembers.GENDER AS StudentGender,
              FamilyMembers.STATE_ID,
              FamilyMembers.PRIOR_ID,
              FamilyMembers.ETHN_CD AS Race1,           --- Race: primary, secondary, tertiary, etc., etc. --->
              FamilyMembers.ETHN_CD2 AS Race2,
              FamilyMembers.ETHN_CD3 AS Race3,
              FamilyMembers.ETHN_CD4 AS Race4,
              FamilyMembers.ETHN_CD5 AS Race5,
              FamilyMembers.ETHN_CD6 AS Race6,
              FamilyMembers.HISPLAT,                       --- Hispanic indicator --->
              FamilyMembers.HOMELESS,                       --- Homelessness indicator --->
              FamilyMembers.GSTD_YR,                       --- Graduation standard year --->

              RaceDescriptions1.ETHN_ABBR AS Race1Descr,   --- Race lookup descriptions from CE080 --->
              RaceDescriptions2.ETHN_ABBR AS Race2Descr,
              RaceDescriptions3.ETHN_ABBR AS Race3Descr,
              RaceDescriptions4.ETHN_ABBR AS Race4Descr,
              RaceDescriptions5.ETHN_ABBR AS Race5Descr,
              RaceDescriptions6.ETHN_ABBR AS Race6Descr,

              Familys.FAM_NBR,                         -- ...and family reference from CE810... --->
              Familys.LIVE_WITH,
              Familys.PRIM_FAM,

              FamilyHeadsOfHouseHold.HM_AREA_CD,       --- ...and family head(s) of household from CE010... --->
              FamilyHeadsOfHouseHold.HM_PHNE,
              FamilyHeadsOfHouseHold.ADDR_TO,
              FamilyHeadsOfHouseHold.ADDR_LNE_1,
              FamilyHeadsOfHouseHold.ADDR_LNE_2,
              FamilyHeadsOfHouseHold.CITY,
              FamilyHeadsOfHouseHold.STATE,
              FamilyHeadsOfHouseHold.ZIP_CD,
              FamilyHeadsOfHouseHold.DWL_NBR,

              HeadsOfHouseHold.LST_NME AS HHLastName,   --- ...and head(s) of household contact info from CE015... --->
              HeadsOfHouseHold.FRST_NME AS HHFirstName,
              HeadsOfHouseHold.M_NME AS HHMiddleName,
              HeadsOfHouseHold.HH_GENDER AS HHGender,
              HeadsOfHouseHold.EMAIL AS HHEMail,
              HeadsOfHouseHold.F1_DAY AS HHPhone1DayFlag,
              HeadsOfHouseHold.F1_TYPE AS HHPhone1Type,
              HeadsOfHouseHold.F1_AREA_CD AS HHPhone1AreaCode,
              HeadsOfHouseHold.F1_PHNE AS HHPhone1Number,
              HeadsOfHouseHold.F1_PH_EXT AS HHPhone1Ext,
              HeadsOfHouseHold.F2_DAY AS HHPhone2DayFlag,
              HeadsOfHouseHold.F2_TYPE AS HHPhone2Type,
              HeadsOfHouseHold.F2_AREA_CD AS HHPhone2AreaCode,
              HeadsOfHouseHold.F2_PHNE AS HHPhone2Number,

              Phone1TypeDescription.PH_TY_DESC AS HHPhone1TypeDescr,  --- ...and phone types from SY032 --->
              Phone2TypeDescription.PH_TY_DESC AS HHPhone2TypeDescr


    FROM     PR.DBTSIS.CE020_V
    AS        FamilyMembers


    LEFT OUTER JOIN   PR.DBTSIS.CE080_V              --- Joins to Race code lookup table (CE080) to get race descriptions 1,2,...6. --->
    AS                RaceDescriptions1
    ON                ((FamilyMembers.ETHN_CD = RaceDescriptions1.ETHN_CD) AND
                       (FamilyMembers.DST_NBR = RaceDescriptions1.DST_NBR))

    LEFT OUTER JOIN   PR.DBTSIS.CE080_V
    AS                RaceDescriptions2
    ON                ((FamilyMembers.ETHN_CD2 = RaceDescriptions2.ETHN_CD) AND
                       (FamilyMembers.DST_NBR = RaceDescriptions2.DST_NBR))

    LEFT OUTER JOIN   PR.DBTSIS.CE080_V
    AS                RaceDescriptions3
    ON                ((FamilyMembers.ETHN_CD3 = RaceDescriptions3.ETHN_CD) AND
                       (FamilyMembers.DST_NBR = RaceDescriptions3.DST_NBR))

    LEFT OUTER JOIN   PR.DBTSIS.CE080_V
    AS                RaceDescriptions4
    ON                ((FamilyMembers.ETHN_CD4 = RaceDescriptions4.ETHN_CD) AND
                       (FamilyMembers.DST_NBR = RaceDescriptions4.DST_NBR))

    LEFT OUTER JOIN   PR.DBTSIS.CE080_V
    AS                RaceDescriptions5
    ON                ((FamilyMembers.ETHN_CD5 = RaceDescriptions5.ETHN_CD) AND
                       (FamilyMembers.DST_NBR = RaceDescriptions5.DST_NBR))

    LEFT OUTER JOIN   PR.DBTSIS.CE080_V
    AS                RaceDescriptions6
    ON                ((FamilyMembers.ETHN_CD6 = RaceDescriptions6.ETHN_CD) AND
                       (FamilyMembers.DST_NBR = RaceDescriptions6.DST_NBR))

    LEFT OUTER JOIN   PR.DBTSIS.CE810_V          --- Join to Family Record table (CE810) to get Family Number (primary family). --->
    AS                Familys
    ON                ((FamilyMembers.ID_NBR = Familys.ID_NBR) AND
                       (FamilyMembers.DST_NBR = Familys.DST_NBR) AND
                       (UPPER(Familys.PRIM_FAM) = 'X'))     --- primary family indicator is 'X' --->

    LEFT OUTER JOIN   PR.DBTSIS.CE010_V  -- Join to Family Head(s) of Household table (CE010) to get Parent(s). --->
    AS                FamilyHeadsOfHouseHold
    ON                ((Familys.FAM_NBR = FamilyHeadsOfHouseHold.FAM_NBR) AND
                       (Familys.DST_NBR = FamilyHeadsOfHouseHold.DST_NBR))

    LEFT OUTER JOIN   PR.DBTSIS.CE015_V       --- Join to Head(s) of Household table (CE015) to get Parent's/s' contact information. --->
    AS                HeadsOfHouseHold
    ON                ((FamilyHeadsOfHouseHold.FAM_NBR = HeadsOfHouseHold.FAM_NBR) AND
                       (FamilyHeadsOfHouseHold.DST_NBR = HeadsOfHouseHold.DST_NBR))

    LEFT OUTER JOIN   PR.DBTSIS.SY032_V             -- Joins to Phone type table (SY032) to get heads of household phone type(s). --->
    AS                Phone1TypeDescription
    ON                ((HeadsOfHouseHold.F1_TYPE = Phone1TypeDescription.PH_TYPE) AND
                       (HeadsOfHouseHold.DST_NBR = Phone1TypeDescription.DST_NBR))

    LEFT OUTER JOIN   PR.DBTSIS.SY032_V
    AS                Phone2TypeDescription
    ON                ((HeadsOfHouseHold.F2_TYPE = Phone2TypeDescription.PH_TYPE) AND
                       (HeadsOfHouseHold.DST_NBR = Phone2TypeDescription.DST_NBR))


    WHERE     ((FamilyMembers.DST_NBR = 1) 
	AND                                           
               (FamilyMembers.ID_NBR = '970112493' ))  
                                                         
             


    ORDER BY  FamilyMembers.ID_NBR 




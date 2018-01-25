/*
    Review XTBL_TESTS metadata for I-Ready
*/
Select *
From K12INTEL_USERDATA.XTBL_TESTS dtst
Where 1=1
    And dtst.TEST_VENDOR = 'Curriculum Associates'
    And dtst.TEST_PRODUCT = 'I-Ready'
GO



/*
    Review English Language Arts placement information by student
*/
Select dtst.TEST_VENDOR
    , dtst.TEST_PRODUCT
    , dtst.TEST_SUBJECT
    , dstu.STUDENT_ID
    , dstu.STUDENT_NAME
    , dte.DATE_VALUE AS ADMINISTRATION_DATE
    , MAX(CASE WHEN dtst.TEST_NAME = 'I-Ready ELA Overall Score' THEN fscr.TEST_SCALED_SCORE ELSE NULL END) AS "Overall Scale Score"
    , MAX(CASE WHEN dtst.TEST_NAME = 'I-Ready ELA Overall Score' THEN fscr.TEST_PRIMARY_RESULT ELSE NULL END) AS "Overal Placement"
    , MAX(CASE WHEN dtst.TEST_NAME = 'I-Ready ELA Phonological Awareness Score' THEN fscr.TEST_PRIMARY_RESULT ELSE NULL END) AS "Phonological Awareness"
    , MAX(CASE WHEN dtst.TEST_NAME = 'I-Ready ELA Phonics Score' THEN fscr.TEST_PRIMARY_RESULT ELSE NULL END) AS "Phonics"
    , MAX(CASE WHEN dtst.TEST_NAME = 'I-Ready ELA High-Frequency Words Score' THEN fscr.TEST_PRIMARY_RESULT ELSE NULL END) AS "High-Frequency Words"
    , MAX(CASE WHEN dtst.TEST_NAME = 'I-Ready ELA Vocabulary Score' THEN fscr.TEST_PRIMARY_RESULT ELSE NULL END) AS "Vocabulary"
    , MAX(CASE WHEN dtst.TEST_NAME = 'I-Ready ELA Reading Comprehension: Literature Score' THEN fscr.TEST_PRIMARY_RESULT ELSE NULL END) AS "Comprehension: Literature"
    , MAX(CASE WHEN dtst.TEST_NAME = 'I-Ready ELA Reading Comprehension: Informational Text Score' THEN fscr.TEST_PRIMARY_RESULT ELSE NULL END) AS "Comprehension: Informational Text"
    , COUNT(*) AS "RECORD COUNT (Should be 7)"
From K12INTEL_DW.DTBL_TESTS dtst with(nolock)
    Inner Join K12INTEL_DW.FTBL_TEST_SCORES fscr with(nolock)
        On dtst.TESTS_KEY = fscr.TESTS_KEY
    Inner Join K12INTEL_DW.DTBL_STUDENTS dstu with(nolock)
        On dstu.STUDENT_KEY = fscr.STUDENT_KEY
    Inner Join K12INTEL_DW.DTBL_SCHOOL_DATES dte with(nolock)
        On dte.SCHOOL_DATES_KEY = fscr.SCHOOL_DATES_KEY
Where 1=1
    And dtst.TEST_VENDOR = 'Curriculum Associates'
    And dtst.TEST_PRODUCT = 'I-Ready'
    And dtst.TEST_SUBJECT = 'English Language Arts'
Group By dtst.TEST_VENDOR
    , dtst.TEST_PRODUCT
    , dtst.TEST_SUBJECT
    , dstu.STUDENT_ID
    , dstu.STUDENT_NAME
    , dte.DATE_VALUE
Order By dstu.STUDENT_NAME ASC
    , dte.DATE_VALUE DESC
GO



/*
    Review Mathematics placement information by student
*/
Select dtst.TEST_VENDOR
    , dtst.TEST_PRODUCT
    , dtst.TEST_SUBJECT
    , dstu.STUDENT_ID
    , dstu.STUDENT_NAME
    , dte.DATE_VALUE AS ADMINISTRATION_DATE
    , MAX(CASE WHEN dtst.TEST_NAME = 'I-Ready Mathematics Overall Score' THEN fscr.TEST_SCALED_SCORE ELSE NULL END) AS "Overall Scale Score"
    , MAX(CASE WHEN dtst.TEST_NAME = 'I-Ready Mathematics Overall Score' THEN fscr.TEST_PRIMARY_RESULT ELSE NULL END) AS "Overal Placement"
    , MAX(CASE WHEN dtst.TEST_NAME = 'I-Ready Mathematics Algebra and Algebraic Thinking Score' THEN fscr.TEST_PRIMARY_RESULT ELSE NULL END) AS "Algebra and Algebraic Thinking"
    , MAX(CASE WHEN dtst.TEST_NAME = 'I-Ready Mathematics Geometry Score' THEN fscr.TEST_PRIMARY_RESULT ELSE NULL END) AS "Geometry"
    , MAX(CASE WHEN dtst.TEST_NAME = 'I-Ready Mathematics Measurement and Data Score' THEN fscr.TEST_PRIMARY_RESULT ELSE NULL END) AS "Measurement and Data"
    , MAX(CASE WHEN dtst.TEST_NAME = 'I-Ready Mathematics Number and Operations Score' THEN fscr.TEST_PRIMARY_RESULT ELSE NULL END) AS "Number and Operations"
    , COUNT(*) AS "RECORD COUNT (Should be 5)"
From K12INTEL_DW.DTBL_TESTS dtst with(nolock)
    Inner Join K12INTEL_DW.FTBL_TEST_SCORES fscr with(nolock)
        On dtst.TESTS_KEY = fscr.TESTS_KEY
    Inner Join K12INTEL_DW.DTBL_STUDENTS dstu with(nolock)
        On dstu.STUDENT_KEY = fscr.STUDENT_KEY
    Inner Join K12INTEL_DW.DTBL_SCHOOL_DATES dte with(nolock)
        On dte.SCHOOL_DATES_KEY = fscr.SCHOOL_DATES_KEY
Where 1=1
    And dtst.TEST_VENDOR = 'Curriculum Associates'
    And dtst.TEST_PRODUCT = 'I-Ready'
    And dtst.TEST_SUBJECT = 'Mathematics'
Group By dtst.TEST_VENDOR
    , dtst.TEST_PRODUCT
    , dtst.TEST_SUBJECT
    , dstu.STUDENT_ID
    , dstu.STUDENT_NAME
    , dte.DATE_VALUE
Order By dstu.STUDENT_NAME ASC
    , dte.DATE_VALUE DESC
GO
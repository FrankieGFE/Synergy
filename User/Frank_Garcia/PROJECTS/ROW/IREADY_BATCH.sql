SELECT DISTINCT --count(*) --verify # records
	--scores.*  --Verify scores look correct; test_scores and test_score_text etc.
	admin.*		--Verify that names looks correct, cols will be off if there is a tab in the data
FROM K12INTEL_USERDATA.XTBL_TESTS tests  WITH (NOLOCK)
INNER JOIN K12INTEL_USERDATA.XTBL_TEST_SCORES scores WITH (NOLOCK)
    ON tests.TEST_NUMBER = scores.TEST_NUMBER
INNER JOIN K12INTEL_USERDATA.XTBL_TEST_ADMIN admin WITH (NOLOCK)
    ON scores.TEST_ADMIN_KEY = admin.TEST_ADMIN_KEY
INNER JOIN K12INTEL_USERDATA.XTBL_TEST_BATCH_IDS batch WITH (NOLOCK)
    ON admin.BATCH_ID = batch.BATCH_ID
WHERE 1=1
    AND batch.BATCH_NAME in( 'IREADY 001 APS 2015-2016 WINTER') --, 'GENERIC HSGA-Composite 001 APS 2015-2016')  --This is the folder structure; needs to be changed if the test is moved.

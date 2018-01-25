exec list_tran_email_notications @type_of_list = 'No Notifications Sent' --No notifications have been sent for these students
  exec list_tran_email_notications @type_of_list = 'Notifications Sent'
--At least 1 notification was sent for these students
  exec list_tran_email_notications @type_of_list = 'Full List'
--Full list of, includes # of missing email addresses and notifications send per student

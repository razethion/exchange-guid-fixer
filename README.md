# exchange-guid-fixer
Powershell script that will quickly fix incorrectly created hybrid users
If users are having issues receiving mail from on-premises accounts, it's likely that on-premises doesn't know where the mailbox is. This fixes that.

# Error messages explained:
## The operation couldn't be performed because object 'username' couldn't be found on '###.###.PROD.OUTLOOK.COM'
This username probably doesn't exist, check your spelling. Don't continue, if you submitted an array of users the GUIDs will be out of order.

## You cannot call a method on a null-valued expression.
Related to the above error. Don't continue, if you submitted an array of users the GUIDs will be out of order.

## This task does not support recipients of this type. The specified recipient DC\OU\User Name is of type RemoteUserMailbox.
This means Enable-RemoteMailbox was already performed on this account. Usually this requires no action if you see it.

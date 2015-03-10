#echo "Someone just logged into my account!" | mail -s "Login" francis.odonovan@gmail.com

#
# Access control
#

#xhost - 
# Turn on access control.
#xhost + europa.ucc.ie
# Allow certain machines access.

#
# Print out the previous logins - check for break-ins
#

#echo "Previous logins were:"
#last -3 odonovan
# Find out when last logged in

#
# Tell me how long the machine is up and how many users there are
#

#uptime ; users

# Schedule commands
#

#sched 09:00 echo "Good Morning!"
#sched 12:30 echo "Lunch Time!"
#sched 17:30 echo "Tea Time!"
#sched 22:30 echo "It's 22:30, go home!"
#sched 22:30 set prompt='[%h] It\'s after 5; go home:>'
# sched [+]hh:mm cmd
# schedule cmd to run at actual or relative time
# sched
# lists scheduled commands
# sched -#
# deletes scheduled command #

# Disabled commands
#

# sleep 4 
# sleep for 4 seconds

#exec screen

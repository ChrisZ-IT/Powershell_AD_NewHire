# Powershell_AD_NewHire_Scripts

#Before you start. Since these are customized to my own environment just a disclaimer about YMMV and they will need to for sure be updated to match your domain environment. Domain Names, OUs, default new user passwords, naming convention for usernames...etc.

#These scripts were created with a multi domain environment and one that uses gmail & bettercould in mind. So you will need to update the areas about “domain1.com” and “domain2.com” to
match your domains. Should be able to expand to more then just 2 domains as well fairly easily.

#These scripts also assume you copy want to copy permissions from an existing user to the new user. Probably not standard practice everywhere.

#For added security my scripts wont add users to the domain admins, enterprise admins and schema admins groups.  You have to do that manually.

Now that we got that out of the way. Lets start

1. Create newhire.txt on your desktop
2. Add the fields from the example newhire.txt on my github.
3. Update the fields with the new users real info
4. Run NewHireTXTtoCSV_v4.1.ps1 to convert that txt file into the info you need for AD, gmail and the end user.
This creates csv files that get imported into AD and also one that you can copy and paste into bettercloud to automate creating
gmail accounts. the txt file is to copy and paste that info to your ticketing system, HR or hiring manager...etc

5. If you need to create multiple users at once just do repeat steps 3 and 4 for each user you need to create.

#'Limitations' of my scripts is I have my script stop if the Hire status does not match the corresponding script; ‘New Hire’ status users need to be run with the NewUser_Vx.x script, Rehire with the rehire script.
#Iv kept these separate on my on my end to keep me more organized. Nothing would really prevent you from combining all 3 new/re/transfer scripts.
#you would just need to update/add a bunch of if/elseif and else commands to allow it to complete and to tell it what to check against.



6. once you are done adding users with the NewHireTXTtoCSV script and if all the new user's 'Hire status' is set to 'New User'
run the NewUser_v2.2.ps1 script to create their accounts.

If you have users that already exist you will need to run either the TransferringUser_vx.x.ps1 or the ReHireUser_Vx.x.ps1.
Each script has some way to verify if accounts exist and are active and are not in the disabled user OU in AD.


##As for the TermUser script.
#Assuming you have updated the script with your own domain info 
I have a built in GUI that pops up that have you type in the user's name that is getting termed and it will  will verify if their account exists with in a multi domain environment, if its not on the domain you have set for ‘domain1’ it will tell you to run the script from there
remove them from all AD groups, Set their description to the date they were termed, it will verify what file server their H drive is on and then archive it to a hidden share (assuming you update this info as well), it will also disable their account and log the term to a csv file on a network share.


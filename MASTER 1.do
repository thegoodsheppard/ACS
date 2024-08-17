/*Created by: Joey in the future (but now the past... dun dun dun)
Date created: July 22, 2020 
Updated by: Joey da awesome 
Updated on: October 17th,2020

This is my do-file for cleaning for our project about disabled parents and
disabled children. I already successfully (YAY!) downloaded the ipums data. I rock. 
Now, I need to prepare the varaibles and finalized my sample.

This file proceeds in three steps:
Step 1: I created a child file 
Step 2: I created a head of household file
Step 3: I created a spouse of head of household file
Step 4: I merged them all together
Step 5: I finalized my sample 

After running this do-file, you will have a data set (merged_finished) that is all cleaned
and incldues children ages 6-17, have a disability, are actively attending school, and have at least one parent with a disability. 

*/

*Step 1: create the child file 
	cd "D:\Ashley\Education of disabled children raised by disabled parents"
	use "RAW DATA NEVER TOUCH.dta"
	
	*dependent variable: age-for-grade 
		*0=right on time, 1=ahead, -1=behind 
		gen ageforgrade=-1 if gradeattd==10 & age>=6 
		replace ageforgrade=-1 if gradeattd==20 & age>=7
		replace ageforgrade=-1 if gradeattd==31 & age>=8
		replace ageforgrade=-1 if gradeattd==32 & age>=9
		replace ageforgrade=-1 if gradeattd==33 & age>=10
		replace ageforgrade=-1 if gradeattd==34 & age>=11
		replace ageforgrade=-1 if gradeattd==41 & age>=12
		replace ageforgrade=-1 if gradeattd==42 & age>=13
		replace ageforgrade=-1 if gradeattd==43 & age>=14
		replace ageforgrade=-1 if gradeattd==44 & age>=15
		replace ageforgrade=-1 if gradeattd==51 & age>=16
		replace ageforgrade=-1 if gradeattd==52 & age>=17
		replace ageforgrade=-1 if gradeattd==53 & age>=18
		replace ageforgrade=-1 if gradeattd==54 & age>=19
		*Look into 61 and 12th grade, no dipolma
		*Ignore last comment, changed variable from educd to gradeattd
		replace ageforgrade=0 if gradeattd==10 & age==4|gradeattd==10 & age==5
		*CHECK 
		*to make sure age can can look like this ^
		*SOLVED 
		*Ashley showed me how to properly use, it doesn't look like 
		*age>=4|5 but rather age>=4|age>=5. 
		*CHECK
		*to see if we need a space or not between the first and second age
		*SOLVED do not need a space but can have one if you want 
		replace ageforgrade=0 if gradeattd==20 & age==5|gradeattd==20 & age==6
		replace ageforgrade=0 if gradeattd==31 & age==6|gradeattd==31 & age==7
		replace ageforgrade=0 if gradeattd==32 & age==7|gradeattd==32 & age==8 
		replace ageforgrade=0 if gradeattd==33 & age==8|gradeattd==33 & age==9
		replace ageforgrade=0 if gradeattd==34 & age==9|gradeattd==34 & age==10
		replace ageforgrade=0 if gradeattd==41 & age==10|gradeattd==41 & age==11
		replace ageforgrade=0 if gradeattd==42 & age==11|gradeattd==42 & age==12
		replace ageforgrade=0 if gradeattd==43 & age==12|gradeattd==43 & age==13
		replace ageforgrade=0 if gradeattd==44 & age==13|gradeattd==44 & age==14
		replace ageforgrade=0 if gradeattd==51 & age==14|gradeattd==51 & age==15
		replace ageforgrade=0 if gradeattd==52 & age==15|gradeattd==52 & age==16
		replace ageforgrade=0 if gradeattd==53 & age==16|gradeattd==53 & age==17
		replace ageforgrade=0 if gradeattd==54 & age==17|gradeattd==54 & age==18
		*CHECK 
		*to make sure age can can look like this 
		*SOLVED. 
		*Yup, age can look like below
		replace ageforgrade=1 if gradeattd==10 & age<=3
		replace ageforgrade=1 if gradeattd==20 & age<=4
		replace ageforgrade=1 if gradeattd==31 & age<=5
		replace ageforgrade=1 if gradeattd==32 & age<=6 
		replace ageforgrade=1 if gradeattd==33 & age<=7
		replace ageforgrade=1 if gradeattd==34 & age<=8
		replace ageforgrade=1 if gradeattd==41 & age<=9
		replace ageforgrade=1 if gradeattd==42 & age<=10
		replace ageforgrade=1 if gradeattd==43 & age<=11
		replace ageforgrade=1 if gradeattd==44 & age<=12
		replace ageforgrade=1 if gradeattd==51 & age<=13
		replace ageforgrade=1 if gradeattd==52 & age<=14
		replace ageforgrade=1 if gradeattd==53 & age<=15
		replace ageforgrade=1 if gradeattd==54 & age<=16
		replace ageforgrade=1 if gradeattd==60 & age<=17
		
		drop if gradeattd==0
		*12,075,805 observations deleted
		*n=3,764,876
		*tried drop if gradeattd=0 and it didn't work 
		
		recode ageforgrade (-1=1)(0=0)(1=0)(.=.), g(heldback)
		
		
		/*PROBLEM 
		with when they start school verses birthday
		not sure how to fix that, as they could be 17 and 
		ahead in senior year or 17 and early in school. Same
		Goes for being behind in school. Could be 18 and normal
		in senior year or 18 and behind depending on birthdate.
		KINDA FIXED. 
		Kaelie answered, we shall see what she did.
		
		PROBLEM. 
		It asks what your highest level of education is,
		NOT what grade you are in. So there are people who are 
		in their 50s and 60s putting down 8th grade and we don't
		want them in our sample. How can we change this? 
		FIXED 
		Changed variable from educd to gradeattd. Had to renumber
		everything though and that sucked.
		
		PROBLEM. Maybe? ageforgrade has missing data. But that's okay, because I'm
		assuming that it's because unless the individual is in grade school, they will
		be missing in the data. So it's okay, right? 
		FIXED. Right? I ran ageforgrade after dropping <6 and >17, and there is no
		missing data :) 
		*/
				
		*One of Ashley's rules: WE ALWAYS CHECK EVERY VARIABLE 
		
		
	*disability (inclusion critera)
		/* Old coding
		gen disability=1 if diffrem==2 | diffphys==2 | diffmob==2 | diffcare==2 | diffsens==2 | diffeye==2 | diffhear==2 
		replace disability=0 if diffrem==0 | diffrem==1 & diffphys==0 | diffphys==1 & diffmob==0 | diffmob==1 & diffcare==0 | diffcare==1 & diffsens==0 & diffeye==0 & diffhear==0
		*/
		
		*I'm going to try recoding disability because the one above still shows missing 
		*data
		*I think I figured out the problem above. We are saying if someone answers
		*not havinga rem disability but they will only be shown as 0 if they also answered
		*N/A to phys disability but they won't be counted if they answered no to having 
		*a phys disabiltiy. Make sense? 
		*| diffrem==1 & diffphys==0
		*see what I mean?
		*okay, I fixed the coding below, so I'm getting ride of the one above. 
		
		gen disability=1 if diffrem==2 | diffphys==2 | diffmob==2 | diffcare==2 | diffsens==2 | diffeye==2 | diffhear==2 
		replace disability=0 if diffrem!=2 & diffphys!=2 & diffmob!=2 & diffcare!=2 & diffsens!=2 & diffeye!=2 & diffhear!=2 
		
		*PROBLEM This ^ didn't seem to work either (individuals only show up if they have 
		*every disability). So I have no idea what to do now. 
		*FIXED. AH HA! I am feeling sooooooo good right now. I figured it out. I had to 
		*get rid of the OR sign "|" and put in the AND sign "&" instead when disability=0
		
		*CHECK 		
		*to make sure that the numbers can be 0 or 1 by | symbol
		*KINDA SOLVED
		*Figured out how to code properly, kinda like the age>=17|age>=18 but I'make
		*not sure what Ahsley meant that we want to leave out the coding of 0 which
		*means N/A. 
		*CHECK with Ashley about above ^ 
		*CHECK
		*we don't need to code disability as disability=1 if diffrem ==2 & age<18 
		*to include age because we already dropping everyone one who is not within 
		*the age range, right? 
		/*
		PROBLEM
		Not sure what happened. But when I ran the variable disability, only 4 million 
		people are counted, 2 million in having a disability and 2 million in not 
		having a disability. Not sure what happened. It ran correctly, but I don't
		think we understood how to properly record the variables. When I was browsing
		I saw that some individuals don't have a 0 or a 1 in teh variable diability, so 
		I we need to figure that out. 
		FIXED
		Okay, so I just put the and sign & in the wrong places in the coding so the 
		same variables were split up. Basically, I did this 
		diffrem==0 | diffrem==1 & diffphys==0 | diffphys==1
		so it was connecting the variables wrong. 
		CHECK
		to make sure I did the variable right. It seems I didn't just cause it only
		shows the variable of disbaility as 1 and not showing 0s, not sure why. But I 
		mean, we can see all those who have a disability, so I feel like I did it 
		correctly. 
		*/
		
	*age
	ta age
	
	*sex 
	gen female=1 if sex==2
	replace female=0 if sex==1
	
	*race
		*copied and pasted from Ashley example... not sure why she has ! marks after 
		*the = sign. 
		*the != sign means DOES NOT equal. Really only works for sample with no data
		*missing
		gen hispanic=1 if hispan>0
		replace hispanic=0 if hispanic!=1
		gen nhwhite=1 if race==1 & hispanic!=1
		replace nhwhite=0 if nhwhite!=1
		compress
		*not sure what this means^
		*apparently helps the data process go faster ^
		gen nhblack=1 if race==2 & hispanic!=1
		replace nhblack=0 if nhblack!=1
		gen nhasian=1 if race>3 & race<7 & hispanic!=1
		replace nhasian=0 if nhasian!=1
		gen otherrace=1 if nhblack!=1 & nhwhite!=1 & nhasian!=1 & hispanic!=1
		replace otherrace=0 if otherrace!=1
	
	*number of children in the household...
		gen kid=1 if age<19
		*should we make this 18 instead of 19?
		by serial, sort:  egen numkids=count(kid)
		*remind yourself-- the kid variable is just a stupid variable, only created
		*to help us with knwoing the number of kids in the household. So it's okay
		*that there's missing data 
		
		*same outcome, differemnnt sentece:
		*egen numkids_ex2 = total(age<19), by(serial)
		
	*number of disabled children 
		gen diskid=1 if disability==1 & kid==1
		by serial, sort: egen numdiskids=count(diskid) 
	
	*all child-level variables
	
	keep if age<=17 & age>=6
	*1,521,786 observations deleted
	count
	*n=2,243,090
	*PROBLEM 
	*We actually need to undo this since we need the age 18 and 19 in the sample
	*And we need children less than five in the sample as well
	*KINDA FIXED. 
	*Ashley answered and most demographers use ages 6-17 because younger
	*than that gets messy (preschools all start at different times and ages) and
	*when someone becomes 18 and a legal adult, it becomes hard to keep track of them
	keep if disability==1 
	*2,111,809 observations deleted 
	count
	*n=131,281
		***dropping kids who are household heads and spouses from the dataset***
	drop if related==101
	*109 observations deleted
	drop if related==201
	*6 observations deleted
	count
	*n = 131,166
	*crap, that is a very small sample size from what we started out as. Oh well
	*Another Ashley rule: always document how many cases you lose and your sample size 
	
	
	
  **These variables I copied over but I don't really understand them, like how they     
   *work. Like why quotations?***
	
		tab related
		tab related, nolabel
		gen biological=1 if related==301
		replace biological=0 if biological !=1
		lab var biological "Biological children"
		gen adopted=1 if related==302
		replace adopted=0 if adopted!=1
		compress
		lab var adopted "adopted children"
		
		
		*Apparently I didn't add the variable immig???? Yikes. Nedd to check 
		*if that was even an option or if Ashley's data set was just from earlier
		*years. 
		*Nevermind, I'm stupid, Ashley clearly created the variable immig. 
		gen immig=1 if bpld>11500
		replace immig=0 if immig!=1
		tab immig
		lab var immig "immigrant children"
		tab immig
		gen foreignadoptee=1 if immig==1& adopted==1
		replace foreignadoptee=0 if foreignadoptee!=1

		gen forsterchildren=1 if related==1242
		replace forsterchildren=0 if forsterchildren!=1
		rename forsterchildren fosterchildren

		gen foreignfoster=1 if immig==1 & foster==1
		replace foreignfoster=0 if foreignfoster!=1
		compress
		lab var foreignadoptee "Foreign born adoptee"
		lab var foreignfoster "Foreign born foster child"

		gen stepchildren=1 if related==303
		replace stepchildren=0 if stepchildren !=1
		lab var stepchildren "step children"
		tab related
		tab related, nolabel

		gen otherchildren=1 if biological!=1 & adopted!=1& stepchildren!=1& fosterchildren!=1
		compress
		replace otherchildren=0 if otherchildren!=1
		lab var otherchildren "children with other relationships with household heads"
		compress
		
		*tell Ashley/double check with her that you understand the commands des,
		*sum, list, and lab var
		
		*Okay, so yrsusa1 doesn't exist. Not sure why we need this below anyway.
		/*
		des yrsusa1
		gen agearrive=age-yrsusa1 if immig==1
		sum agearrive
		replace agearrive=0 if agearrive<0
		lab var agearrive "age of immigrant arrival in the US"
		sum agearrive if immig==0
		generate gen175=1 if immig==1 & agearrive<6
		replace gen175=0 if gen175!=1
		tab gen175
		lab var gen175 "Children in the 1.75 immigrant generation"
		generate gen15=1 if immig==1 & agearrive<13 & gen175!=1
		replace gen15=0 if gen15!=1
		tab gen15
		lab var gen15 "Children in the 1.5 immigrant generation"
		generate gen125=1 if immig==1 & agearrive<18 & gen175!=1 & gen15!=1
		replace gen125=0 if gen125!=1
		tab gen125
		lab var gen125 "Children in the 1.25 immigrant generation"
		generate gen1adult=1 if immig==1 & gen175!=1 & gen15!=1 & gen125!=1
		replace gen1adult=0 if gen1adult!=1
		lab var gen1adult "First generation children who arrived at age 18 and above"
		compress
		*/

	***region of birth codes***
		gen centralamerica=1 if immig==1 & bpld>16020 & bpld<30005
		replace centralamerica=0 if centralamerica!=1
		tab bpld if immig==1 & bpld>30000 & bpld<40000
		gen southamerica=1 if immig==1 & bpld>30000 & bpld<40000
		replace southamerica=0 if southamerica!=1
		tab bpld if immig==1 & bpld>40000 & bpld<60000
		tab bpld if immig==1 & bpld>40000 & bpld<50000
		gen europe=1 if immig==1 & bpld>40000 & bpld<50000
		replace europe=0 if europe!=1
		tab bpld if immig==1 & bpld>50000 & bpld<60000
		gen asia=1 if immig==1 & bpld>50000 & bpld<60000
		replace asia=0 if asia!=1
		compress
		tab bpld if immig==1 & bpld>60000 & bpld<70000
		gen africa=0  if immig==1 & bpld>60000 & bpld<70000
		drop africa
		gen africa=1  if immig==1 & bpld>60000 & bpld<70000
		replace africa=0 if africa!=1
		tab bpld if centralamerica!=1  & southamerica!=1 & asia!=1 & europe!=1 & africa!=1
		replace africa=1 if bpld==16020
		replace asia=1 if bpld==50000
		tab bpld if immig==1 & centralamerica!=1  & southamerica!=1 & asia!=1 & europe!=1 & africa!=1
		gen othercountries=1 if immig==1 & centralamerica!=1  & southamerica!=1 & asia!=1 & europe!=1 & africa!=1
		replace othercountries=0 if othercountries!=1


		sort serial
		by serial: gen totalbio=sum(biological)
		list serial age adopted biological totalbio in 1/100
		rename totalbio countbio
		by serial: gen totalbio=countbio[_N]
		lab var totalbio "total number of biological children within household"
		gen biowithin=1 if totalbio>0
		replace biowithin=0 if biowithin!=1
		lab var biowithin "lives with biological children within household"

		sort serial
		by serial: gen totaladopted=sum(adopted)
		list serial age adopted biological totalbio in 1/100
		rename totaladopted countadopted
		by serial: gen totaladopted=countadopted[_N]
		lab var countadopted "total number of adopted children within household"

		sort serial
		by serial: gen idkids=_n
		list serial age idkids in 1/100
		by serial: gen totalkids=idkids[_N]
		list serial age idkids totalkids in 1/100
		lab var totalkids "Total number of children within households"
		drop idkids

	*birth order
		gen neg_age=age*-1
		sort serial neg_age
		by serial, sort: gen birthorder=_n

		by serial, sort: gen youngest=birthorder==_N & totalkids>=2
		by serial, sort: gen oldest=_n==1 & totalkids>=2
		gen middle=youngest==0 & oldest==0 & totalkids>=2
		gen onlychild=totalkids==1
		replace youngest=0 if totalkid==1
		su onlychild youngest oldest middle 
		
	/* Do we need this coding below???? 
		
	*sibling characteristics 
		gen girl=1 if sex==2
		gen boy=1 if sex==1
		gen female=sex==2
		gen male=sex==1
	*sex comp (all sisters, all brothers, at least one of each)
		by serial, sort: egen girlpresent=count(girl)
		by serial, sort: egen boypresent=count(boy)
		gen hassister=girlpresent-female
		gen hasbrother=boypresent-male
		recode hassister hasbrother (0=0)(else=1)
		gen allsisters=hassister==1 & hasbrother==0
		gen allbrothers=hassister==0 & hasbrother==1
		gen oneofeach=hassister==1 & hasbrother==1
		su allsisters allbrothers oneofeach

		gen allgirls=girlpresent>=1 & boypresent==0
		gen allboys=girlpresent==0 & boypresent>=1
		gen atleastoneofeach=girlpresent>=1 & boypresent>=1

	*any "other sibling" 
		gen othersib=related!=301 & related!=302
		*n=
		by serial, sort: egen othersibling=max(othersib)
		drop othersib
		
		*/

	*SD of age for families  
		by serial, sort: egen sd_age=mdev(age)

	*mean age for families 
		by serial, sort: egen mean_age=mean(age)
		
		
  **end variables that I don't understand the coding***
  
  drop multyear sample cbserial hhwt cluster strata gq famunit pernum famsize subfam sftype sfrelate cbsubfam cbsftype cbsfrelate relate related hcovany school educ gradeatt gradeattd schltype vetdisab  
  
  *OKay, I ran all the coding on how it is today, August 15th, and there is no
  *missing data, so I think it worked :) Just need to check with Ashley about 
  *the way she coded sex and how that affects the sibling variable 
	
	save "child file.dta", replace 
		
	count	
	*n=131,166
		
	clear all
	
*Step 2: create the head of household file
	 use "RAW DATA NEVER TOUCH.dta"
	*PROBLEM
	*The file name looks different here than in step one. Why? Probably because
	*it was on a different computer when coding each step, so the location is 
	*different. Ask Ashley\Education
	*FIXED
	*I just have to change the top one depending on what computer I am using at the time
	*CHECK 
	*with Ahsley what the command "use" is and how to use it right 
	*SOLVED
	*Ashley showed me how to use the "use" command, just tells Stata what data to use
	
	
	
	*Dependent Variable (is there one???? or is this inclusion critera?): disability
		/* Old coding 
		gen Hdisability=1 if diffrem==2 | diffphys==2 | diffmob==2 | diffcare==2 | diffsens==2 | diffeye==2 | diffhear==2 
		replace Hdisability=0 if diffrem==0 | diffrem==1 & diffphys==0 | diffphys==1 & diffmob==0 | diffmob==1 & diffcare==0 | diffcare==1 & diffsens==0 & diffeye==0 & diffhear==0
		*/
		gen Hdisability=1 if diffrem==2 | diffphys==2 | diffmob==2 | diffcare==2 | diffsens==2 | diffeye==2 | diffhear==2 
		replace Hdisability=0 if diffrem!=2 & diffphys!=2 & diffmob!=2 & diffcare!=2 & diffsens!=2 & diffeye!=2 & diffhear!=2 
		
		
	*age
	rename age Hage
	
	*sex 
	gen Hfemale=1 if sex==2
	replace Hfemale=0 if sex==1
	*rename Hfemale? but what about the varibale of household female???
	*Yes, this is correct, ignore ^
	
	
	*highest education level
		*0=less than highschool, 1=highschool diploma, 2=some college or more 
		gen Hhighedlev=0 if educd==1 | educd==2 | educd==11 | educd==12 | educd==14 | educd==15 | educd==16 | educd==17 | educd==22 | educd==23 | educd==25 | educd==26 | educd==30 | educd==40 | educd==50 | educd==61
		replace Hhighedlev=1 if educd==63 | educd==64 
		replace Hhighedlev=2 if educd==65 | educd==71 | educd==81 | educd==101 | educd==114 | educd==115 | educd==116
		
		*crap, not working ^. Well, it does, but there is missing data.
		*Ahhhh, maybe because I didn't take into account the option N/A
		*
		*
		*Also, ask Ashley if there is way to use clear all without having to wait 
		*forver to reload the data. Or like an undo of a command so you can try again
	
	*looking for race but it doesn't have Latinos?!?!?
	*Found it, you ahve to add the varibale hispanic to race
	
	
	*race
	/*
		gen Hhispanic=1 if hispan>0
		replace Hhispanic=0 if Hhispanic!=1
		gen Hnhwhite=1 if race==1 & Hhispanic!=1
		replace Hnhwhite=0 if Hnhwhite!=1
		compress
		gen Hnhblack=1 if race==2 & Hhispanic!=1
		replace Hnhblack=0 if Hnhblack!=1
		gen Hnhasian=1 if race>3 & race<7 & Hhispanic!=1
		replace Hnhasian=0 if Hnhasian!=1
		gen Hotherrace=1 if Hnhblack!=1 & Hnhwhite!=1 & Hnhasian!=1 & Hhispanic!=1
		replace Hotherrace=0 if Hotherrace!=1
		*JAS comment: I don't know if I did this right ^
	
		*once again, not sure what yrsusa1 is
		*rename yrsusa1 Hyrsusa1
		*was language a variable???
		*rename language Hlanguage
		*/
		
		rename race Hrace
		rename bpld Hbpld
		rename hispan Hhispan
		
		tab Hhispan
		tab Hhispan, nolabel
		gen Hhispanic=1 if Hhispan>0
		replace Hhispanic=0 if Hhispan!=1
		gen Hnhwhite=1 if Hrace==1 & Hhispanic!=1
		replace Hnhwhite=0 if Hnhwhite!=1
		gen Hnhblack=1 if Hrace==2 & Hhispanic!=1
		replace Hnhblack=0 if Hnhblack!=1
		gen Hnhasian=1 if Hrace>3 & Hrace<7 & Hhispanic!=1
		replace Hnhasian=0 if Hnhasian!=1
		tab Hrace if Hnhwhite==1
		tab Hrace if Hnhblack==1
		tab Hrace if Hnhasian==1
		gen Hotherrace=1 if Hnhblack!=1& Hnhwhite!=1 & Hnhasian!=1 & Hhispanic!=1
		replace Hotherrace=0 if Hotherrace!=1
	
		
	
	*parents married or not (Hmarst)
		*1=parents married, 0=parents not married
		/* Okay, the coding marst==>2 is not working. Says invalid for some reason
		*/
		gen Hmarst=1 if marst==1
		replace Hmarst=0 if marst>=2 
		
		
	*empolyment status (what to do with N/A?)
		gen Hemployed = empstat==1
		gen Hunemployed = empstat==2
		gen Hnotlaborforce = empstat==3
		
	
	keep if related==101
	*9,662,220 observations deleted
	*ask Ashley about this ^
	*do I need command "sort serial"???
	
	*I ran it all at it currently is on August 15th and it there is no missing
	*data, so I think it did it right :) 
	
	drop multyear sample cbserial hhwt cluster strata gq famunit pernum famsize subfam sftype sfrelate cbsubfam cbsftype cbsfrelate relate related hcovany school educ gradeatt gradeattd schltype vetdisab 
	*add all variables we are going to drop. Which ones?????
	
		
	save "head file.dta", replace 
		
	clear all
	
	
*Step 3: create the spouse of head of household file
	use "RAW DATA NEVER TOUCH.dta"
	
	*ask about command "set more off" and why you would need the command "no label"
	
	keep if related==201
	*12,693,409 observations deleted 
	*once again, ask about this 
	
	*drop
	*add all variables we are going to drop
	
	
	*Dependent Variable (is there one???? or is this inclusion critera?): disability
		/* Old Coding
		gen Sdisability=1 if diffrem==2 | diffphys==2 | diffmob==2 | diffcare==2 | diffsens==2 | diffeye==2 | diffhear==2 
		replace Sdisability=0 if diffrem==0 | diffrem==1 & diffphys==0 | diffphys==1 & diffmob==0 | diffmob==1 & diffcare==0 | diffcare==1 & diffsens==0 & diffeye==0 & diffhear==0
		*/
		
		gen Sdisability=1 if diffrem==2 | diffphys==2 | diffmob==2 | diffcare==2 | diffsens==2 | diffeye==2 | diffhear==2 
		replace Sdisability=0 if diffrem!=2 & diffphys!=2 & diffmob!=2 & diffcare!=2 & diffsens!=2 & diffeye!=2 & diffhear!=2 
		
		
	*age
	rename age Sage
	
	*sex 
	gen Sfemale=1 if sex==2
	replace Sfemale=0 if sex==1
	*rename Sfemale?
	
	
	*highest education level
		*0=less than highschool, 1=highschool diploma, 2=some college or more 
		gen Shighedlev=0 if educd==1 | educd==2 | educd==11 | educd==12 | educd==14 | educd==15 | educd==16 | educd==17 | educd==22 | educd==23 | educd==25 | educd==26 | educd==30 | educd==40 | educd==50 | educd==61
		replace Shighedlev=1 if educd==63 | educd==64 
		replace Shighedlev=2 if educd==65 | educd==71 | educd==81 | educd==101 | educd==114 | educd==115 | educd==116
	
	*looking for race but it doesn't have Latinos?!?!?
	*Found it, you ahve to add the varibale hispanic to race
	
	*race
	/*
		gen Shispanic=1 if hispan>0
		replace Shispanic=0 if Shispanic!=1
		gen Snhwhite=1 if race==1 & Shispanic!=1
		replace Snhwhite=0 if Snhwhite!=1
		compress
		gen Snhblack=1 if race==2 & Shispanic!=1
		replace Snhblack=0 if Snhblack!=1
		gen Snhasian=1 if race>3 & race<7 & Shispanic!=1
		replace Snhasian=0 if Snhasian!=1
		gen Sotherrace=1 if Snhblack!=1 & Snhwhite!=1 & Snhasian!=1 & Shispanic!=1
		replace Sotherrace=0 if Sotherrace!=1
		*JAS comment: Once again, is this wrong? ^
		*/
		
		
		rename race Srace
		rename bpld Sbpld
		rename hispan Shispan
		rename educd Seducd
		
		tab Shispan
		tab Shispan, nolabel
		gen Shispanic=1 if Shispan>0
		replace Shispanic=0 if Shispan!=1
		tab Srace
		tab Srace, nolabel
		gen Snhwhite=1 if Srace==1 & Shispanic!=1
		replace Snhwhite=0 if Snhwhite!=1
		compress
		gen Snhblack=1 if Srace==2 & Shispanic!=1
		replace Snhblack=0 if Snhblack!=1
		tab Srace
		tab Srace, nolabel
		gen Snhasian=1 if Srace>3 & Srace<7 & Shispanic!=1
		replace Snhasian=0 if Snhasian!=1
		tab Srace if Snhwhite==1
		tab Srace if Snhblack==1
		tab Srace if Snhasian==1
		gen Sotherrace=1 if Snhblack!=1& Snhwhite!=1 & Snhasian!=1 & Shispanic!=1
		replace Sotherrace=0 if Sotherrace!=1
	
	*parents married or not (Smarst)
		*1=parents married, 0=parents not married
		/* Okay, the coding marst==>2 is not working. Says invalid name for some reason
		*/
		gen Smarst=1 if marst==1
		replace Smarst=0 if marst>=2 
		
		
	*empolyment status (what to do with N/A?)
		gen Semployed = empstat==1
		gen Sunemployed = empstat==2
		gen Snotlaborforce = empstat==3
		*JAS comment: is this right? ^
		
		
	*I ran it all at it currently is on August 15th and it there is no missing
	*data, so I think it did it right :)
	
	drop multyear sample cbserial hhwt cluster strata gq famunit pernum famsize subfam sftype sfrelate cbsubfam cbsftype cbsfrelate relate related hcovany school educ gradeatt gradeattd schltype vetdisab  
		
		
	save "spouse file.dta", replace 
		
	clear all
	
	
*Merging the data**
	
	use "child file.dta", clear
	sort serial
	count
	merge m:1 serial using "head file.dta"
	
	/* Result                           # of obs.
    -----------------------------------------
    not matched                     6,077,436
        from master                     7,875  (_merge==1) --> kids of hh 
        from using                  6,069,561  (_merge==2) --> hh without kids 

    matched                           123,291  (_merge==3)
    -----------------------------------------
*/
	tab _merge
	drop if _merge!=3
	drop _merge
	count
	sort serial


	merge m:1 serial using "spouse file.dta"
	
	/*Result                           # of obs.
    -----------------------------------------
    not matched                     3,139,037
        from master                    53,707  (_merge==1) --> kids without a "spouse"
        from using                  3,085,330  (_merge==2) --> "spouses" without a kid

    matched                            69,584  (_merge==3)
    -----------------------------------------
*/
	tab _merge
	drop if _merge==2
	count
	drop _merge
	
	save "final_touse.dta", replace
	
	*recode parents' education, age...
	gen parent_educ = Shighedlev if Shighedlev > Hhighedlev
	replace parent_educ = Hhighedlev if Hhighedlev > Shighedlev
	replace parent_educ = Hhighedlev if Hhighedlev == Shighedlev
	replace parent_educ = Hhighedlev if Shighedlev==.
	replace parent_educ = Shighedlev if Hhighedlev==.
	*this was wierd cause Seduc_cat and Heduc_cat doesn't exist, so replaced with 
	*the varaibles that are named in my data set
	
	gen parent_age = Sage if Sage > Hage
	replace parent_age = Hage if Hage > Sage
	replace parent_age = Hage if Hage == Sage
	replace parent_age = Hage if Sage==.
	replace parent_age = Sage if Hage==.
	
	tab parent_educ, g(peduc)
	*Joey, make sure you can translate this into english! 
	*creates dummie varaibles :)
	
	gen parent_dis=1 if Hdisability==1 
	replace parent_dis=1 if Sdisability==1
	replace parent_dis=0 if Hdisability==0 & Sdisability==0
	replace parent_dis=0 if Hdisability==0 & Sdisability==. 
	
	gen income=ftoti 
	replace income=0 if ftoti<0 & ftoti!=.
	*JAS comment: is this right? 
	
	*JAS comment: also, do I need to run a correlation between the parents race 
	*like you did in the exmaple Master 1 do-file you sent me? 
	
	save "merged_finished", replace 
		
	
	
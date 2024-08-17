/*Created by: Joey in the future (but now the past... dun dun dun)
Date created: September 28, 2020 
Updated by: Joey da awesome 
Updated on: October 17th,2020

This is my do-file for anazlying the data from Master 1 do-file (which is done, YAY)

This file proceeds in three steps:
Step 1: I created Table 1 coding for ttests  
Step 2: I created Table 2 coding for regression analysis 
Step 3: 
Step 4: 
Step 5: 

After running this do-file, you will have the completed coding for the results section 

*/ 

*Step 1: create the table coding for ttests 

	cd "D:\Ashley\Education of disabled children raised by disabled parents"
	use "merged_finished"
	*"merged_finished"

	*Table 1
	*child characteristics 
	ttest heldback, by(parent_dis)
	ttest age, by(parent_dis)
	ttest female, by(parent_dis)
	ttest nhwhite, by(parent_dis)
	ttest hispanic, by(parent_dis)
	ttest nhblack, by(parent_dis)
	ttest nhasian, by(parent_dis)
	ttest otherrace, by(parent_dis)
	ttest immig, by(parent_dis)
	ttest foreignadoptee, by(parent_dis)

	*head of househole characteristics
	ttest Hmarst, by(parent_dis)
	ttest parent_age, by(parent_dis)
	ttest Hemployed, by(parent_dis)
	ttest Hunemployed, by(parent_dis)
	ttest Hnotlaborforce, by(parent_dis)
	ttest income, by(parent_dis)
	ttest parent_educ, by(parent_dis)
	ttest numkids, by(parent_dis)
	ttest numdiskids, by(parent_dis)
	ttest Hfemale, by(parent_dis)
	ttest Hhispanic, by(parent_dis)
	ttest Hnhwhite, by(parent_dis)
	ttest Hnhblack, by(parent_dis)
	ttest Hnhasian, by(parent_dis)
	ttest Hotherrace, by(parent_dis)
	
	*ttest , by(parent_dis)


*Step 2: create Table 2 coding for regression 
	gen income_log=log(income)
	replace income_log=0 if income_log==.

logistic heldback parent_dis female age nhblack hispanic nhasian otherrace immig parent_age peduc1 peduc2 income_log numkids numdiskids foreignadoptee Hmarst Hfemale Hnhblack Hnhasian Hotherrace Hhispanic Hunemployed Hnotlaborforce [pweight=perwt], cluster(serial) coef
	

/*logistic twomar adopted disability female age nhblack hispanic nhasian otherrace immig parent_age peduc1 peduc2 income_log totalkids hasdissib hassibadopt Hnhblack Hnhasian Hotherrace Hhispanic Hunemployed Hnotlaborforce [pweight=perwt], cluster(serial)

logistic DV PIV CONTROLS 
account for weights 
cluster on family id 


IMPORTANT: For categories, leave out ONE reference category 
*/
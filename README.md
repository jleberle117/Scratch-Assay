# Scratch-Assay
Automated scratch assay algorithm
 Cellular migration assays are useful in vitro techniques employed to quantify cell movement over a specified time and/or in response to treatment conditions. Cellular migration assays consist of culturing cells in a monolayer, creating an area with no cell presence, and imaging or tracking the cells as they migrate to fill in the devoid area. These assays are extensively used to study cellular behavior within complex physiological systems such as cancer metastasis, pharmaceutical drug development, and wound healing. While cellular migration assays provide simplistic outcome measures, they are time-consuming and oftentimes produce inconsistent results. This research aimed to reduce assay analysis time and variability through the use of an automated algorithm that quantifies cellular migration over time. Images of cellular migration were captured on an inverted light microscope every 4 hours for a 24 hour period. These images were uploaded to the automated algorithm software and wound width, percent closure, and summed area under the curve (AUC) values calculated. Algorithm-derived outputs were compared against manual-derived outputs and statistical analyses performed. Additionally, Algorithm-derived outputs were compared within repeat analyses of the same image sets to assess algorithm reproducibility, and statistical analyses performed. 


1.0	PURPOSE

	1.1	To outline the procedure for proper use of the MATLAB automated scratch assay wound area analysis program.

2.0	REQUIREMENTS

	2.1	A valid installation of MATLAB with Image Processing Toolbox.
	
	2.2	The following MATLAB scripts/functions:
	
	2.2.1	WoundArea_Main.m
	
	2.2.2	Islands_Holes.m
	
	2.2.3	Wound_Area.m

3.0	DEFINITIONS
	3.1	User – person directly using or responsible for using the algorithm
	3.2	Study – in the context of this SOP, a study is a scratch assay which may consist of one or more plates with one or more wells 						imaged at one or more time periods
	3.3	Parameter Descriptions
		3.3.1	SE_Size – structural element size; radius of the disk-shaped structural element used by MATLAB to approximate the size of a cell
		3.3.2	Thresh – threshold; value between 0 and 1 used to set pixels to black or white
		3.3.3	Holes_Ratio – used establish cutoff size for elements representing islands/holes

4.0	RESOURCES
	4.1	Codes can be downloaded at https://github.com/jleberle117/Scratch-Assay
		4.1.1	Click on green “Clone or Download” button.
		4.1.2	Choose “Download ZIP”
		4.1.3	Extract files to a chosen destination
	4.2	MATLAB help available at https://www.mathworks.com/help/index.html. 

5.0	RESPONSIBILITIES
	5.1	It is the responsibility of the user to follow this policy.  It is the responsibility of supervisory personnel to ensure compliance 	with this policy and to train users responsible for performing this policy.
	5.2	User must visually inspect all analyzed image files to ensure each image was processed correctly by the software.
6.0	POLICY
	6.1	Image Location & Process Parameters Setup
		6.1.1	Ensure proper files are downloaded (see 4.1)
		6.1.2	Open MATLAB.
		6.1.3	Open WoundArea_Main.m
		6.1.4	Set location where the study images are located:
			6.1.4.1	Parent = 'G:\My Drive\Scratch Assay\Sept03 Scratch';
		6.1.5	List the folders for each plate found in the study folder:
			6.1.5.1	Plate = {'Plate 1', 'Plate 2', 'Plate 3'};
		6.1.6	List the folders for each time point found in each plate folder:
			6.1.6.1	Time_Point = {'0hr', '4hr', '8hr', '12hr', '16hr'};
		6.1.7	List the image names for each well taken at each time point:
			6.1.7.1	Well_Name = {'1a', '1b', '1c', '1d', '2a', '2b', '2c', '2d', '3a', '3b', '3c', '3d', '4a', '4b', '4c', '4d'};
		6.1.8	Add/remove plates, time points, and wells as needed. 
		6.1.9	Be sure the wording for all plates, time points, and wells are exactly what is used in your folders.
		6.1.10	Set amount of time between images:
			6.1.10.1	dt=4;
				6.1.10.1.1	Images must be taken at regular intervals
		6.1.11	Ensure the “image location” parameters set within the MATLAB script match EXACTLY to the file management structure of the 							scratch assay images.
	6.2	Program Operation
		6.2.1	Click the green triangle above the “Run” button in the “Editor” tab in the ribbon at the top of the program script window.
			6.2.1.1	Depending on the number of photos to be analyzed, the program may take hours to finish.
			6.2.1.2	Processed images will be automatically saved to a “results” folder within each time point folder.
			6.2.1.3	A ‘.csv’ file will be written to the same folder where Script_WoundArea.m is saved.
				6.2.1.3.1	The program outputs plate number, time point, well name, average wound width, standard deviation of the wound width, time 				to analyze the image, wound percent closed, and .
			6.2.1.4	Be sure to rename the file before running another study as the script will overwrite the file with each run.

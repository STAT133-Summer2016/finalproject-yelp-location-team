# finalproject-yelp-location-team  

Contributors: Anuj Desai, Irene Lee

####Project Description:  
1. Analyze if location determines business success and if certain attributes affect business rating  
2. Determine if a relationship exists betweeen a review's text and its business rating  
3. Determine if reviewers' behaviors change when they are in unfamiliar locations  

####Repository Contents:
* `raw_data`  
    * Files too large to upload to GitHub. Available for download at: https://www.yelp.com/dataset_challenge/dataset. Input name, email, and accept terms of use for zip file of JSON datasets. 
    * `codebook.txt` contains description of JSON objects in yelp-business, review, and user datasets.

* `clean_data`
    * `CleanData.R` cleans raw_data into tidy format. 
    * also contains cleaned `.csv` files for analysis and data visualizations.  

* `eda`
    * `.Rmd` and `.html` files containing explorations of data and analyses
    
* `functions`
    * `.R` files containing each function written

* `paper`
    * `.Rmd` file that produces final report. Code embedded but `echo = FALSE`
    * knitted `.pdf` version of paper

* Clone repository and run `skeleton.R` to create all directories and necessary `.csv` files. When finished, knit `paper.Rmd` to reproduce final document with plots and analyses.

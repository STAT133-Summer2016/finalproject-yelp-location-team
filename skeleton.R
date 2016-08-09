# This file creates directories and downloads the rawdata

# To download data, unfortunately, you must visit:
# https://www.yelp.com/dataset_challenge/dataset
# and input your name, email, and agree to the terms of use for the dataset
# all files are in JSON format

# Create directories
dir.create("raw_data")
dir.create("clean_data")
dir.create("paper")
dir.create("eda")
dir.create("functions")


# This installs all the packages you'll need by calling packages.R
source("packages.R")
# This calls CleanData.R
source("clean_data/CleanData.R")
# Load all functions
source("functions/WordCloud.R")
source("functions/MeanStar.R")
source("functions/PercentAccuracy.R")

# Note: Please be patient. Raw data is massive and takes minutes to read and process!
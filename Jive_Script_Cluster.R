require(tidyverse)
require(r.jive)

results <- '/gpfs/milgram/project/gee_dylan/lms233/CMI_ABCD/Results'

#Read in JIVE data

# pheno_data <- read_csv('/Users/lucindasisk/Box/LS_Folders/CMI_ABCD/final_pheno_sample1_LS_1.15.19.csv', col_names = TRUE)
# myelin_data <- read_csv('/Users/lucindasisk/Box/LS_Folders/CMI_ABCD/ABCD_Metrics/CMI_ABCD_Sample1_myelin.csv', col_names = TRUE)
# thick_data <- read_csv('/Users/lucindasisk/Box/LS_Folders/CMI_ABCD/ABCD_Metrics/CMI_ABCD_Sample1_thickness.csv', col_names=TRUE)

pheno_data <- read_csv('/gpfs/milgram/project/gee_dylan/lms233/CMI_ABCD/final_pheno_sample1_LS_1.15.19.csv', col_names = TRUE)
myelin_data <- read_csv('/gpfs/milgram/project/gee_dylan/lms233/CMI_ABCD/CMI_ABCD_Sample1_myelin.csv', col_names = TRUE)
thick_data <- read_csv('/gpfs/milgram/project/gee_dylan/lms233/CMI_ABCD/CMI_ABCD_Sample1_thickness.csv', col_names=TRUE)

not_all_na <- function(x) any(!is.na(x))

#Drop ID columns; drop all columns that sum to 0
myelin_data_clean <- myelin_data %>%
    select_if(not_all_na)

#Drop ID columns; drop all columns that sum to 0
thick_data_clean <- thick_data %>%
    select_if(not_all_na)

#Merge data frames to ensure they are in same order
brain_df <- right_join(myelin_data_clean, thick_data_clean, by = 'subid')
pheno_brain <- full_join(pheno_data, myelin_data_clean, by=c('subjectkey'='subid'))

new_myelin <- brain_df %>%
    select("zmyelin_set1":"zmyelin_set16383")

new_thick <- brain_df %>%
    select("zthickness_set1":"zthickness_set16383")

new_pheno <- pheno_brain %>%
    select("cbcl_scr_syn_anxdep_t":"trauma_num")

#Transpose so IDs are columns
new_pheno_mat <- t(new_pheno)
new_myelin_mat <- t(new_myelin)
new_thick_mat <- t(new_thick)


#Combine measures into list
data <- list(new_pheno_mat, new_myelin_mat, new_thick_mat)

#Run JIVE analysis

#Estimate JIVE ranks based on permutation testing (best validated)
#Row-orthogonality enforced between the joint and individual estimates and also between each individual estimate.
#Compute ranks
(try(cmi_jive_result <- jive(data, scale = FALSE)))

#Get Results
result_joint_rank <- cmi_jive_result$rankJ
result_individ_rank <- cmi_jive_result$rankA

#Plot variance explained by individual and joint ranks, and noise
(try(cmi_jive_var <- showVarExplained(cmi_jive_result, col = c("#811c4e", "#fdb663", "#37486d"))))

#Plot heatmaps of results
(try(cmi_jive_heatmaps <- showHeatmaps(cmi_jive_result, order_by = 0, show_all = TRUE)))

#Plot PCA
try(cmi_jive_pca <- showPCA(cmi_jive_result, n_joint = result_joint_rank, n_indiv = c(1,1,1), Colors = c("#811c4e", "#fdb663")))
#No clustering efects apparent

##Save images
#Save variance images
png(paste(results, "/CMI_JIVE_VarExplained.png", sep=''),height=300,width=450)
cmi_jive_var
dev.off()

#Save heatmaps
png(paste(results, "/CMI_JIVE_Heatmaps.png", sep=''),height=465,width=705)
cmi_jive_heatmaps
dev.off()

#Save PCA plots
png(paste(results, "/CMI_JIVE_PCA_plots.png", sep=''),height=600,width=600)
cmi_jive_pca
dev.off()

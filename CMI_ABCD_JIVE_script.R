if(!require(r.jive)){install.packages("r.jive")}
if(!require(psycho)){install.packages("psycho")}
if(!require(tidyverse)){install.packages("tidyverse")}

#Read in JIVE data
brain_data <- read_csv('CMI_Collab_Brain_Measures_1.4.19.csv')
pheno_data <- read_csv('phenoData_analysis_08062019.csv')

#Drop ID columns; drop all columns that sum to 0
brain_datano0 <- brain_data %>%
    select(-c('subid')) %>%
    select_if(colSums(.) > 0 ) %>%
    mutate("subid" = brain_data$subid)

#Standardize (scale and center) brain data
brain_data_scaled <- brain_datano0 %>%
    standardize()

#Standardize (scale and center) phenotypic data
pheno_data_scaled <- pheno_data %>%
    standardize() %>%
    rename("subid" = "subjectkey")

#Merge data frames to ensure they are in same order
combined_df <- left_join(pheno_data_scaled, brain_data_scaled, by = 'subid')

new_pheno <- combined_df %>%
    select('interview_age','cbcl_scr_syn_anxdep_t':'trauma_num') %>%
    mutate_all(funs(replace_na(., 0))) #Replace NAs with 0's --> check if OK

new_brain <- combined_df %>%
    select('area_L_1':'thickness_R_20442')

#Convert non-continuous data to factors
# new_pheno$sex <- as.factor(new_pheno$sex)
# new_pheno$site_id_l <- as.factor(new_pheno$site_id_l)

#Transpose so IDs are columns
new_pheno_mat <- t(new_pheno)
new_brain_mat <- t(new_brain)

#Run JIVE analysis

data <- list(new_pheno_mat, new_brain_mat)


(try(cmi_jive_result <- jive(data, scale = FALSE)))
(try(cmi_jive_summary <- summary.jive(cmi_jive_result)))
(try(cmi_jive_var <- showVarExplained(cmi_jive_result, col = c("grey20", "grey43", "grey65"))))
(try(cmi_jive_heatmaps <- showHeatmaps(cmi_jive_result, order_by = 0, show_all = TRUE)))
(try(cmi_jive_pca <- showPCA(cmi_jive_result, n_joint = 0, n_indiv = rep(0, length(result$data)),
                             Colors = "black", pch=1)))

(try(cmi_jive_it <- jive.iter(data)))

(try(cmi_jive_perm <- jive.perm(data)))

(try(cmi_jive_bic <- bic.jive(data)))

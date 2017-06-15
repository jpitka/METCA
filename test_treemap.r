
library(popEpi)
library(fcr)
library(data.table)
library(treemap)


fcrall <- fcr_load()

fcr <- fcr_fetch(fcrall, sites=c(0), dg_y = 2014)

#UPPER LEVEL CANCER TYPES
# taulukoidaan ja lisätään pyrs
tab <- ltable(fcr, by.vars = c('sex','agegroup','dg_y','categ2'),  na.rm = TRUE)
## add person years
tab <- fcr_pyrs(data = tab,  var.sex = 'sex',  var.agegroup = 'agegroup',  
                var.year = 'dg_y')
res1<-fcr_rate(data = tab, 
              var.agegroup = 'agegroup', 
              var.obs = 'obs', 
              var.pyrs = 'pyrs',
              var.year = 'dg_y',
              strata = c('sex','categ2'),
              std.population = 'world_1966_18of5')
res1$categ3<-NA

#LOWER LEVEL
## get counts of cases by sex, age group, and year of diagnosis
#tab <- ltable(fcr, by.vars = c('sex','agegroup','dg_y','categ3'),  na.rm = TRUE)
## add person years
#tab <- fcr_pyrs(data = tab,  var.sex = 'sex',  var.agegroup = 'agegroup',  
#                var.year = 'dg_y')
#res2<-fcr_rate(data = tab, 
         #var.agegroup = 'agegroup', 
         #var.obs = 'obs', 
         #var.pyrs = 'pyrs',
         #var.year = 'dg_y',
         #strata = c('sex','categ3'),
         #std.population = 'world_1966_18of5')
#res2$categ2<-2

fcragg<-rbind(res1)
fcragg$categ2<-cn(fcragg$categ2,lang="FI")
#fcragg$categ3<-cn(fcragg$categ3,lang="FI")


#fcr<-read.csv2("C:/users/janne.pitkaniemi/Downloads/fcr_2017-02-24.csv",header=TRUE)
#fcr<-read.csv2("C:/users/janne.pitkaniemi/Downloads/fcr_2017-02-24 (1).csv",header=TRUE)
#colnames(fcr)<-c("luokka","ICD","Uudet tapaukset","rate1","rate2","rate3","luokka1","luokka2")
fcragg<-fcragg[sex==1,]
#fcragg<-fcragg[-1,]
fcragg$label <- paste(fcragg$categ2, fcragg$`obs`, sep = "\n")

treemap(fcragg, 
        index=c("label"), 
        vSize="obs", 
        vColor="rate", 
        type="value", 
        palette="RdYlBu",
        title="Uudet syöpätapaukset 2012", 
        fontsize.title = 14)


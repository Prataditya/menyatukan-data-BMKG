install.packages("readxl")
install.packages("lubridate")
library("lubridate")
library("readxl")

#pilih folder dimana terdapat data BMKG
mydir<-choose.dir()
myfile<-list.files(mydir)
coln<-colnames(read_excel(paste(mydir,myfile[1], sep="/"), skip=8))

#berikan nama file output ex. "compile.csv" (hanya csv)
namafile<-""
outdir<-file.path(mydir,namafile)

#masukan tanggal awal (stdate) dan akhir(ovdate) "YYYY-MM-DD", ex. "1998-12-31"
stdate<-""
ovdate<-""
mydate<-seq(as.Date(stdate), as.Date(ovdate), by = "day")
myoutput<-matrix(9999,ncol=length(coln), nrow=length(mydate))
myoutput[,1]<-as.character(mydate)

#loop menyatukan file
mydata<-data.frame()
for (i in 1:length(myfile)) {
   a<-read_excel(paste(mydir,myfile[i], sep="/"), skip=8, n_max=31)
   mydata<-rbind(mydata, a)
}
mydata$Tanggal<-as.Date(mydata$Tanggal, format="%d-%m-%Y")

#loop merapikan data
for (i in 1:length(myoutput[,1])) {
   for (j in 2:length(coln)) {
      k=which(mydata[,1]==myoutput[i,1])
      myoutput[i,j]<-as.character(mydata[k,j])
   }
}
colnames(myoutput)<-coln

#filter data nol
myoutput[myoutput=="numeric(0)"]<-NA
myoutput[myoutput=="logical(0)"]<-NA
myoutput[myoutput=="character(0)"]<-NA
myoutput[myoutput==8888]<-NA
myoutput[myoutput==9999]<-NA

#menyimpan hasil olahan, file terdapat pada folder yang dipilih di awal
View(myoutput)
write.csv(myoutput,outdir)

#selesai
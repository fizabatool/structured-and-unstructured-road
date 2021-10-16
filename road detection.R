
library(EBImage)
library(keras)
setwd("/Users/i Dolphin Online/Documents/road")
pics<-list.files(path="/Users/i Dolphin Online/Documents/road", pattern=".jpg",all.files=T)
mypic<-list()
for (i in 1:20) {mypic[[i]]<-readImage(pics[i])}
str(mypic)
for (i in 1:20) {mypic[[i]]<-resize(mypic[[i]], 224,224)}
str(mypic)
display(mypic[[4]])
for (i in 1:20) {mypic[[i]]<-array_reshape(mypic[[i]], c(224,224,3))}
trainx <-NULL
for (i in 1:7) {trainx<- rbind(trainx,mypic[[i]])}
str(trainx)
for (i in 11:17) {trainx<- rbind(trainx,mypic[[i]])}
str(trainx)
testx<-NULL
for (i in 8:10) {testx<- rbind(testx,mypic[[i]])}
for (i in 18:20) {testx<- rbind(testx,mypic[[i]])}
str(testx)
trainy<-c(0,0,0,0,0,0,0,1,1,1,1,1,1,1)
testy<-c(0,0,0,1,1,1)
library(keras)
trainlabels<-to_categorical(trainy)
testlabels<-to_categorical(testy)
model <-keras_model_sequential()
model%>%
  layer_dense(units=256,activation = 'relu',input_shape = c(150528)) %>%
  layer_dense(units = 126,activation = 'relu') %>%
  layer_dense(units=2,activation = 'softmax')
summary(model)
model %>%
  compile(loss='binary_crossentropy',optimizer=optimizer_rmsprop(),metrics=c('accuracy'))
history <- model%>%
  fit(trainx,trainlabels,epochs=30,batch_size=3,validation_split=0.2)
model%>%evaluate(trainx,trainlabels)
pred<-model%>% predict_classes(testx)
table(Predicted=pred,Actual=testy)
import { NativeStorage } from '@ionic-native/native-storage';
import { Component } from '@angular/core';
import { IonicPage, NavController } from 'ionic-angular';
import { AngularFirestore, AngularFirestoreCollection, AngularFirestoreDocument } from 'angularfire2/firestore';
import { Observable } from 'rxjs/Observable';
import 'rxjs/add/operator/map';
import { DatePipe } from '@angular/common'

interface Items {
  description: string;
  itemid: number;
 }

@IonicPage()
@Component({
  selector: 'page-about',
  templateUrl: 'about.html'
})
export class AboutPage {

  userDoc: any;
  date: any = new Date();
  formatedDate: any;
  userProfileCollection:any;

  itemsCollection: AngularFirestoreCollection<Items>; //Firestore collection
  itemsDocument: AngularFirestoreDocument<Items>; //Firestore document
  items: Observable<Items[]>; // read collection

  constructor(public navCtrl: NavController, public nativeStorage: NativeStorage, private fireStore: AngularFirestore, public datepipe: DatePipe) {
    this.formatedDate =this.datepipe.transform(this.date, 'yyyy-MM-dd');
    console.log('date:',this.formatedDate)
  }

  ionViewWillEnter() {
    this.itemsCollection = this.fireStore.collection('Admin'); //ref()
    this.itemsDocument = this.fireStore.doc('ELE552'); 
    this.items = this.itemsCollection.valueChanges()
 }

  add(){
    // this.userDoc = this.fireStore.doc<any>('ADMIN/EPO552/PEE2005A/'+this.formatedDate);
    // this.userDoc.set({
    //   name: 'Jorge Vergara',
    //   email: 'j@javebratt.com',
    // // Other info you want to add here
    // })
    // console.log('data add')
    this.itemsCollection.add({
      description: "1TB Space with great performance",
      itemid: 13423
    })
    .then( (result) => {
        console.log("Document addded with id >>> ", result.id);
    })
    .catch( (error) => {
        console.error("Error adding document: ", error);
    });
  }

  add1(){
    this.itemsCollection.add({
      description: "5TB Space with great performance",
      itemid: 4213
    })
    .then( (result) => {
        console.log("Document addded with id >>> ", result.id);
    })
    .catch( (error) => {
        console.error("Error adding document: ", error);
    });
  }
}

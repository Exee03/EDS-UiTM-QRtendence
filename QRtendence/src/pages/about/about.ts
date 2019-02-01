import { NativeStorage } from '@ionic-native/native-storage';
import { Component } from '@angular/core';
import { IonicPage, NavController } from 'ionic-angular';

@IonicPage()
@Component({
  selector: 'page-about',
  templateUrl: 'about.html'
})
export class AboutPage {

  user: any;
  items: any[] = [];
  inputText1:string;

  constructor(public navCtrl: NavController, public nativeStorage: NativeStorage) {
    this.nativeStorage.getItem('user')
    .then( data => 
      this.user = {
        provider: data.provider,
        name: data.name,
        email: data.email,
        picture: data.picture
      }
    )
  }

  load(){
    
    this.nativeStorage.remove(this.inputText1)
    console.log(this.inputText1, "is delete")
  }

  load1(){
    let array1 = [0, 1, 2];
    let array2 = [3, 4, 5];
    let bothTogether = array1.concat(array2);
    console.log(bothTogether);
  }
}

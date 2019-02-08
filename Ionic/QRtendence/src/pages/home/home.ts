import { Component } from '@angular/core';
import { IonicPage, NavController } from 'ionic-angular';
import { NativeStorage } from '@ionic-native/native-storage';
import { LoginPage } from '../login/login';
import { AuthServiceProvider } from '../../providers/auth-service/auth-service';

@IonicPage()
@Component({
  selector: 'page-home',
  templateUrl: 'home.html',
})

export class HomePage {

  user: any;
  userReady: boolean = false;

  constructor(public navCtrl: NavController, public nativeStorage: NativeStorage, public authService: AuthServiceProvider) {
    this.nativeStorage.getItem('user')
    .then( data => 
      this.user = {
        provider: data.provider,
        name: data.name,
        email: data.email,
        picture: data.picture
      }
    );
  }

  ionViewDidLoad() {
    console.log('ionViewDidLoad HomePage');
  }

  save(){
    this.nativeStorage.setItem('myitem', {property: 'value', anotherProperty: 'anotherValue'})
    .then(
      () => console.log('Stored item!'),
      error => console.error('Error storing item', error)
    );
  }

  get(){
    this.nativeStorage.getItem('myitem')
    .then(
      data => console.log(data))
  }

  key(){
    this.nativeStorage.keys().then((data) => console.log(data))
  }

  usersName(){
    
      console.log("get name")
      console.log(this.user.name)
      
      this.userReady = true;
      
  }

  usersEmail(){

      console.log("get email")
      console.log(this.user.email)
  }

  usersPic(){
    
      console.log("get pic")
      console.log(this.user.picture)
  }

  logout(){
    if(this.user.provider === "google.com"){
      console.log("Google logout")
    }
    if(this.user.provider === "facebook.com"){
      console.log("Facebook logout")
    }
    this.nativeStorage.remove('user');
    console.log("logout")
    this.nativeStorage.keys().then((data) => console.log(data))
    this.authService.doLogout()
    .then((res) => {
      this.navCtrl.push(LoginPage)
    }, (error) => {
      console.log("Logout error", error);
    });
  }
}

import { Component, ViewChild } from '@angular/core';
import { IonicPage, NavController, NavParams, Nav, App } from 'ionic-angular'; 
import { NativeStorage } from '@ionic-native/native-storage';
import { AuthServiceProvider } from '../../providers/auth-service/auth-service';

@IonicPage()
@Component({
  selector: 'page-menu',
  templateUrl: 'menu.html',
})
export class MenuPage {

  rootPage = 'TabsPage';
  @ViewChild(Nav) nav: Nav;

  user: any;
  userReady: boolean = false;

  constructor(public navCtrl: NavController, public navParams: NavParams, public nativeStorage: NativeStorage, public authService: AuthServiceProvider, private appCtrl: App) {
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
    console.log('ionViewDidLoad MenuPage');
  }

  ionViewDidEnter(){
    this.userReady = true;
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
      this.appCtrl.getRootNav().setRoot('LoginPage');
    }, (error) => {
      console.log("Logout error", error);
    });
  }

}

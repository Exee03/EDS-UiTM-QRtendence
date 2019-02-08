import { Component } from '@angular/core';
import { IonicPage, NavController, NavParams } from 'ionic-angular';
import { FormBuilder, FormGroup, FormControl } from '@angular/forms';
import { AuthServiceProvider } from '../../providers/auth-service/auth-service';

@IonicPage()
@Component({
  selector: 'page-login',
  templateUrl: 'login.html',
})
export class LoginPage {

  loginForm: FormGroup;
  errorMessage: string = '';

  constructor(
    public navCtrl: NavController,
    public navParams: NavParams,
    public authService: AuthServiceProvider,
    public formBuilder: FormBuilder
    ) {}

  ionViewDidLoad() {
    console.log('ionViewDidLoad LoginPage');
    this.loginForm = this.formBuilder.group({
      email: new FormControl(),
      password: new FormControl(),
    });
  }

  tryFacebookLogin(){
    this.authService.doFacebookLogin()
    .then((res) => {
      this.navCtrl.setRoot('MenuPage');
    }, (err) => {
      this.errorMessage = err.message;
    });
  }

  tryGoogleLogin(){
    this.authService.doGoogleLogin()
    .then((res) => {
      this.navCtrl.setRoot('MenuPage');
    }, (err) => {
      this.errorMessage = err.message;
    });
  }

}

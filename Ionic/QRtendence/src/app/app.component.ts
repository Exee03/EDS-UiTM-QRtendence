import { Component } from '@angular/core';
import { Platform } from 'ionic-angular';
import { StatusBar } from '@ionic-native/status-bar';
import { SplashScreen } from '@ionic-native/splash-screen';
import { GooglePlus } from '@ionic-native/google-plus';
import { Facebook } from '@ionic-native/facebook';


@Component({
  templateUrl: 'app.html'
})
export class MyApp {

  rootPage:any = 'LoginPage';

  constructor(
    platform: Platform,
    statusBar: StatusBar,
    splashScreen: SplashScreen,
    public googlePlus: GooglePlus,
    public facebook: Facebook) {
      platform.ready().then(() => {

        // Okay, so the platform is ready and our plugins are available.
        // Here you can do any higher level native things you might need.
        // user is previously logged and we have his data
        // we will let him access the app
        // this.googlePlus.trySilentLogin({
        //   'scopes': '', // optional, space-separated list of scopes, If not included or empty, defaults to `profile` and `email`.
        //   'webClientId': '724374900256-j2j06ebree9s7ftgf7dbrurp8dsn2fis.apps.googleusercontent.com', // optional clientId of your Web application from Credentials settings of your project - On Android, this MUST be included to get an idToken. On iOS, it is not required.
        //   'offline': true
        // })
        // .then((data) => {
        //   this.nav.push(TabsPage);
        //   splashScreen.hide();
        // }, (error) => {
        //   this.nav.push(LoginPage);
        //   splashScreen.hide();
        // });

        // this.facebook.try({
        //   'scopes': '', // optional, space-separated list of scopes, If not included or empty, defaults to `profile` and `email`.
        //   'webClientId': '724374900256-j2j06ebree9s7ftgf7dbrurp8dsn2fis.apps.googleusercontent.com', // optional clientId of your Web application from Credentials settings of your project - On Android, this MUST be included to get an idToken. On iOS, it is not required.
        //   'offline': true
        // })
        // .then((data) => {
        //   this.nav.push(TabsPage);
        //   splashScreen.hide();
        // }, (error) => {
        //   this.nav.push(LoginPage);
        //   splashScreen.hide();
        // });

        statusBar.styleDefault();
        splashScreen.hide();
      });
    }
}

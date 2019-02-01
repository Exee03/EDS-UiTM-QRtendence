import { Injectable } from '@angular/core';
import { Platform } from 'ionic-angular';
import 'rxjs/add/operator/toPromise';
import { AngularFireAuth } from 'angularfire2/auth';
import * as firebase from 'firebase/app';
import { Facebook } from '@ionic-native/facebook';
import { GooglePlus } from '@ionic-native/google-plus';
import { FirebaseUserModel } from '../user-model/user-model';
import { environment } from '../environment/environment';
import { NativeStorage } from '@ionic-native/native-storage'

@Injectable()
export class AuthServiceProvider {

  user: any;

  constructor(
    public afAuth: AngularFireAuth,
    public facebook: Facebook,
    public googlePlus: GooglePlus,
    public platform: Platform,
    private nativeStorage: NativeStorage
    ) {}
   
  doGoogleLogin(){
    return new Promise<FirebaseUserModel>((resolve, reject) => {
      if (this.platform.is('cordova')) {
        this.googlePlus.login({
          'scopes': 'https://www.googleapis.com/auth/plus.me', // optional, space-separated list of scopes, If not included or empty, defaults to `profile` and `email`.
          'webClientId': environment.googleWebClientId, // optional clientId of your Web application from Credentials settings of your project - On Android, this MUST be included to get an idToken. On iOS, it is not required.
          'offline': true
        }).then((response) => {
          const googleCredential = firebase.auth.GoogleAuthProvider.credential(response.idToken);
          firebase.auth().signInWithCredential(googleCredential)
          .then((user) => {
            console.log(user);
            this.nativeStorage.setItem('user',{provider: user.providerData[0].providerId,name: user.displayName,email: user.email,picture: user.photoURL}).then(() => console.log('Login with Google!'))
            resolve();
          });
        },(err) => {
          reject(err);
        });
      }
      else{
        this.afAuth.auth
        .signInWithPopup(new firebase.auth.GoogleAuthProvider())
        .then((user) => {
            resolve()
        },(err) => {
          reject(err);
        })
      }
    })
  }
   
  doFacebookLogin(){
    return new Promise<FirebaseUserModel>((resolve, reject) => {
      if (this.platform.is('cordova')) {
        //["public_profile"] is the array of permissions, you can add more if you need
        this.facebook.login(["public_profile"])
        .then((response) => {
          const facebookCredential = firebase.auth.FacebookAuthProvider.credential(response.authResponse.accessToken);
          firebase.auth().signInWithCredential(facebookCredential)
            .then(user => {
              var bigImgUrl = "https://graph.facebook.com/" + user.providerData[0].uid + "/picture?height=500";
              this.nativeStorage.setItem('user',{provider: user.providerData[0].providerId,name: user.displayName,email: user.email,picture: bigImgUrl}).then(() => console.log('Login with Facebook!'))
              resolve()
            });
        }, err => reject(err)
        );
      }
      else {
        this.afAuth.auth
        .signInWithPopup(new firebase.auth.FacebookAuthProvider())
        .then(result => {
          //Default facebook img is too small and we need a bigger image
          var bigImgUrl = "https://graph.facebook.com/" + result.additionalUserInfo.profile.id + "/picture?height=500";
          // update profile to save the big fb profile img.
          firebase.auth().currentUser.updateProfile({
            displayName: result.user.displayName,
            photoURL: bigImgUrl
          }).then(res => resolve()
          ,(err) => {
            reject(err);
          });
        },(err) => {
          reject(err);
        })
      }
    })
  }

  doLogout(){
  return new Promise((resolve, reject) => {
    if(firebase.auth().currentUser){
      this.afAuth.auth.signOut()
      resolve();
    }
    else {
      reject();
    }
  });
  }

}

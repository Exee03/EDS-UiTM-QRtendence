import { Person } from './../../models/person';
import { Component } from '@angular/core';
import { NavController, NavParams } from 'ionic-angular';
import { BarcodeScanner } from '@ionic-native/barcode-scanner';

@Component({
  selector: 'page-home',
  templateUrl: 'home.html'
})
export class HomePage {
	qrData = null;
	createdCode = null;
  scanedCode = null;
  
  item: Person={
    firstName: 'Joe',
    lastName: 'woof'
  }

  constructor(public navCtrl: NavController, private barcodeScanner: BarcodeScanner, public navParams: NavParams) {

  }

  createCode() {
  	this.createdCode = this.qrData;
  }

  scanCode() {
  	this.barcodeScanner.scan().then(barcodeData => {
  		this.scanedCode = barcodeData.text;
  	})
  }

}

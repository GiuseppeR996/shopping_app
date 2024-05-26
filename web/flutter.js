// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
import "firebase/database";
import { getAnalytics } from "firebase/analytics";
// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
// For Firebase JS SDK v7.20.0 and later, measurementId is optional
const firebaseConfig = {
    apiKey: "AIzaSyC1PFFjFfxSzGSEKV_KTABINeOtRM8ZuNY",
    authDomain: "shoppingapp-d0a5f.firebaseapp.com",
    projectId: "shoppingapp-d0a5f",
    storageBucket: "shoppingapp-d0a5f.appspot.com",
    messagingSenderId: "751398151035",
    appId: "1:751398151035:web:3b4148b37ff2109adf93de",
    measurementId: "G-CFDPNY4797"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const analytics = getAnalytics(app);
const database = firebase.database();

database.ref('path/to/data').on('value', (snapshot) => {
    const data = snapshot.val();
    console.log(data);
});
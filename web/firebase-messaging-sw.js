// web/firebase-messaging-sw.js
importScripts("https://www.gstatic.com/firebasejs/10.7.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/10.7.0/firebase-messaging-compat.js");

firebase.initializeApp({
    apiKey: 'AIzaSyD4Tit2xbkQQrwhZ04qBGpPpLojlMWwQ0I',
    appId: '1:512466565099:web:e3a97701068d6585088bae',
    messagingSenderId: '512466565099',
    projectId: 'notes-pbi',
    authDomain: 'notes-pbi.firebaseapp.com',
    storageBucket: 'notes-pbi.firebasestorage.app',
    databaseURL: 'https://notes-pbi-default-rtdb.asia-southeast1.firebasedatabase.app'
});

const messaging = firebase.messaging();

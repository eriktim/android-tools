# Sign and zipalign an APK

*debian*

Create a private key if you do not have one yet.

    $ keytool -genkey -v -keystore keystore -alias android -keyalg RSA -keysize 2048 -validity 10000

Sign and verify the package.

    $ jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore keystore Package.apk android
    $ jarsigner -verify Package.apk
    jar verified.

Zipalign the package.

    $ zipalign -v 4 Package.apk Package-aligned.apk

\[1\] <http://developer.android.com/tools/publishing/app-signing.html>


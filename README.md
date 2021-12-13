# libsodium_asym_encr_pinenacl

Curve25519 encryption with CryptoBox and SealedBox

For more information see here: http://fluttercrypto.bplaced.net/libsodium-asymmetric-encryption-playground-pinacl/

```plaintext
https://pub.dev/packages/pinenacl
pinenacl: ^0.3.3

https://pub.dev/packages/url_launcher
url_launcher: ^6.0.12

https://pub.dev/packages/path_provider
path_provider: ^2.0.5

in AndroidManifest.xml ergänzen:

    <queries>
        <!-- If your app opens https URLs -->
        <intent>
            <action android:name="android.intent.action.VIEW" />
            <data android:scheme="https" />
        </intent>
    </queries>
```    

Private key Sender:
```plaintext
x8QHckjKjnqbb7jkzbI1NaE2vMqq81KutHOokHTGuVs=
```

PublicKey Sender:
```plaintext
g7Nl5vgvsH4U9U3rTmWPWXGJTPMgaWi0++jqtailV18=
```

Private key Empfänger:
```plaintext
kLRtpfG1xhQYQ8xMnCj7mnsRstLM0fIbXVun7dXmydw=
```

PublicKey Empfänger:
```plaintext
3WGo2WxG4jDZrn+/ybVEOz2fRU9Bt0ISOC4RKGbrRkU=
```

Klartext:
```plaintext
Mein wichtiges Geheimnis
```

Sample Curve25519 CryptoBox:
```plaintext
{
  "algorithm": "Curve25519 CryptoBox",
  "ciphertext": "usK1d1Ka65jnTVGaF6gr/DJ2IZlp7HaPIHKT+b97QBvE69wCdQ9MznHag+dT6LHf7Y2xSzQU2flYWjf3ukYSZQ==",
  "public key sender": ""
}
```

Sample Curve25519 SealedBox:
```plaintext
{
  "algorithm": "Curve25519 SealedBox",
  "ciphertext": "8YXkF6rNd+afnMFREHZ9MXbFIwXwgrAXOkLRFjtfGmkQattBP2ubAKsMg9G6Nik3tHbof60WRL1MVyqq7OVOYqXsL1Xo2jMz",
  "public key sender": ""
}
```

development environment:
```plaintext
Android Studio Arctic Fox Version 2020.3.1 Patch 3
Build #AI-203.7717.56.2031.7784292
Runtime version: 11.0.10+0-b96-7249189 aarch64
VM: OpenJDK 64-Bit Server VM
Flutter 2.5.3 channel stable Framework Revision 18116933e7
Dart 2.14.4
```

tested on:
```plaintext
Android Simulator: 
  Android 11 (SDK 30) Emulator,
  Android 12 SV2 (SDK 31) Emulator, 
  Android 6 (SDK 23) Emulator,
  Android 5 (SDK 21) Emulator.
iOS Simulator:  
  iOS 15 Emulator
  iOS 11.4 Emulator 


## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

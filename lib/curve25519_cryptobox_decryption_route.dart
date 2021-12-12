import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinenacl/x25519.dart';
import 'storage.dart';
import 'storage_rec.dart';

class Curve25519CryptoBoxDecryptionRoute extends StatefulWidget {
  const Curve25519CryptoBoxDecryptionRoute({Key? key}) : super(key: key);

  final String title = 'CryptoBox Entschlüsselung';

  @override
  _MyFormPageState createState() => _MyFormPageState();
}

class _MyFormPageState extends State<Curve25519CryptoBoxDecryptionRoute> {
  @override
  void initState() {
    super.initState();
    descriptionController.text = txtDescription;
  }

  final _formKey = GlobalKey<FormState>();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController ciphertextController = TextEditingController();
  TextEditingController privateKeyController = TextEditingController();
  TextEditingController publicKeySenController = TextEditingController();
  TextEditingController outputController = TextEditingController();
  TextEditingController signatureVerificationController =
      TextEditingController();

  String txtDescription =
      'CryptoBox Entschlüsselung.'
      ' Alle Schlüssel sind Base64 encoded.'
      ' Zur Entschlüsselung wird der eigene Private key (Empfänger) und der'
      ' Public key des Senders benötigt.';

  Future<bool> _fileExistsPrivateKeyRec() async {
    bool ergebnis = false;
    await StorageRec().filePrivateKeyExists().then((bool value) {
      setState(() {
        if (value == true) {
          privateKeyController.text = 'Datei existiert ';
        } else {
          privateKeyController.text = 'Datei existiert NICHT';
        }
        ergebnis = value;
      });
    });
    return ergebnis;
  }

  Future<void> _readDataPrivateKeyRec() async {
    StorageRec().readDataPrivateKey().then((String value) {
      setState(() {
        privateKeyController.text = value;
      });
    });
  }

  Future<bool> _fileExistsPublicKeySen() async {
    bool ergebnis = false;
    await Storage().filePublicKeyExists().then((bool value) {
      setState(() {
        if (value == true) {
          publicKeySenController.text = 'Datei existiert ';
        } else {
          publicKeySenController.text = 'Datei existiert NICHT';
        }
        ergebnis = value;
      });
    });
    return ergebnis;
  }

  Future<void> _readDataPublicKeySen() async {
    Storage().readDataPublicKey().then((String value) {
      setState(() {
        publicKeySenController.text = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                // form description
                TextFormField(
                  controller: descriptionController,
                  keyboardType: TextInputType.text,
                  autocorrect: false,
                  enabled: false,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Beschreibung',
                    border: OutlineInputBorder(),
                  ),
                ),

                SizedBox(height: 20),
                // ciphertext
                TextFormField(
                  controller: ciphertextController,
                  maxLines: 15,
                  maxLength: 700,
                  decoration: InputDecoration(
                    labelText: 'Ciphertext',
                    hintText: 'kopieren Sie den verschlüsselten Text in dieses Feld',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.grey,
                          textStyle: TextStyle(color: Colors.white)),
                      onPressed: () {
                        ciphertextController.text = '';
                      },
                      child: Text('Feld löschen'),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            textStyle: TextStyle(color: Colors.white)),
                        onPressed: () async {
                          final data =
                              await Clipboard.getData(Clipboard.kTextPlain);
                          ciphertextController.text = data!.text!;
                        },
                        child: Text('aus Zwischenablage einfügen'),
                      ),
                    ),
                  ],
                ),

                // private key recipient
                SizedBox(height: 20),
                // private key
                TextFormField(
                  controller: privateKeyController,
                  maxLines: 2,
                  maxLength: 60,
                  keyboardType: TextInputType.multiline,
                  autocorrect: false,
                  decoration: InputDecoration(
                    labelText: 'Privater Schlüssel des Empfängers',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Bitte den Schlüssel laden oder erzeugen';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            textStyle: TextStyle(color: Colors.white)),
                        onPressed: () async {
                          final data =
                          await Clipboard.getData(Clipboard.kTextPlain);
                          privateKeyController.text = data!.text!;
                        },
                        child: Text('Schlüssel aus Zwischenablage einfügen'),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.grey,
                          textStyle: TextStyle(color: Colors.white)),
                      onPressed: () {
                        privateKeyController.text = '';
                      },
                      child: Text('Feld löschen'),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            textStyle: TextStyle(color: Colors.white)),
                        onPressed: () async {
                          bool priKeyFileExists =
                          await _fileExistsPrivateKeyRec() as bool;
                          if (priKeyFileExists) {
                            await _readDataPrivateKeyRec();
                          }
                        },
                        child: Text('lokal laden'),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20),
                // public key
                TextFormField(
                  controller: publicKeySenController,
                  maxLines: 2,
                  maxLength: 50,
                  keyboardType: TextInputType.multiline,
                  autocorrect: false,
                  //enabled: false,
                  decoration: InputDecoration(
                    labelText: 'Öffentlicher Schlüssel des Senders',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Bitte den Schlüssel laden oder erzeugen';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            textStyle: TextStyle(color: Colors.white)),
                        onPressed: () async {
                          final data =
                              await Clipboard.getData(Clipboard.kTextPlain);
                          publicKeySenController.text = data!.text!;
                        },
                        child: Text('Schlüssel aus Zwischenablage einfügen'),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.grey,
                            textStyle: TextStyle(color: Colors.white)),
                        onPressed: () {
                          publicKeySenController.text = '';
                        },
                        child: Text('Feld löschen'),
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            textStyle: TextStyle(color: Colors.white)),
                        onPressed: () async {
                          bool pubKeyFileExists =
                              await _fileExistsPublicKeySen() as bool;
                          if (pubKeyFileExists) {
                            await _readDataPublicKeySen();
                          }
                        },
                        child: Text('lokal laden'),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.grey,
                            textStyle: TextStyle(color: Colors.white)),
                        onPressed: () {
                          ciphertextController.text = '';
                          privateKeyController.text = '';
                          publicKeySenController.text = '';
                          outputController.text = '';
                        },
                        child: Text('Formulardaten löschen'),
                      ),
                    ),
                    SizedBox(width: 25),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            textStyle: TextStyle(color: Colors.white)),
                        onPressed: () async {
                          // Wenn alle Validatoren der Felder des Formulars gültig sind.
                          if (_formKey.currentState!.validate()) {
                            String jsonAsymmetricEncryption =
                                ciphertextController.text;
                            String privateKeyRecPem = privateKeyController.text;
                            String publicKeySenPem = publicKeySenController.text;
                            String algorithm = '';
                            String ciphertextBase64 = '';
                            String publicKeySenBase64 = '';
                            try {
                              final parsedJson =
                                  json.decode(jsonAsymmetricEncryption);
                              algorithm = parsedJson['algorithm'];
                              ciphertextBase64 = parsedJson['ciphertext'];
                              publicKeySenBase64 = parsedJson['public key sender'];
                            } on FormatException catch (e) {
                              outputController.text =
                                  'Fehler: Die Eingabe sieht nicht nach einem Json-Datensatz aus.';
                              return;
                            } on NoSuchMethodError catch (e) {
                              outputController.text =
                                  'Fehler: Die Eingabe ist ungültig.';
                              return;
                            }
                            if (algorithm != 'Curve25519 CryptoBox') {
                              outputController.text =
                                  'Fehler: es handelt sich nicht um einen Datensatz, der mit Curve25519 CryptoBox verschlüsselt worden ist.';
                              return;
                            }

                            Uint8List decryptedtext;
                            try {
                              final ciphertext = base64Decoding(ciphertextBase64);
                              final Uint8List privateKeyRec = base64Decoding(privateKeyRecPem);
                              final Uint8List publicKeySen = base64Decoding(publicKeySenPem);
                              final PrivateKey privateKey = PrivateKey(privateKeyRec);
                              final PublicKey publicKey = PublicKey(publicKeySen);
                              final receiverBox = Box(myPrivateKey: privateKey, theirPublicKey: publicKey);
                              decryptedtext = receiverBox.decrypt(EncryptedMessage.fromList(ciphertext));

                            } catch (error) {
                              outputController.text =
                                  'Die Entschlüsselung hat nicht funktioniert';
                              return;
                            }
                            // cleartext output
                            outputController.text = new String.fromCharCodes(decryptedtext);
                          } else {
                            print("Formular ist nicht gültig");
                          }
                        },
                        child: Text('Entschlüsseln'),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20),
                TextFormField(
                  controller: outputController,
                  maxLines: 3,
                  maxLength: 100,
                  decoration: InputDecoration(
                    labelText: 'Klartext',
                    hintText: 'hier steht der Klartext',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.grey,
                          textStyle: TextStyle(color: Colors.white)),
                      onPressed: () {
                        outputController.text = '';
                      },
                      child: Text('Feld löschen'),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            textStyle: TextStyle(color: Colors.white)),
                        onPressed: () async {
                          final data =
                              ClipboardData(text: outputController.text);
                          await Clipboard.setData(data);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  const Text('in die Zwischenablage kopiert'),
                            ),
                          );
                        },
                        child: Text('in Zwischenablage kopieren'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Uint8List createUint8ListFromString(String s) {
    var ret = new Uint8List(s.length);
    for (var i = 0; i < s.length; i++) {
      ret[i] = s.codeUnitAt(i);
    }
    return ret;
  }

  Uint8List base64Decoding(String input) {
    return base64.decode(input);
  }
}

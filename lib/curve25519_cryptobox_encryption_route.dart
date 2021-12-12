import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinenacl/api/authenticated_encryption.dart';
import 'package:pinenacl/x25519.dart';
import 'storage_rec.dart';
import 'storage.dart';

class Curve25519CryptoBoxRoute extends StatefulWidget {
  const Curve25519CryptoBoxRoute({Key? key}) : super(key: key);

  final String title = 'CryptoBox Verschlüsselung';

  @override
  _MyFormPageState createState() => _MyFormPageState();
}

class _MyFormPageState extends State<Curve25519CryptoBoxRoute> {
  @override
  void initState() {
    super.initState();
    descriptionController.text = txtDescription;
  }

  final _formKey = GlobalKey<FormState>();
  TextEditingController descriptionController = TextEditingController();

  // the following controller have a default value
  TextEditingController plaintextController = TextEditingController(
      text: 'The quick brown fox jumps over the lazy dog');
  TextEditingController privateKeyController = TextEditingController();
  TextEditingController publicKeyRecController = TextEditingController();
  TextEditingController outputController = TextEditingController();

  String txtDescription = 'CryptoBox Verschlüsselung.'
      ' Alle Schlüssel sind Base64 encoded.'
  ' Zur Verschlüsselung wird der eigene Private key (Sender) und der'
  ' Public key des Empfängers benötigt.';

  String _returnJson(String data) {
    var parts = data.split(':');
    var algorithm = parts[0];
    var ciphertext = parts[1];
    var publicKeySender = parts[2];

    JsonAsymmetricEncryption jsonAsymmetricEncryption = JsonAsymmetricEncryption(
        algorithm: algorithm, ciphertext: ciphertext, publicKeySender: publicKeySender);

    String encryptionResult = jsonEncode(jsonAsymmetricEncryption);
    // make it pretty
    var object = json.decode(encryptionResult);
    var prettyEncryptionResult2 = JsonEncoder.withIndent('  ').convert(object);
    return prettyEncryptionResult2;
  }

  Future<bool> _fileExistsPrivateKey() async {
    bool ergebnis = false;
    await Storage().filePrivateKeyExists().then((bool value) {
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

  Future<void> _readDataPrivateKey() async {
    Storage().readDataPrivateKey().then((String value) {
      setState(() {
        privateKeyController.text = value;
      });
    });
  }

  Future<bool> _fileExistsPublicKeyRec() async {
    bool ergebnis = false;
    await StorageRec().filePublicKeyExists().then((bool value) {
      setState(() {
        if (value == true) {
          publicKeyRecController.text = 'Datei existiert ';
        } else {
          publicKeyRecController.text = 'Datei existiert NICHT';
        }
        ergebnis = value;
      });
    });
    return ergebnis;
  }

  Future<void> _readDataPublicKeyRec() async {
    StorageRec().readDataPublicKey().then((String value) {
      setState(() {
        publicKeyRecController.text = value;
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
                //SizedBox(height: 20),
                // form description
                TextFormField(
                  controller: descriptionController,
                  keyboardType: TextInputType.text,
                  autocorrect: false,
                  enabled: false,
                  // false = disabled, true = enabled
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Beschreibung',
                    border: OutlineInputBorder(),
                  ),
                ),

                SizedBox(height: 20),
                // plaintext
                TextFormField(
                  controller: plaintextController,
                  maxLines: 3,
                  maxLength: 100,
                  keyboardType: TextInputType.multiline,
                  autocorrect: false,
                  decoration: InputDecoration(
                    labelText: 'Klartext',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Bitte Daten eingeben';
                    }
                    return null;
                  },
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
                          plaintextController.text = '';
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
                          plaintextController.text = data!.text!;
                        },
                        child: Text('aus Zwischenablage einfügen'),
                      ),
                    ),
                  ],
                ),

                // private key
                SizedBox(height: 20),
                // private key
                TextFormField(
                  controller: privateKeyController,
                  maxLines: 2,
                  maxLength: 60,
                  keyboardType: TextInputType.multiline,
                  autocorrect: false,
                  decoration: InputDecoration(
                    labelText: 'Privater Schlüssel des Senders',
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
                              await _fileExistsPrivateKey() as bool;
                          if (priKeyFileExists) {
                            await _readDataPrivateKey();
                          }
                        },
                        child: Text('lokal laden'),
                      ),
                    ),
                  ],
                ),

                // public key of the recipient
                SizedBox(height: 20),
                // public key
                TextFormField(
                  controller: publicKeyRecController,
                  maxLines: 2,
                  maxLength: 60,
                  keyboardType: TextInputType.multiline,
                  autocorrect: false,
                  decoration: InputDecoration(
                    labelText: 'Öffentlicher Schlüssel des Empfängers',
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
                          publicKeyRecController.text = data!.text!;
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
                        publicKeyRecController.text = '';
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
                          bool publicKeyFileExists =
                          await _fileExistsPublicKeyRec() as bool;
                          if (publicKeyFileExists) {
                            await _readDataPublicKeyRec();
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
                          plaintextController.text = '';
                          privateKeyController.text = '';
                          publicKeyRecController.text = '';
                          outputController.text = '';
                        },
                        child: Text('Formulardaten löschen'),
                      ),
                    ),
                    SizedBox(width: 25),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            textStyle: TextStyle(color: Colors.white)),
                        onPressed: () {
                          // Wenn alle Validatoren der Felder des Formulars gültig sind.
                          if (_formKey.currentState!.validate()) {
                            String plaintext = plaintextController.text;
                            String privateKeyPem = privateKeyController.text;
                            String publicKeyRecPem = publicKeyRecController.text;

                            String ciphertextBase64 = '';
                            try {
                              Uint8List dataToEncryptBytes = createUint8ListFromString(plaintext);
                              final Uint8List privateKey = base64Decoding(privateKeyPem);
                              final Uint8List publicKey = base64Decoding(publicKeyRecPem);
                              final privateKeySen = PrivateKey(privateKey);
                              final publicKeyRec = PublicKey(publicKey);
                              final senderBox = Box(myPrivateKey: privateKeySen, theirPublicKey: publicKeyRec);
                              final ciphertext = senderBox.encrypt(dataToEncryptBytes);
                              ciphertextBase64 = base64Encoding(ciphertext.asTypedList);
                            } catch (error) {
                              outputController.text = 'Fehler beim Verschlüsseln';
                              return;
                            }
                            // build output string
                            String _formdata = 'Curve25519 CryptoBox' +
                                ':' +
                                ciphertextBase64 +
                                ':' +
                                '';
                            String jsonOutput = _returnJson(_formdata);
                            outputController.text = jsonOutput;
                          } else {
                            print("Formular ist nicht gültig");
                          }
                        },
                        child: Text('verschlüsseln'),
                      ),
                  ],
                ),

                SizedBox(height: 20),
                TextFormField(
                  controller: outputController,
                  maxLines: 15,
                  maxLength: 700,
                  decoration: InputDecoration(
                    labelText: 'Ausgabe',
                    hintText: 'Ausgabe',
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
                              content: const Text(
                                  'Daten in die Zwischenablage kopiert'),
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

  String base64Encoding(Uint8List input) {
    return base64.encode(input);
  }

  Uint8List base64Decoding(String input) {
    return base64.decode(input);
  }
}

class JsonAsymmetricEncryption {
  JsonAsymmetricEncryption({
    required this.algorithm,
    required this.ciphertext,
    required this.publicKeySender,
  });

  final String algorithm;
  final String ciphertext;
  final String publicKeySender;

  Map toJson() => {
        'algorithm': algorithm,
        'ciphertext': ciphertext,
        'public key sender': publicKeySender,
      };
}

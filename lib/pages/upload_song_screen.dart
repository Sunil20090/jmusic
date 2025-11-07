import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jmusic/components/colored_button.dart';
import 'package:jmusic/components/floating_label_edit_box.dart';
import 'package:jmusic/components/generic/selector_screen.dart';
import 'package:jmusic/components/progress_circular.dart';
import 'package:jmusic/components/round_it.dart';
import 'package:jmusic/constants/theme_constant.dart';
import 'package:jmusic/constants/url_constant.dart';
import 'package:jmusic/modals/pair_modal.dart';
import 'package:jmusic/utils/api_service.dart';
import 'package:jmusic/utils/common_function.dart';

class UploadSongScreen extends StatefulWidget {
  const UploadSongScreen({super.key});

  @override
  State<UploadSongScreen> createState() => _UploadSongScreenState();
}

class _UploadSongScreenState extends State<UploadSongScreen> {
  File? _musicFile, _imageFile;
  bool _uploadingFile = false;

  var _albumList = [];

  TextEditingController _nameCotroller = TextEditingController();
  TextEditingController _artistCotroller = TextEditingController();
  TextEditingController _albumController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _nameCotroller.dispose();
    _artistCotroller.dispose();
    _albumController.dispose();
  }

  @override
  void initState() {
    super.initState();

    _initAlbumList();
  }

  _initAlbumList() async {
    ApiResponse response = await getService(URL_GET_ALBUM_LIST);

    if (response.isSuccess) {
      setState(() {
        _albumList = response.body;
      });
      print(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: COLOR_PRIMARY,
          title: Text(
            'Upload Songs',
            style: getTextTheme(color: COLOR_PRIMARY).headlineLarge,
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: SCREEN_PADDING,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FloatingLabelEditBox(
                  labelText: 'Name',
                  controller: _nameCotroller,
                ),
                addVerticalSpace(),
                FloatingLabelEditBox(
                  labelText: 'Artist names',
                  controller: _artistCotroller,
                ),
                addVerticalSpace(),
                FloatingLabelEditBox(
                  labelText: 'Album',
                  controller: _albumController,
                ),

                addVerticalSpace(),

                RoundIt(
                  child: ColoredButton(
                    onPressed: () {
                      openChooseScreen();
                    },
                    child: Text(
                      'Choose Existing Album',
                      style: getTextTheme(color: COLOR_WHITE).titleMedium,
                    ),
                  ),
                ),

                addVerticalSpace(),

                Divider(),
                RoundIt(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ColoredButton(
                        onPressed: () {
                          chooseMusicFile();
                        },
                        child: Text(
                          'Choose Music File',
                          style: getTextTheme(color: COLOR_WHITE).titleMedium,
                        ),
                      ),
                      if (_musicFile != null)
                        Row(
                          children: [
                            addHorizontalSpace(),
                            Text('Attached', style: getTextTheme().titleSmall),
                            Icon(Icons.check),
                          ],
                        ),
                    ],
                  ),
                ),
                Divider(),
                addVerticalSpace(),
                Row(
                  children: [
                    RoundIt(
                      child: ColoredButton(
                        onPressed: () {
                          chooseImageFile();
                        },
                        child: Text(
                          'Choose Image File',
                          style: getTextTheme(color: COLOR_WHITE).titleMedium,
                        ),
                      ),
                    ),
                    if (_imageFile != null)
                      RoundIt(
                        child: SizedBox(
                          width: 100,
                          height: 100,
                          child: Image.file(_imageFile!),
                        ),
                      ),
                  ],
                ),

                addVerticalSpace(DEFAULT_LARGE_SPACE),
                ColoredButton(
                  onPressed: !(_uploadingFile)
                      ? () {
                          uploadSong();
                        }
                      : null,
                  child: (!_uploadingFile)
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Upload Song!',
                              style: getTextTheme(
                                color: COLOR_WHITE,
                              ).titleMedium,
                            ),
                          ],
                        )
                      : ProgressCircular(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  chooseImageFile() async {
    _imageFile = await getLocalImage(ImageSource.gallery);
    setState(() {});
  }

  chooseMusicFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3', 'wav', 'm4a'],
    );

    

    if (result != null) {
      _nameCotroller.text = result.files.first.name;
      
      _musicFile = File(result.files.single.path!);
      setState(() {});
    }
  }

  void uploadSong() async {
    if (_musicFile == null) {
      showAlert(context, 'Error!', "Music file is not attached", isError: true);
      return;
    }

    if (_nameCotroller.text.isEmpty) {
      showAlert(
        context,
        'Error!',
        "Enter the name of music file",
        isError: true,
      );
      return;
    }
    String base64 = await fileToBase64(_musicFile!);
    String? imageBase64;
    if (_imageFile != null) {
      imageBase64 = await fileToBase64(_imageFile!);
    }

    var body = {
      "name": _nameCotroller.text.trim(),
      "artist": _artistCotroller.text.trim(),
      "album": _albumController.text.trim(),
      "base64": base64,
      "imageBase64": imageBase64,
    };

    setState(() {
      _uploadingFile = true;
    });

    ApiResponse response = await postService(URL_UPLOAD_SONG, body);

    setState(() {
      _uploadingFile = false;
    });

    if (response.isSuccess) {
      showAlert(
        context,
        response.body['heading'],
        response.body['message'],
        onDismiss: () {
          Navigator.pop(context);
          Navigator.pop(context);
        },
      );
    }
  }

  void openChooseScreen() async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (builder) =>
            SelectorScreen(title: 'Albums', list: _albumList.cast<String>()),
      ),
    );

    if (result != null) {
      setState(() {
        _albumController.text = result;
      });
    }
  }
}

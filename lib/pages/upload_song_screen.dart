import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:jmusic/components/colored_button.dart';
import 'package:jmusic/components/floating_label_edit_box.dart';
import 'package:jmusic/components/progress_circular.dart';
import 'package:jmusic/components/round_it.dart';
import 'package:jmusic/constants/theme_constant.dart';
import 'package:jmusic/constants/url_constant.dart';
import 'package:jmusic/utils/api_service.dart';
import 'package:jmusic/utils/common_function.dart';

class UploadSongScreen extends StatefulWidget {
  const UploadSongScreen({super.key});

  @override
  State<UploadSongScreen> createState() => _UploadSongScreenState();
}

class _UploadSongScreenState extends State<UploadSongScreen> {

  File? _musicFile;
  bool _uploadingFile = false;
  TextEditingController _nameCotroller = TextEditingController();
  TextEditingController _artistCotroller = TextEditingController();
  TextEditingController _albumController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: CONTENT_PADDING,
          child: Column(
            children: [
              addVerticalSpace(DEFAULT_LARGE_SPACE * 3),
              FloatingLabelEditBox(labelText: 'Name', controller: _nameCotroller,),
              addVerticalSpace(),
              FloatingLabelEditBox(labelText: 'Artist names', controller: _artistCotroller,),
              addVerticalSpace(),
                FloatingLabelEditBox(
                labelText: 'Album',
                controller: _albumController,
              ),
              addVerticalSpace(),
      
              RoundIt(
                child: ColoredButton(
                  onPressed: (){
                    chooseMusicFile();
                  },
                  child: Text('Choose File', style: getTextTheme(color: COLOR_WHITE).titleMedium,))
              ),

              addVerticalSpace(),
               RoundIt(
                child: ColoredButton(
                  onPressed: () {
                    chooseMusicFile();
                  },
                  child: Text(
                    'Choose Image File',
                    style: getTextTheme(color: COLOR_WHITE).titleMedium,
                  ),
                ),
              ),
      
              addVerticalSpace(DEFAULT_LARGE_SPACE),
              ColoredButton(
                onPressed: !(_uploadingFile) ? (){
                  uploadSong();
                } : null,
                child: (!_uploadingFile) ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Upload Song!', style: getTextTheme(color: COLOR_WHITE).titleMedium,)
                ],
              ) : ProgressCircular()
              )
                      
            ],
          ),
        ),
      ),
    );
  }


  chooseImageFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
  }

  chooseMusicFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3', 'wav', 'm4a']

    );

    if(result != null){
      _musicFile = File(result.files.single.path!);

    }
  }
  
  void uploadSong() async  {
    if(_musicFile != null){

      String base64 = await fileToBase64(_musicFile!);

      var body = {
        "name" : _nameCotroller.text,
        "artist" : _artistCotroller.text,
        "album" : _albumController.text,
        "base64" : base64
      };

      setState(() {
        _uploadingFile = true;
      });

      ApiResponse response = await postService(URL_UPLOAD_SONG, body);

      setState(() {
        _uploadingFile = false;
      });

      if(response.isSuccess){
        showAlert(context, response.body['heading'], response.body['message']);
      }


    }else {
      showAlert(context, 'Error!', "File is not attached", isError: true);

    }
  }
}
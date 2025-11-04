class SongModal {
  int id;
  bool isFavourite;
  String title, song_url, artist;
  String? thumbnail;

  SongModal({
    required this.id,
    required this.title,
    required this.artist,
    required this.song_url,
    this.thumbnail,
    this.isFavourite = false,
  });

  static SongModal fromJson(obj) {
    return SongModal(
      id: obj['id'],
      title: obj['title'],
      artist: obj['artist'],
      song_url: obj['song_url'],
      thumbnail: obj['thumbnail'],
      isFavourite: obj['isFavourite'] == 1,
    );
  }

  static SongModal dummy() {
    return SongModal(
      id: 0,
      title: 'title',
      artist: 'artist',
      song_url: 'song_url',
    );
  }
}

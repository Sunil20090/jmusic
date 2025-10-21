class SongModal {
  int id;
  String title, song_url, artist;
  String? thumbnail;

  SongModal({
    required this.id,
    required this.title,
    required this.artist,
    required this.song_url,
    this.thumbnail,
  });

  static SongModal fromJson(obj) {
    return SongModal(
      id: obj['id'],
      title: obj['title'],
      artist: obj['artist'],
      song_url: obj['song_url'],
      thumbnail: obj['thumbnail']
    );
  }
}

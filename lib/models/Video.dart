class Video {
  final String ytId;
  final String namaVideo;

  Video(this.ytId, this.namaVideo);
  factory Video.fromMap(Map<String, dynamic> data) {
    return Video(data["ytId"], data["namaVideo"]);
  }
}

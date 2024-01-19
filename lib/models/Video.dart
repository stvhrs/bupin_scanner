class Video {
  final String ytId;
  final String namaVideo;
  final String linkVideo;

  Video(this.ytId, this.namaVideo, this.linkVideo);
  factory Video.fromMap(Map<String, dynamic> data) {
    return Video(
        (data["ytid"] as String).isEmpty
            ? data["ytidDmp"]
            : (data["ytid"] as String),
        (data["namaSubMateri"] as String).isEmpty
            ? data["namaVideoDmp"]
            : data["namaSubMateri"],
        (data["linkVideo"] as String).isEmpty
            ? data["linkDmp"]
            : data["linkVideo"]);
  }
}

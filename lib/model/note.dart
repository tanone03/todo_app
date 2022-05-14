class Note {
  final int id;
  final String text;

  const Note({
    required this.id,
    required this.text,
  });

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'text': text,
    };
  }

  Note.fromMap(Map<String, dynamic> res) : 
    id = res["id"],
    text = res["text"];
  
  @override
  String toString() {
    return 'id $id;  text $text';
  }
}
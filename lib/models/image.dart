class ImageGenerationResult {
  final int created;
  final List<ImageData> data;

  ImageGenerationResult({required this.created, required this.data});

  factory ImageGenerationResult.fromJson(Map<String, dynamic> json) {
    return ImageGenerationResult(
      created: json['created'],
      data: List<ImageData>.from(
        json['data'].map((x) => ImageData.fromJson(x)),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        'created': created,
        'data': List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class ImageData {
  final String revisedPrompt;
  final String url;

  ImageData({required this.revisedPrompt, required this.url});

  factory ImageData.fromJson(Map<String, dynamic> json) {
    return ImageData(
      revisedPrompt: json['revised_prompt'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() => {
        'revised_prompt': revisedPrompt,
        'url': url,
      };
}
